function m4_week3_tasks()
    task=5; %Select the task that you want to compute
    
    global_path='Dataset/';
    groundtruth_path='groundtruth/';
    groundtruth_name='gt';
    input_path='input/';
    input_name='in';
    color_spaces='RGB';%RGB,YUV,HSV    
    P_array=[0:50:1000];
    sequence_db=struct;
    sequence_db.fall.frames=[1460 1560];
    sequence_db.highway.frames=[1050 1350];
    sequence_db.traffic.frames=[950 1050];
    
    sequence_db.fall.alpha=[0:0.1:5];
    sequence_db.highway.alpha=[0:0.1:5];
    sequence_db.traffic.alpha=[0:0.1:5];
    
    sequence_db.fall.path=strcat(global_path,'fall/');
    sequence_db.highway.path=strcat(global_path,'highway/');
    sequence_db.traffic.path=strcat(global_path,'traffic/');
    
    fields = fieldnames(sequence_db);
    if ~(task==2)
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

      sequence_db_result=compute_task(color_spaces,sequence_db,groundtruth_path,groundtruth_name,input_path,input_name,task,10);
      for i=1:numel(fields) 
        disp(sequence_db_result.(fields{i}))
        [m,ind] = max(sequence_db_result.(fields{i}).F1_score_array)
        ['Best alpha: ' sprintf('%.2f',0.1*(ind-1))]
        ['Best F1-score: ' sprintf('%.2f',sequence_db_result.(fields{i}).F1_score_array(ind))]
        ['Best Precision: ' sprintf('%.2f',sequence_db_result.(fields{i}).Precision_array(ind))]
        ['Best Recall: ' sprintf('%.2f',sequence_db_result.(fields{i}).Recall_array(ind))]
      end
      plot_grafics(sequence_db_result,task);
    elseif(task==2)
            
        for count_p =1:size(P_array,2) %foreach P compute the auc
          fields = fieldnames(sequence_db);

          sequence_db_result=compute_task(color_spaces,sequence_db,groundtruth_path,groundtruth_name,input_path,input_name,task,P_array(count_p));
          for i=1:numel(fields) 
            sequence_db_result.(fields{i}).Recall_array(isnan(sequence_db_result.(fields{i}).Recall_array))=0;
            sequence_db_result.(fields{i}).Precision_array(isnan(sequence_db_result.(fields{i}).Precision_array))=0;
            auc_class = trapz(sequence_db_result.(fields{i}).Recall_array(end:-1:1),sequence_db_result.(fields{i}).Precision_array(end:-1:1));
            auc_array.(fields{i})=[auc_array.(fields{i}),abs(auc_class)];
          end

        end 
        auc_array.mean=(auc_array.fall+auc_array.highway+auc_array.traffic)./3;%computed the mean auc and print the grafic
        fields_auc = fieldnames(auc_array);
        figure()
        title('auc vs P');
        hold on;
        xlabel('P')
        ylabel('auc')
        legend_info=cell(numel(fields_auc),1);

        for i=1:numel(fields_auc)

                plot(P_array,auc_array.(fields_auc{i}))
                [auc_value,aux_pos] = max(auc_array.(fields_auc{i}));
                legend_info{i}=strcat(fields_auc{i},' Max AUC: ',sprintf('%.2f(%d)',abs(auc_value),P_array(aux_pos)));
        end
        legend(legend_info)
        hold off;
        saveas(gcf, 'aucvsP', 'png')
    end
end