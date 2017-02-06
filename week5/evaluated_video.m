function evaluated_video()
    task=5; %Select the task that you want to compute
    
    global_path='./';
    groundtruth_path='groundtruth_1/';
    groundtruth_path_old='groundtruth/';
    groundtruth_name='gt';
    input_path='input_1/';
    input_path_old='input/';
    input_name='in';
    sequence_db=struct;
    sequence_db.traffic.frames=[950 1050];

    sequence_db.traffic.alpha=[0:0.1:5];
    
    sequence_db.traffic.path=strcat(global_path,'traffic/');
    
    fields = fieldnames(sequence_db);

    sequence_db_result=compute_video(sequence_db,groundtruth_path,groundtruth_name,input_path,input_name);
    sequence_db_result_old=compute_video(sequence_db,groundtruth_path_old,groundtruth_name,input_path_old,input_name);
    for i=1:numel(fields) 
        disp(sequence_db_result.(fields{i}))
        [m,ind] = max(sequence_db_result.(fields{i}).F1_score_array)
        ['Best alpha: ' sprintf('%.2f',0.1*(ind-1))]
        ['Best F1-score: ' sprintf('%.2f',sequence_db_result.(fields{i}).F1_score_array(ind))]
        ['Best Precision: ' sprintf('%.2f',sequence_db_result.(fields{i}).Precision_array(ind))]
        ['Best Recall: ' sprintf('%.2f',sequence_db_result.(fields{i}).Recall_array(ind))]
    end
    'old'
    for i=1:numel(fields) 
        disp(sequence_db_result_old.(fields{i}))
        [m,ind] = max(sequence_db_result_old.(fields{i}).F1_score_array)
        ['Best alpha: ' sprintf('%.2f',0.1*(ind-1))]
        ['Best F1-score: ' sprintf('%.2f',sequence_db_result_old.(fields{i}).F1_score_array(ind))]
        ['Best Precision: ' sprintf('%.2f',sequence_db_result_old.(fields{i}).Precision_array(ind))]
        ['Best Recall: ' sprintf('%.2f',sequence_db_result_old.(fields{i}).Recall_array(ind))]
    end
    
    plot_grafics(sequence_db_result,sequence_db_result_old);