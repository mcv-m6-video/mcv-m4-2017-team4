function speed = compute_speed(track, H,params)

    initPoint1 = track.centroid(1, :); % x y
    endPoint1 = track.centroid(end, :); % x y

    numFrames = size(track.centroid, 1);
    
    initPoint1H = makehomogeneous(initPoint1');
    initPoint2H = H*initPoint1H;
    initPoint2(1) = initPoint2H(1) / initPoint2H(3);
    initPoint2(2) = initPoint2H(2) / initPoint2H(3);

    endPoint1H = makehomogeneous(endPoint1');
    endPoint2H = H*endPoint1H;
    endPoint2(1) = endPoint2H(1) / endPoint2H(3);
    endPoint2(2) = endPoint2H(2) / endPoint2H(3);

    distance = sqrt(sum((endPoint2 - initPoint2) .^ 2));

    speed = ((distance*params.pixel)/(numFrames/params.fps))*3.6;
end