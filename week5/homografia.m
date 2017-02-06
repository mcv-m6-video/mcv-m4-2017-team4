function [H]=homografia(params)
%     imshow(uint8(frame));
    x1=params.reference;
    x1 = makehomogeneous(x1');
    x2 = [0 0; 0 200; 200 200; 200 0];
    x2 = makehomogeneous(x2');
    
    H = homography2d(x1, x2);
end