function m4_week5_task1b()
    params=struct;
    params.rho=0.05; 
    params.alpha=2.5;
    params.dt = 1;
    sequence_db=struct;    
    
%     sequence_db.frames=[950 1050];
%     sequence_db.path='./traffic/';
%     params.reference=[20 83; 136 1; 135 240;320 111];
%     sequence=[sequence_db.frames(1):sequence_db.frames(2)];
%     params.time=3.0/30.0;
%     params.km=3.6;
%     params.pixel=9.0/78.0;
       
    sequence_db.frames=[1050, 1350];
    sequence_db.path='./highway/';
    params.reference=[10.0522 190.8483;190.7488 24.0821;273.9328 20.1020;263.9826 239.4055];
    params.fps=25;
    params.km=3.6;
    params.pixel=10/13;
    sequence=[sequence_db.frames(1):sequence_db.frames(2)];
    
    train_folder=strcat(sequence_db.path,'input/');
    gt_folder=strcat(sequence_db.path,'groundtruth/');  
    
    input_path='input/';
    input_name='in';
%     new_folder='./traffic/input/';
%     new_gt='./traffic/groundtruth/';
      
    [params.mean,params.var]=compute_mean_std(sequence_db,input_path,input_name);
    
    % Create System objects used for reading video, detecting moving objects,
    % and displaying the results.
    obj = setupSystemObjects();
    tracks = initializeTracks(); % Create an empty array of tracks.

    nextId = 1; % ID of the next track
    trackedObjs = [];
    H=homografia(params);
    for count_seq=1:size(sequence,2)

        'SEQUENCIA'
        disp(sequence(count_seq))

        % Read in new frame
        image_name_curr=sprintf('in%06d',sequence(count_seq));
        current_frame=strcat(train_folder,image_name_curr,'.jpg');
        frame=imread(current_frame);
 
        [centroids, bboxes, mask, params] = detectObjects(frame, params);
        predictNewLocationsOfTracks(count_seq);
        [assignments, unassignedTracks, unassignedDetections] = detectionToTrackAssignment();

        updateAssignedTracks();
        updateUnassignedTracks();
        deleteLostTracks();
        createNewTracks();

        displayTrackingResults();
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function obj = setupSystemObjects()
        % Initialize Video I/O
        % Create objects for reading a video from a file, drawing the tracked
        % objects in each frame, and playing the video.

        % Create two video players, one to display the video,
        % and one to display the foreground mask.
        obj.videoPlayer = vision.VideoPlayer('Position', [20, 400, 700, 400]);
        obj.maskPlayer = vision.VideoPlayer('Position', [740, 400, 700, 400]);

        % Create System objects for foreground detection and blob analysis

        % The foreground detector is used to segment moving objects from
        % the background. It outputs a binary mask, where the pixel value
        % of 1 corresponds to the foreground and the value of 0 corresponds
        % to the background.

        obj.detector = vision.ForegroundDetector('NumGaussians', 2, 'NumTrainingFrames', 40, 'MinimumBackgroundRatio', 0.07);

        % Connected groups of foreground pixels are likely to correspond to moving
        % objects.  The blob analysis System object is used to find such groups
        % (called 'blobs' or 'connected components'), and compute their
        % characteristics, such as area, centroid, and the bounding box.

        obj.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
            'AreaOutputPort', true, 'CentroidOutputPort', true, ...
            'MinimumBlobArea', 400);
    end

    function tracks = initializeTracks()
        % create an empty array of tracks
        tracks = struct(...
            'id', {}, ...
            'bbox', {}, ...
            'particleFilter', {}, ...
            'centroid', {}, ...
            'lastBestGuess', {}, ...
            'age', {}, ...
            'totalVisibleCount', {}, ...
            'consecutiveInvisibleCount', {});
    end

    function [centroids, bboxes, mask,params] = detectObjects(frame,params)

%         % Detect foreground.
%         mask = obj.detector.step(frame);
% 
%         % Apply morphological operations to remove noise and fill in holes.
%         mask = imopen(mask, strel('rectangle', [3,3]));
%         mask = imclose(mask, strel('rectangle', [15, 15]));
%         mask = imfill(mask, 'holes');
        [mask,params] = adaptative_model(frame,params);

        % Perform blob analysis to find connected components.
        [~, centroids, bboxes] = obj.blobAnalyser.step(mask);
    end

    function predictNewLocationsOfTracks(count_seq)
        for i = 1:length(tracks)
            bbox = tracks(i).bbox;
            uCmd(1) = 0.7*abs(sin(count_seq)) + 0.1;  % linear velocity
            uCmd(2) = 0.08*cos(count_seq);            % angular velocity
            % Predict the current location of the track.
            [statePred, covPred] = predict(tracks(i).particleFilter,params.dt,uCmd);

            % Shift the bounding box so that its center is at
            % the predicted location.
            predictedCentroid = int32(statePred(1:2)) - bbox(3:4) / 2;
            tracks(i).bbox = [predictedCentroid, bbox(3:4)];
        end
    end

    function [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment()

        nTracks = length(tracks);
        nDetections = size(centroids, 1);

        % Compute the cost of assigning each detection to each track.
        cost = zeros(nTracks, nDetections);
        for i = 1:nTracks
            cost(i, :) = distance(tracks(i).centroid, centroids);
        end

        % Solve the assignment problem.
        costOfNonAssignment = 20;
        [assignments, unassignedTracks, unassignedDetections] = ...
            assignDetectionsToTracks(cost, costOfNonAssignment);
    end

    function updateAssignedTracks()
        numAssignedTracks = size(assignments, 1);
        for i = 1:numAssignedTracks
            trackIdx = assignments(i, 1);
            detectionIdx = assignments(i, 2);
            centroid = centroids(detectionIdx, :);
            bbox = bboxes(detectionIdx, :);

            % Correct the estimate of the object's location
            % using the new detection.
            correct(tracks(trackIdx).particleFilter, [centroid 0]);

            % Replace predicted bounding box with detected
            % bounding box.
            tracks(trackIdx).bbox = bbox;

            % Update track's age.
            tracks(trackIdx).age = tracks(trackIdx).age + 1;

            % Update visibility.
            tracks(trackIdx).totalVisibleCount = ...
                tracks(trackIdx).totalVisibleCount + 1;
            tracks(trackIdx).consecutiveInvisibleCount = 0;
            
            trackIdx_found = tracks(trackIdx).id;
            trackedObjs{trackIdx_found}.centroid(end+1, :) = centroid;
        end
    end
    function updateUnassignedTracks()
        for i = 1:length(unassignedTracks)
            ind = unassignedTracks(i);
            tracks(ind).age = tracks(ind).age + 1;
            tracks(ind).consecutiveInvisibleCount = ...
                tracks(ind).consecutiveInvisibleCount + 1;
        end
    end

    function deleteLostTracks()
        if isempty(tracks)
            return;
        end

        invisibleForTooLong = 3;
        ageThreshold = 8;

        % Compute the fraction of the track's age for which it was visible.
        ages = [tracks(:).age];
        totalVisibleCounts = [tracks(:).totalVisibleCount];
        visibility = totalVisibleCounts ./ ages;

        % Find the indices of 'lost' tracks.
        lostInds = (ages < ageThreshold & visibility < 0.6) | ...
            [tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong;
        if lostInds > 0
            for speedIdx = 1:length(lostInds)
                trackHistorial = trackedObjs{tracks(lostInds(speedIdx)).id};
                speed = compute_speed(trackHistorial, H,params);
                trackedObjs{tracks(lostInds(speedIdx)).id}.speed = speed;
                
            end
        end
        % Delete lost tracks.
        tracks = tracks(~lostInds);
    end

    function createNewTracks()
        centroids = centroids(unassignedDetections, :);
        bboxes = bboxes(unassignedDetections, :);

        for i = 1:size(centroids, 1)

            centroid = centroids(i,:);
            bbox = bboxes(i, :);

            % Create a Particle filter object.
            particleFilter = robotics.ParticleFilter;
            
            initialize(particleFilter, 5000, [centroid(1:2),0 , 0, 0, 0], eye(6), 'CircularVariables',[0 0 1 0 0 0]);
            particleFilter.StateEstimationMethod = 'mean';
            particleFilter.ResamplingMethod = 'systematic';

            % StateTransitionFcn defines how particles evolve without measurement
            particleFilter.StateTransitionFcn = @CarStateTransition;

            % MeasurementLikelihoodFcn defines how measurement affect the our estimation
            particleFilter.MeasurementLikelihoodFcn = @CarMeasurementLikelihood;

            % Last best estimation for x, y and theta
            lastBestGuess = [0 0 0];
            % Create a new track.
            newTrack = struct(...
                'id', nextId, ...
                'bbox', bbox, ...
                'particleFilter', particleFilter, ...
                'centroid', centroid, ...
                'lastBestGuess', lastBestGuess, ...
                'age', 1, ...
                'totalVisibleCount', 1, ...
                'consecutiveInvisibleCount', 0);

            % Add it to the array of tracks.
            tracks(end + 1) = newTrack;

            % Increment the next id.
            nextId = nextId + 1;
            object.id = newTrack.id;
            object.centroid = centroid;
            if length(trackedObjs) < object.id
                trackedObjs{end+1} = object;
            else
                trackedObjs{object.id} = object;
            end
        end
    end

    function displayTrackingResults()
        % Convert the frame and the mask to uint8 RGB.
        frame = im2uint8(frame);
        mask = uint8(repmat(mask, [1, 1, 3])) .* 255;

        minVisibleCount = 8;
        if ~isempty(tracks)

            % Noisy detections tend to result in short-lived tracks.
            % Only display tracks that have been visible for more than
            % a minimum number of frames.
            reliableTrackInds = ...
                [tracks(:).totalVisibleCount] > minVisibleCount;
            reliableTracks = tracks(reliableTrackInds);        
            speeds={[]};
            for i=1:length(reliableTracks)
                % Speed estimation
                trackHistorial = trackedObjs{reliableTracks(i).id};
                if size(trackHistorial.centroid, 1) > 1
                    speed = compute_speed(trackHistorial, H,params);
                    trackedObjs{reliableTracks(i).id}.speed = speed;
                    speeds{i} = ['  ' num2str(speed)];
                else
                    speeds{i} = ['  ' num2str(0)];
                end
            end
            
            
            % Display the objects. If an object has not been detected
            % in this frame, display its predicted bounding box.
            if ~isempty(reliableTracks)
                % Get bounding boxes.
                bboxes = cat(1, reliableTracks.bbox);

                % Get ids.
                ids = int32([reliableTracks(:).id]);

                % Create labels for objects indicating the ones for
                % which we display the predicted rather than the actual
                % location.
                labels = cellstr(int2str(ids'));
                predictedTrackInds = ...
                    [reliableTracks(:).consecutiveInvisibleCount] > 0;
                isPredicted = cell(size(labels));
                isPredicted(predictedTrackInds) = {' predicted'};
                labels = strcat(labels,speeds', isPredicted);

                % Draw the objects on the frame.
                frame = insertObjectAnnotation(frame, 'rectangle', ...
                    bboxes, labels);

                % Draw the objects on the mask.
                mask = insertObjectAnnotation(mask, 'rectangle', ...
                    bboxes, labels);
            end
        end

        % Display the mask and the frame.
        obj.maskPlayer.step(mask);
        obj.videoPlayer.step(frame);
    end

    function predictParticles = CarStateTransition(pf, prevParticles, dT, u)

       thetas = prevParticles(:,3);

       w = u(2);
       v = u(1);

       l = length(prevParticles);

       % Generate velocity samples
       sd1 = 0.3;
       sd2 = 1.5;
       sd3 = 0.02;
       vh = v + (sd1)^2*randn(l,1);
       wh = w + (sd2)^2*randn(l,1);
       gamma = (sd3)^2*randn(l,1);

       % Add a small number to prevent div/0 error
       wh(abs(wh)<1e-19) = 1e-19;

       % Convert velocity samples to pose samples
       predictParticles(:,1) = prevParticles(:,1) - (vh./wh).*sin(thetas) + (vh./wh).*sin(thetas + wh*dT);
       predictParticles(:,2) = prevParticles(:,2) + (vh./wh).*cos(thetas) - (vh./wh).*cos(thetas + wh*dT);
       predictParticles(:,3) = prevParticles(:,3) + wh*dT + gamma*dT;
       predictParticles(:,4) = (- (vh./wh).*sin(thetas) + (vh./wh).*sin(thetas + wh*dT))/dT;
       predictParticles(:,5) = ( (vh./wh).*cos(thetas) - (vh./wh).*cos(thetas + wh*dT))/dT;
       predictParticles(:,6) = wh + gamma;
    end

   function  likelihood = CarMeasurementLikelihood(pf, predictParticles, measurement)

       % The measurement contains all state variables
       predictMeasurement = predictParticles;

       % Calculate observed error between predicted and actual measurement
       % NOTE in this example, we don't have full state observation, but only
       % the measurement of current pose, therefore the measurementErrorNorm
       % is only based on the pose error.
       measurementError = bsxfun(@minus, predictMeasurement(:,1:3), measurement);
       measurementErrorNorm = sqrt(sum(measurementError.^2, 2));

       % Normal-distributed noise of measurement
       % Assuming measurements on all three pose components have the same error distribution
       measurementNoise = eye(3);

       % Convert error norms into likelihood measure.
       % Evaluate the PDF of the multivariate normal distribution
       likelihood = 1/sqrt((2*pi).^3 * det(measurementNoise)) * exp(-0.5 * measurementErrorNorm);

   end

end 
