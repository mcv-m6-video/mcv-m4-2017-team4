function m4_week3_task2()
   
    global_path='./';
    groundtruth_path='groundtruth/';
    groundtruth_name='gt';
    input_path='input/';
    input_name='in';
    color_spaces='YUV';%RGB,YUV,HSV
    task=2;
    P_array=[0:25:500];
    auc_array=struct;
    auc_array.fall=[];
    auc_array.highway=[];
    auc_array.traffic=[];
    sequence_db=struct;
    sequence_db.fall.frames=[1460 1560];
    sequence_db.highway.frames=[1050 1350];
    sequence_db.traffic.frames=[950 1050];
    
    sequence_db.fall.alpha=[0:0.1:3];
    sequence_db.highway.alpha=[0:0.1:3];
    sequence_db.traffic.alpha=[0:0.1:3];
    
    sequence_db.fall.path=strcat(global_path,'fall/');
    sequence_db.highway.path=strcat(global_path,'highway/');
    sequence_db.traffic.path=strcat(global_path,'traffic/');
    
    
    
    
    
    fields = fieldnames(sequence_db);
    
    for count_p =1:size(P_array,2)
      fields = fieldnames(sequence_db);

      sequence_db_result=compute_task_1(color_spaces,sequence_db,groundtruth_path,groundtruth_name,input_path,input_name,task,P_array(count_p));
      for i=1:numel(fields) 
        auc_class = trapz(sequence_db_result.(fields{i}).Recall_array,sequence_db_result.(fields{i}).Precision_array);
        auc_array.(fields{i})=[auc_array.(fields{i}),abs(auc_class)];
      end
      
    end 
    auc_array.mean=(auc_array.fall+auc_array.highway+auc_array.traffic)./3;
    fields_auc = fieldnames(auc_array);
    figure()
    title('auc vs P');
    hold on;
    xlabel('P')
    ylabel('auc')
    legend_info=cell(numel(fields_auc),1);

    for i=1:numel(fields_auc)

            plot(P_array,auc_array.(fields_auc{i}))
            [auc_value,aux_pos] = max(auc_array.(fields_auc{i}))
            legend_info{i}=strcat(fields_auc{i},' Max AUC: ',sprintf('%.2f(%d)',abs(auc_value),P_array(aux_pos)));
    end
    legend(legend_info)
    hold off;
    saveas(gcf, 'aucvsP', 'png')
%   plot_grafics(sequence_db_result);
end