function [sequence_db]=computed_task_1(sequence_db,groundtruth_path,groundtruth_name,input_path,input_name)
    fields = fieldnames(sequence_db);
    
    for i=1:numel(fields)
     
      sequence_db.(fields{i}).TP=0;
      sequence_db.(fields{i}).TN=0;
      sequence_db.(fields{i}).FP=0;
      sequence_db.(fields{i}).FN=0;
      sequence_db.(fields{i}).Precision=0;
      sequence_db.(fields{i}).Recall=0;
      sequence_db.(fields{i}).F1_score=0;
      
      sequence_part=sequence_db.(fields{i});
      numb_frames=sequence_part.frames(2)-sequence_part.frames(1)+1;
      frames_sequence=sequence_part.frames(1):sequence_part.frames(2);
      train_frames=round(numb_frames/2);
      image_res=imread(strcat(sequence_part.path,input_path,input_name,sprintf('%06d',sequence_part.frames(1)),'.jpg'));%input image name
      train_sequence_image=uint8(zeros(size(image_res,1),size(image_res,2),train_frames));
      %train part
      for count_train=1:train_frames
          

          index_frame=randi(size(frames_sequence,2));
          train_frame=frames_sequence(index_frame);
          frames_sequence(index_frame)=[];%erase the index from the range
          train_image=imread(strcat(sequence_part.path,input_path,input_name,sprintf('%06d',train_frame),'.jpg'));
          gt_image=imread(strcat(sequence_part.path,groundtruth_path,groundtruth_name,sprintf('%06d',train_frame),'.png'));
          %mask=uint8(gt_image==0) + uint8(gt_image==50);
          
          train_sequence_image(:,:,count_train)=rgb2gray(train_image);
      end
      %compute the mean and the standart desviation
      mean_value=mean(train_sequence_image,3);
      std_value=std(double(train_sequence_image),0,3);
      
      %test part
      for count_test=1:size(frames_sequence,2)
          test_frame=frames_sequence(count_test);
          test_image=rgb2gray(imread(strcat(sequence_part.path,input_path,input_name,sprintf('%06d',test_frame),'.jpg')));
          gt_image=imread(strcat(sequence_part.path,groundtruth_path,groundtruth_name,sprintf('%06d',test_frame),'.png'));
          train_image_res=abs(double(test_image)-mean_value)>=sequence_part.alpha.*(std_value+2);
          [TP FP FN TN] = compare_images(train_image_res, gt_image);
          sequence_db.(fields{i}).TP=sequence_db.(fields{i}).TP+TP;
          sequence_db.(fields{i}).TN=sequence_db.(fields{i}).TN+TN;
          sequence_db.(fields{i}).FP=sequence_db.(fields{i}).FP+FP;
          sequence_db.(fields{i}).FN=sequence_db.(fields{i}).FN+FN;
      end
      
       [precision recall F1_score]=get_measures(sequence_db.(fields{i}).TP,sequence_db.(fields{i}).TN,sequence_db.(fields{i}).FP,sequence_db.(fields{i}).FN);
       sequence_db.(fields{i}).Precision=precision;
       sequence_db.(fields{i}).Recall=recall;
       sequence_db.(fields{i}).F1_score=F1_score;
    end
end