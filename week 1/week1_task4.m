function week1_task4()
    directory_resultsA='results_testAB_changedetection/testA/';
    directory_gt='results_testAB_changedetection/groundtruth/';
    directory_resultsB='results_testAB_changedetection/testB/';

    filesA = ListFiles(directory_resultsA);
    filesGT = ListFiles(directory_gt);
    filesB = ListFiles(directory_resultsB);
    
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
    
    F1ListA = calculateF1(A,filesA,filesGT,directory_resultsA,directory_gt)
    F1ListB = calculateF1(A,filesB,filesGT,directory_resultsB,directory_gt)
    figure,
    hold on
    x = 1:25;
    y = F1ListA(x);
    plot(x,y)
    y = F1ListB(x);
    plot(x,y)
    hold off
    fs = 14;
    title('Forward de-synchronized Test frames B');   
    lgd = legend('test A','test B');
    ylabel('F1-measure','FontSize',fs);
    xlabel('Frame','FontSize',fs);   
end

function plot_grafics(struct_var,class_struct)   
    plot(struct_var.count,struct_var.F1_array)
    xlabel('# frames')
    ylabel('F1 score')
    title(strcat(class_struct,' F1 Score vs frame'))
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

function F1List=calculateF1(A,files,filesGT,directory_results,directory_gt)    
    %displacements = [0 5 10 25];
    displacements = 1:25;
%     figure;hold on;
    for desp=1:length(displacements)
        count_a=0;
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
        for i=1:size(files,1)
            if i+displacements(desp) > size(files,1)
                break
            end            
            %disp([num2str(i),' of ', num2str(size(files,1))]);
            image_res=imread(strcat(directory_results,files(i).name));
            image_gt=imread(strcat(directory_gt,filesGT(i+displacements(desp)).name));
            [TP FP FN TN SE] = compare(image_res, image_gt);
            [precision recall F1_score]=get_measures(TP,TN,FP,FN);
            if(isnan(F1_score))
                F1_score=0;
            end
            A.TP=A.TP+TP;
            A.FP=A.FP+FP;
            A.FN=A.FN+FN;
            A.TN=A.TN+TN;
            
            A.F1_array=[A.F1_array F1_score];
            A.foreground=[A.foreground TP+FP];
            A.TP_array=[A.TP_array TP];
            A.count=[ A.count count_a];

            count_a=count_a+1;
        end
        [precision recall F1_score]=get_measures(A.TP,A.TN,A.FP,A.FN);
        A.Precision=precision;
        A.Recall=recall;
        A.F1_score=F1_score;
        F1List(desp) = F1_score;
%         plot_grafics(A,'B');
    end
%     legend('No delay','5 frames delay','10 frames delay','25 frames delay')
%     hold off;
end