function m4_week2_task4_1()
   
    global_path='./';
    groundtruth_path='groundtruth/';
    groundtruth_name='gt';
    input_path='input/';
    input_name='in';
    color_spaces='YUV';%RGB,YUV,HSV
    task=3;
    sequence_db=struct;
    sequence_db.fall.frames=[1460 1560];
    sequence_db.highway.frames=[1050 1350];
    sequence_db.traffic.frames=[950 1050];
    
    sequence_db.fall.alpha=[0:0.1:1];
    sequence_db.highway.alpha=[0:0.1:1];
    sequence_db.traffic.alpha=[0:0.1:1];
    
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

  sequence_db_result=compute_task_1(color_spaces,sequence_db,groundtruth_path,groundtruth_name,input_path,input_name,task,2);
  for i=1:numel(fields) 
    disp(sequence_db_result.(fields{i}))
  end
  plot_grafics(sequence_db_result,task);
end