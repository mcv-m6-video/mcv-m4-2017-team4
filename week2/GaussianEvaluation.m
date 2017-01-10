function [TP,FP,FN,TN,F1,Recall,Precision] = GaussianEvaluation(output,groundtruth)
    %Evaluation Metrics for the Non-recursive Gaussian modeling for background substraction
    %The function compute TP,FP,TN,FN,F1 of a set of images
    TP=0;FP=0;FN=0;TN=0;F1=0;Recall=0;Precision = 0;
    for i=1:size(output,3)
        [pixelTP, pixelFP, pixelFN, pixelTN]  = compare_images( output(:,:,i),groundtruth(:,:,i) );
        TP = TP + pixelTP;
        FP = FP + pixelFP;
        FN = FN + pixelFN;
        TN = TN + pixelTN;
    end
    [Precision,Recall,F1] = get_measures(TP,TN,FP,FN);
end