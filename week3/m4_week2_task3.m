function m4_week2_task3()
   
    global_path='Dataset/';
    groundtruth_path='groundtruth/';
    groundtruth_name='gt';
    input_path='input/';
    input_name='in';
    gray = 0;      
    sequence_db=struct;
    sequence_db.fall.frames=[1460 1560];
    sequence_db.highway.frames=[1050 1350];
    sequence_db.traffic.frames=[950 1050];
        
    sequence_db.fall.path=strcat(global_path,'fall/');
    sequence_db.highway.path=strcat(global_path,'highway/');
    sequence_db.traffic.path=strcat(global_path,'traffic/');
    
    fields = fieldnames(sequence_db);
    
    %Stauffer and Grimson
    sequence_db_result=compute_task_3(sequence_db,groundtruth_path,groundtruth_name,input_path,input_name,gray);
    
    %F1-scores curve plots
    x=0:20:200; %to plot Standar Deviation in grafs
%     x=0.5:0.05:0.9; %to plot Minimum Background Ratio threshold
    figure()
    for i=1:numel(fields)
        hold on
        plot(x,sequence_db_result.(fields{i}).F1_score)
    end
    legend('Fall','Highway','Traffic','Location','best')
    for i=1:numel(fields)
        hold on
        [y z] = max(sequence_db_result.(fields{i}).F1_score);
        plot(x(z),y,'x','MarkerSize',5)
        strmax = num2str(sequence_db_result.(fields{i}).F1_score(z),'%.2f');
        text(x(z),y,strmax,'HorizontalAlignment','center','VerticalAlignment','bottom');
    end
    title(strcat('Stauffer and Grimson - Gaussian number 3'))
    %xlabel('Standar deviation')
    xlabel('Minimum Background Ratio threshold')
    ylabel('F1 Score')

    %Precision-Recall curve plots
    auc = []
    figure()
    for i=1:numel(fields)      
        hold on
        auc = [auc; abs(trapz(sequence_db_result.(fields{i}).Recall,sequence_db_result.(fields{i}).Precision))]
        plot(sequence_db_result.(fields{i}).Recall,sequence_db_result.(fields{i}).Precision)      
    end
    legend(strcat('Fall - AUC =',num2str(auc(1))),strcat('Highway - AUC',num2str(auc(2))),...
        strcat('Traffic - AUC',num2str(auc(3))),'Location','best')
    title(strcat('Precision vs Recall Stauffer and Grimson (3 gaussians)'))
    xlabel('Recall')
    ylabel('Precision')
end
