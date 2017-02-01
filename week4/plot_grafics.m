function plot_grafics(sequence_db,sequence_db_result_old)
    fields = fieldnames(sequence_db);
    colors=['b','g','r'];
    figure()
    title('Precision vs Recall');
    hold on;
    xlabel('Recall')
    ylabel('Precision')
    legend_info=cell(2,1);
    for i=1:numel(fields)
        sequence_db.(fields{i}).Recall_array=[sequence_db.(fields{i}).Recall_array,0];
        sequence_db.(fields{i}).Precision_array=[sequence_db.(fields{i}).Precision_array,1];
        sequence_db.(fields{i}).Recall_array(isnan(sequence_db.(fields{i}).Recall_array))=0;
        sequence_db.(fields{i}).Precision_array(isnan(sequence_db.(fields{i}).Precision_array))=0;
        plot(sequence_db.(fields{i}).Recall_array,sequence_db.(fields{i}).Precision_array,colors(i))
        auc_class = trapz(sequence_db.(fields{i}).Recall_array(end:-1:1),sequence_db.(fields{i}).Precision_array(end:-1:1));
        legend_info{i}=strcat(fields{i},' video compensation',' AUC: ',sprintf('%.2f',abs(auc_class)));
        
        sequence_db_result_old.(fields{i}).Recall_array=[sequence_db_result_old.(fields{i}).Recall_array,0];
        sequence_db_result_old.(fields{i}).Precision_array=[sequence_db_result_old.(fields{i}).Precision_array,1];
        sequence_db_result_old.(fields{i}).Recall_array(isnan(sequence_db_result_old.(fields{i}).Recall_array))=0;
        sequence_db_result_old.(fields{i}).Precision_array(isnan(sequence_db_result_old.(fields{i}).Precision_array))=0;
        plot(sequence_db_result_old.(fields{i}).Recall_array,sequence_db_result_old.(fields{i}).Precision_array,colors(i+1))
        auc_class = trapz(sequence_db_result_old.(fields{i}).Recall_array(end:-1:1),sequence_db_result_old.(fields{i}).Precision_array(end:-1:1));
        legend_info{i+1}=strcat(fields{i},' AUC: ',sprintf('%.2f',abs(auc_class)));
    end
    legend(legend_info)
    hold off;
    saveas(gcf, 'Precision_vs_Recall', 'fig')
end