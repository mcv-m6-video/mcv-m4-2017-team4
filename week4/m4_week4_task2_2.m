function m4_week4_task2_2()
    sequence=[950:1050];
    train_folder='./traffic/input/';
    gt_folder='./optical_flow/training/flow_noc/'; 
    v = VideoWriter('traffic_2.mp4')
    open(v)
    
    
    % Process all frames in the video
    image_name_curr=sprintf('in%06d',sequence(1));
    current_frame=strcat(train_folder,image_name_curr,'.jpg');
    previous_image =imread(current_frame);
    writeVideo(v,previous_image);
    imgB=previous_image;
    
    for count_seq=2:size(sequence,2)

        'SEQUENCIA'
        disp(sequence(count_seq))
        
        % Read in new frame
        imgA = rgb2gray(imgB); % z^-1
        image_name_curr=sprintf('in%06d',sequence(count_seq));
        current_frame=strcat(train_folder,image_name_curr,'.jpg');
        current_image=imread(current_frame);
        imgB =rgb2gray(current_image);
        % Estimate transform from frame A to frame B, and fit as an s-R-t
        ptThresh = 300;
        pointsA = detectSURFFeatures(imgA,'MetricThreshold',ptThresh);
        pointsB = detectSURFFeatures(imgB,'MetricThreshold',ptThresh);
        [featuresA, pointsA] = extractFeatures(imgA, pointsA);
        [featuresB, pointsB] = extractFeatures(imgB, pointsB);
        indexPairs = matchFeatures(featuresA, featuresB);
        pointsA = pointsA(indexPairs(:, 1), :);
        pointsB = pointsB(indexPairs(:, 2), :);
        [tform, pointsBm, pointsAm] = estimateGeometricTransform(pointsB, pointsA, 'affine');
        imgBp = imwarp(imgB, tform, 'OutputView', imref2d(size(imgB)));
        pointsBmp = transformPointsForward(tform, pointsBm.Location);
        % Extract scale and rotation part sub-matrix.
        H = tform.T;
        R = H(1:2,1:2);
        % Compute theta from mean of two possible arctangents
        theta = mean([atan2(R(2),R(1)) atan2(-R(3),R(4))]);
        % Compute scale from mean of two stable mean calculations
        scale = mean(R([1 4])/cos(theta));
        % Translation remains the same:
        translation = H(3, 1:2);
        % Reconstitute new s-R-t transform:
        HsRt = [[scale*[cos(theta) -sin(theta); sin(theta) cos(theta)];translation], [0 0 1]'];
        imgB = imwarp(current_image, affine2d(HsRt), 'OutputView', imref2d(size(current_image)));

        
        writeVideo(v,imgB);
 
    end
    
    close(v)
end