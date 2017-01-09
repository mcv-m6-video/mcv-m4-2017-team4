function m4_week2_task1()
   
    global_path='./';
    groundtruth_path='groundtruth/';
    groundtruth_name='gt';
    input_path='input/';
    input_name='in';
    mean_evalutaion=false;
      
    sequence_db=struct;
    sequence_db.fall.frames=[1460 1560];
    sequence_db.highway.frames=[1050 1350];
    sequence_db.traffic.frames=[950 1050];
    
%     sequence_db.fall.alpha=[2];
%     sequence_db.highway.alpha=[1.5];
%     sequence_db.traffic.alpha=[1.7];
    sequence_db.fall.alpha=[0:0.1:5];
    sequence_db.highway.alpha=[0:0.1:5];
    sequence_db.traffic.alpha=[0:0.1:5];
    
    sequence_db.fall.path=strcat(global_path,'fall/');
    sequence_db.highway.path=strcat(global_path,'highway/');
    sequence_db.traffic.path=strcat(global_path,'traffic/');
    
    fields = fieldnames(sequence_db);
    
    sequence_db_final=struct;
    for i=1:numel(fields) 
        sequence_db_final.(fields{i}).TP=[];
        sequence_db_final.(fields{i}).TN=[];
        sequence_db_final.(fields{i}).FP=[];
        sequence_db_final.(fields{i}).FN=[];
        sequence_db_final.(fields{i}).Precision=[];
        sequence_db_final.(fields{i}).Recall=[];
        sequence_db_final.(fields{i}).F1_score=[];
    end


    
    
   fields = fieldnames(sequence_db);
   if mean_evalutaion
       for j=1:5 
            sequence_db_result=computed_task_1(sequence_db,groundtruth_path,groundtruth_name,input_path,input_name);
            for i=1:numel(fields) 
                 sequence_db_final.(fields{i}).TP=[sequence_db_final.(fields{i}).TP,sequence_db_result.(fields{i}).TP];
                 sequence_db_final.(fields{i}).TN=[sequence_db_final.(fields{i}).TN,sequence_db_result.(fields{i}).TN];
                 sequence_db_final.(fields{i}).FP=[sequence_db_final.(fields{i}).FP,sequence_db_result.(fields{i}).FP];
                 sequence_db_final.(fields{i}).FN=[sequence_db_final.(fields{i}).FN,sequence_db_result.(fields{i}).FN];
                 sequence_db_final.(fields{i}).Precision=[sequence_db_final.(fields{i}).Precision,sequence_db_result.(fields{i}).Precision];
                 sequence_db_final.(fields{i}).Recall=[sequence_db_final.(fields{i}).Recall,sequence_db_result.(fields{i}).Recall];
                 sequence_db_final.(fields{i}).F1_score=[sequence_db_final.(fields{i}).F1_score,sequence_db_result.(fields{i}).F1_score];
            end
       end

       for i=1:numel(fields) 
           sequence_db_final.(fields{i}).TP=mean(sequence_db_final.(fields{i}).TP);
           sequence_db_final.(fields{i}).TN=mean(sequence_db_final.(fields{i}).TN);
           sequence_db_final.(fields{i}).FP=mean(sequence_db_final.(fields{i}).FP);
           sequence_db_final.(fields{i}).FN=mean(sequence_db_final.(fields{i}).FN);
           sequence_db_final.(fields{i}).Precision=mean(sequence_db_final.(fields{i}).Precision);
           sequence_db_final.(fields{i}).Recall=mean(sequence_db_final.(fields{i}).Recall);
           sequence_db_final.(fields{i}).F1_score=mean(sequence_db_final.(fields{i}).F1_score);
           disp(sequence_db_final.(fields{i}))
       end
   else
      sequence_db_result=computed_task_1(sequence_db,groundtruth_path,groundtruth_name,input_path,input_name);
      for i=1:numel(fields) 
        disp(sequence_db_result.(fields{i}))
      end
      plot_grafics(sequence_db_result);
   end
end
