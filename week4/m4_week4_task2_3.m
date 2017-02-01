function m4_week4_task2_3()
    
    filename='V_20170131_182049.mp4';
    v = VideoWriter('our_3');
    open(v)
    
    
    
    v_our = VideoReader(filename);
    hbm = vision.BlockMatcher('ReferenceFrameSource', 'Input port', 'BlockSize', [15 15]);
    hbm.OutputValue = 'Horizontal and vertical components in complex form';
    % Process all frames in the video
    previous_image =readFrame(v_our);
    writeVideo(v,[flip(previous_image) flip(previous_image)]);
    imgB=previous_image;
    
    while hasFrame(v_our)
        
        % Read in new frame
        imgA = rgb2gray(imgB);
        current_image=readFrame(v_our);
        imgB =rgb2gray(current_image);
        
        
        motion = step(hbm, double(imgA), double(imgB));
        Vx = real(mode(mode(motion)));
        Vy = imag(mode(mode(motion)));
        out = imtranslate(current_image,[-Vx -Vy]);
        
        
        % Estimate transform from frame A to frame B, and fit as an s-R-t
        ptThresh = 50;
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
      
        writeVideo(v,[flip(out) flip(imgB)]);
 
    end
    
    close(v)
    close(v_gt)
end