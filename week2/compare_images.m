function [TP FP FN TN] = compare_images(imBinary, imGT)
    % Compares a binary frames with the groundtruth frame
    
    TP = sum(sum(imGT>=255&imBinary==1));		% True Positive 
    TN = sum(sum(imGT<=50&imBinary==0));		% True Negative
    FP = sum(sum((imGT<=50)&imBinary==1));	% False Positive
    FN = sum(sum(imGT>=255&imBinary==0));		% False Negative
    SE = sum(sum(imGT==50&imBinary==1));		% Shadow Error
end