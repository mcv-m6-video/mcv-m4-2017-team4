function [precision recall F1_score]=get_measures(TP,TN,FP,FN)
    precision=TP/(TP+FP);
    recall=TP/(TP+FN);
    F1_score=2*((precision*recall)/(precision+recall));

end