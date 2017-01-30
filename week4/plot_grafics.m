function plot_grafics(sequence_db,task)
    fields = fieldnames(sequence_db);
    colors=['b','g','r'];
    figure()
    title('F1-score vs alpha');
    hold on;
    xlabel('alphas')
    ylabel('F1 score')
    for i=1:numel(fields)
        sequence_db.(fields{i}).F1_score_array(isnan(sequence_db.(fields{i}).F1_score_array))=0;
        plot(sequence_db.(fields{i}).alpha,sequence_db.(fields{i}).F1_score_array,colors(i))
    end
    legend(fields)
    hold off;
    saveas(gcf, 'F1-score_vs_alpha', 'fig')

    figure()
    title('Precision vs Recall');
    hold on;
    xlabel('Recall')
    ylabel('Precision')
    legend_info=cell(numel(fields,1));
    for i=1:numel(fields)
        sequence_db.(fields{i}).Recall_array(isnan(sequence_db.(fields{i}).Recall_array))=0;
        sequence_db.(fields{i}).Precision_array(isnan(sequence_db.(fields{i}).Precision_array))=0;
        plot(sequence_db.(fields{i}).Recall_array,sequence_db.(fields{i}).Precision_array,colors(i))
        auc_class = trapz(sequence_db.(fields{i}).Recall_array(end:-1:1),sequence_db.(fields{i}).Precision_array(end:-1:1));
        legend_info{i}=strcat(fields{i},' AUC: ',sprintf('%.2f',abs(auc_class)));
    end
    legend(legend_info)
    hold off;
    saveas(gcf, 'Precision_vs_Recall', 'fig')
end