function [sequence_db]=compute_video(sequence_db,groundtruth_path,groundtruth_name,input_path,input_name)
    fields = fieldnames(sequence_db);
    
    for i=1:numel(fields)
     
      sequence_db.(fields{i}).TP=0;
      sequence_db.(fields{i}).TN=0;
      sequence_db.(fields{i}).FP=0;
      sequence_db.(fields{i}).FN=0;
      sequence_db.(fields{i}).Precision=0;
      sequence_db.(fields{i}).Recall=0;
      sequence_db.(fields{i}).F1_score=0;
      
      sequence_db.(fields{i}).TP_array=[];
      sequence_db.(fields{i}).TN_array=[];
      sequence_db.(fields{i}).FP_array=[];
      sequence_db.(fields{i}).FN_array=[];
      sequence_db.(fields{i}).Precision_array=[];
      sequence_db.(fields{i}).Recall_array=[];
      sequence_db.(fields{i}).F1_score_array=[];
      
      sequence_part=sequence_db.(fields{i});
      numb_frames=sequence_part.frames(2)-sequence_part.frames(1)+1;
      frames_sequence=sequence_part.frames(1):sequence_part.frames(2);
      train_frames=round(numb_frames/2);
      image_res=imread(strcat(sequence_part.path,input_path,input_name,sprintf('%06d',sequence_part.frames(1)),'.jpg'));%input image name
      train_sequence_image=double(zeros(size(image_res,1),size(image_res,2),size(image_res,3),train_frames));
      %train part
      for count_train=1:train_frames
          
          train_frame=frames_sequence(1);
          frames_sequence(1)=[];%erase the index from the range
          train_image=imread(strcat(sequence_part.path,input_path,input_name,sprintf('%06d',train_frame),'.jpg'));
          
          train_sequence_image(:,:,:,count_train)=train_image;
      end
      %compute the mean and the standart desviation
      size_train=size(size(train_sequence_image));
      mean_value=mean(train_sequence_image,size_train(end));
      std_value=std(double(train_sequence_image),0,size_train(end));
      
      %test part
       for count_alpha =1:size(sequence_part.alpha,2)
          alpha=sequence_part.alpha(count_alpha);
          sequence_db.(fields{i}).TP=0;
          sequence_db.(fields{i}).TN=0;
          sequence_db.(fields{i}).FP=0;
          sequence_db.(fields{i}).FN=0;
          for count_test=1:size(frames_sequence,2)
              test_frame=frames_sequence(count_test);
              test_image=imread(strcat(sequence_part.path,input_path,input_name,sprintf('%06d',test_frame),'.jpg'));
              gt_image=imread(strcat(sequence_part.path,groundtruth_path,groundtruth_name,sprintf('%06d',test_frame),'.png'));
              test_image_res=abs(double(test_image(:,:,1))-mean_value(:,:,1))>=alpha.*(std_value(:,:,1)+2)&abs(double(test_image(:,:,2))-mean_value(:,:,2))>=alpha.*(std_value(:,:,2)+2)&abs(double(test_image(:,:,3))-mean_value(:,:,3))>=alpha.*(std_value(:,:,3)+2);
              

              test_image_res=computed_morphology(test_image_res);
              
              [TP FP FN TN] = compare_images(test_image_res, gt_image);
              sequence_db.(fields{i}).TP=sequence_db.(fields{i}).TP+TP;
              sequence_db.(fields{i}).TN=sequence_db.(fields{i}).TN+TN;
              sequence_db.(fields{i}).FP=sequence_db.(fields{i}).FP+FP;
              sequence_db.(fields{i}).FN=sequence_db.(fields{i}).FN+FN;


          end
            sequence_db.(fields{i}).TP_array=[sequence_db.(fields{i}).TP_array,sequence_db.(fields{i}).TP];
            sequence_db.(fields{i}).TN_array=[sequence_db.(fields{i}).TN_array,sequence_db.(fields{i}).TN];
            sequence_db.(fields{i}).FP_array=[sequence_db.(fields{i}).FP_array,sequence_db.(fields{i}).FP];
            sequence_db.(fields{i}).FN_array=[sequence_db.(fields{i}).FN_array,sequence_db.(fields{i}).FN];
            [precision recall F1_score]=get_measures(sequence_db.(fields{i}).TP,sequence_db.(fields{i}).TN,sequence_db.(fields{i}).FP,sequence_db.(fields{i}).FN);

           
           sequence_db.(fields{i}).Precision_array=[sequence_db.(fields{i}).Precision_array,precision];
           sequence_db.(fields{i}).Recall_array=[sequence_db.(fields{i}).Recall_array,recall];
           sequence_db.(fields{i}).F1_score_array=[sequence_db.(fields{i}).F1_score_array,F1_score];
       end
    end
end