function [Precision,Recall,F1] = computeMetrics(TP,FP,FN)
%:::computeMetrics:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%Computes precision, recall and F1 score from given TP, FP and FN values
%Input:
%   -TP: Number of true positives
%   -FP: Number of false positives
%   -FN: Number of false negatives
%Output:
%   -Precision: TP/(TP+FP)
%   -Recal: TP/(TP+FN)
%   -F1: 2*((Precision*Recall)/(Precision+Recall))
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
Precision = TP ./ (TP+FP);
Recall = TP ./ (TP+FN);
F1 = (2*Precision.*Recall) ./ (Precision + Recall);

end

