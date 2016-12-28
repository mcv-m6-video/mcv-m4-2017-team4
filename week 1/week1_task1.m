function m4_task1()
    directory_results='results_testAB_changedetection/results/highway/';
    directory_gt='results_testAB_changedetection/highway/groundtruth/';
    A=struct;
    A.TP=0;
    A.TN=0;
    A.FP=0;
    A.FN=0;
    A.Precision=0;
    A.Recall=0;
    A.F1_score=0;
    A.F1_array=[];
    A.foreground=[];
    A.TP_array=[];
    A.count=[];
    
    
    B=struct;
    B.TP=0;
    B.TN=0;
    B.FP=0;
    B.FN=0;
    B.Precision=0;
    B.Recall=0;
    B.F1_score=0;
    B.F1_array=[];
    B.foreground=[];
    B.TP_array=[];
    B.count=[];
    
    files = ListFiles(directory_results);
    
    
    count_a=0;
    count_b=0;
    for i=1:size(files,1),
        disp([num2str(i),' of ', num2str(size(files,1))])
        splited_name=strsplit(files(i).name,'_');
        image_res=imread(strcat(directory_results,files(i).name));
        image_gt=imread(strcat(directory_gt,'gt',char(splited_name(3))));
        [TP FP FN TN SE] = compare(image_res, image_gt);
        [precision recall F1_score]=get_measures(TP,TN,FP,FN);
        if(isnan(F1_score))
            F1_score=0;
        end
        if (char(splited_name(2))=='A')
            A.TP=A.TP+TP;
            A.FP=A.FP+FP;
            A.FN=A.FN+FN;
            A.TN=A.TN+TN;
            
            A.F1_array=[A.F1_array F1_score];
            A.foreground=[A.foreground TP+FP];
            A.TP_array=[A.TP_array TP];
            A.count=[ A.count count_a];
            
            count_a=count_a+1;
        else
            B.TP=B.TP+TP;
            B.FP=B.FP+FP;
            B.FN=B.FN+FN;
            B.TN=B.TN+TN;
            
            B.F1_array=[B.F1_array F1_score];
            B.foreground=[B.foreground TP+FP];
            B.TP_array=[B.TP_array TP];
            B.count=[ B.count count_b];
            
            count_b=count_b+1;
        end
    end
    [precision recall F1_score]=get_measures(A.TP,A.TN,A.FP,A.FN);
    A.Precision=precision;
    A.Recall=recall;
    A.F1_score=F1_score;
    
    [precision recall F1_score]=get_measures(B.TP,B.TN,B.FP,B.FN);
    B.Precision=precision;
    B.Recall=recall;
    B.F1_score=F1_score;
    A
   
    
    B
    plot_grafics(A,'A');
    plot_grafics(B,'B');
end

function plot_grafics(struct_var,class_struct)
    
    figure; hold on
    plot(struct_var.count,struct_var.TP_array,'r')
    plot(struct_var.count,struct_var.foreground,'b')
    xlabel('# frames')
    ylabel('# pixels')
    title(strcat(class_struct,' True positive and true fourground vs frame'))
    legend('TP','TF')
    hold off;

    figure;hold on;
    plot(struct_var.count,struct_var.F1_array)
    xlabel('# frames')
    ylabel('F1 score')
    title(strcat(class_struct,' F1 Score vs frame'))
    legend(strcat('F1 score for ',class_struct))
    hold off;
end
function [precision recall F1_score]=get_measures(TP,TN,FP,FN)
    precision=TP/(TP+FP);
    recall=TP/(TP+FN);
    F1_score=2*((precision*recall)/(precision+recall));

end
function [TP FP FN TN SE] = compare(imBinary, imGT)
    % Compares a binary frames with the groundtruth frame
    
    TP = sum(sum(imGT>=170&imBinary==1));		% True Positive 
    TN = sum(sum(imGT<=85&imBinary==0));		% True Negative
    FP = sum(sum((imGT<=85)&imBinary==1));	% False Positive
    FN = sum(sum(imGT>=170&imBinary==0));		% False Negative
    SE = sum(sum(imGT==50&imBinary==1));		% Shadow Error
end