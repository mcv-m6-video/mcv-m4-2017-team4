function plot_grafics(sequence_db,task)
    if (task==1 || task == 3)
        fields = fieldnames(sequence_db);
        colors=['b','g','r'];
        figure()
        title('F1-score vs alpha');
        hold on;
        xlabel('alphas')
        ylabel('F1 score')
        for i=1:numel(fields)

            plot(sequence_db.(fields{i}).alpha,sequence_db.(fields{i}).F1_score_array,colors(i))
        end
        legend(fields)
        hold off;
        saveas(gcf, 'F1-score_vs_alpha', 'png')

        figure()
        title('Precision vs Recall');
        hold on;
        xlabel('Recall')
        ylabel('Precision')
        legend_info=cell(numel(fields,1));
        for i=1:numel(fields)

            plot(sequence_db.(fields{i}).Recall_array,sequence_db.(fields{i}).Precision_array,colors(i))
            auc_class = trapz(sequence_db.(fields{i}).Recall_array,sequence_db.(fields{i}).Precision_array);
            legend_info{i}=strcat(fields{i},' AUC: ',sprintf('%.2f',abs(auc_class)));
        end
        legend(legend_info)
        hold off;
        saveas(gcf, 'Precision_vs_Recall', 'png')

    %     for i=1:numel(fields)
    %         figure()
    %         title(strcat(fields{i},' TP,FP,FP,FN'));
    %         hold on;
    %         plot(sequence_db.(fields{i}).alpha,sequence_db.(fields{i}).TP_array)
    %         plot(sequence_db.(fields{i}).alpha,sequence_db.(fields{i}).TN_array)
    %         plot(sequence_db.(fields{i}).alpha,sequence_db.(fields{i}).FP_array)
    %         plot(sequence_db.(fields{i}).alpha,sequence_db.(fields{i}).FN_array)
    %         
    %         legend('TP','TN','FP','FN')
    %         hold off;
    %         saveas(gcf, strcat(fields{i},'_metric'), 'png')
    %     end
    end
end