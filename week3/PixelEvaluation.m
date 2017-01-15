function [pixelTP, pixelFP, pixelFN, pixelTN]  = PixelEvaluation( currentimage,ground )
%:::PixelEvaluation::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%Computes the number of TP,FP,FN and TN of a given image comparing with its
%grund truth.
%Input:
%   -currentimage: Input image for analysis
%   -ground: Corresponding gorund truth
%Output:
%   -pixelTP: number of pixels classified as true positives
%   -pixelFP: number of pixels classified as false positives
%   -pixelFN: number of pixels classified as false negatives
%   -pixelTN: number of pixels classified as true negatives
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
   pixelTP = sum(sum(currentimage==1 & ground==255));
   pixelFP = sum(sum(currentimage==1 & ground<=50));
   pixelFN = sum(sum(currentimage<=50 & ground==255));
   pixelTN = sum(sum(currentimage<=50 & ground<=50));

end

