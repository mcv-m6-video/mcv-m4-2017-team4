function [sequence_db]=compute_task_3(sequence_db,groundtruth_path,groundtruth_name,input_path,input_name,gray)
    fields = fieldnames(sequence_db);
    num_gaussians = 3;
    stdRange = [0 200]; % standar deviation - best 100 with 3 to 6 gaussians, 40 for 2 gaussians
    stdStep = 20;
    threshold = [0.7 0.7]; %Minimum Background Ratio threshold  - defaul 0.7 
    thresStep = 0.05;
    for i=1:numel(fields) 
      sequence_db.(fields{i}).Precision=[];
      sequence_db.(fields{i}).Recall=[];
      sequence_db.(fields{i}).F1_score=[];
      sequence_part=sequence_db.(fields{i});
      numb_frames=sequence_part.frames(2)-sequence_part.frames(1)+1;
      frames_sequence=sequence_part.frames(1):sequence_part.frames(2);
      train_frames=round(numb_frames/2);
      ind = 0;
      for thres=threshold(1):thresStep:threshold(2)
        for std=stdRange(1):stdStep:stdRange(2)
          sequence_db.(fields{i}).TP=0;
          sequence_db.(fields{i}).TN=0;
          sequence_db.(fields{i}).FP=0;
          sequence_db.(fields{i}).FN=0;
          %train part
          detectorSG = vision.ForegroundDetector('NumTrainingFrames', train_frames,...
              'NumGaussians', num_gaussians,'InitialVariance', std*std,'MinimumBackgroundRatio',thres);
          for count_train=1:train_frames
              train_frame=frames_sequence(count_train);
              train_image=imread(strcat(sequence_part.path,input_path,input_name,sprintf('%06d',train_frame),'.jpg'));
              if gray
                  train_image = rgb2gray(train_image);
              end
              step(detectorSG, train_image);%add frame to the foreground detector
          end

          %test part
          for count_test=1:size(frames_sequence,2)
              test_frame=frames_sequence(count_test);
              test_image=imread(strcat(sequence_part.path,input_path,input_name,sprintf('%06d',test_frame),'.jpg'));
              gt_image=imread(strcat(sequence_part.path,groundtruth_path,groundtruth_name,sprintf('%06d',test_frame),'.png'));
              if gray
                  test_image = rgb2gray(test_image);
              end
              train_image_res = step(detectorSG, test_image);

              [TP FP FN TN] = compare_images(train_image_res, gt_image);
              sequence_db.(fields{i}).TP=sequence_db.(fields{i}).TP+TP;
              sequence_db.(fields{i}).TN=sequence_db.(fields{i}).TN+TN;
              sequence_db.(fields{i}).FP=sequence_db.(fields{i}).FP+FP;
              sequence_db.(fields{i}).FN=sequence_db.(fields{i}).FN+FN;
          end
          [precision recall F1_score]=get_measures(sequence_db.(fields{i}).TP,sequence_db.(fields{i}).TN,sequence_db.(fields{i}).FP,sequence_db.(fields{i}).FN);
          sequence_db.(fields{i}).Precision = [sequence_db.(fields{i}).Precision; precision];
          sequence_db.(fields{i}).Recall=[sequence_db.(fields{i}).Recall;recall];
          sequence_db.(fields{i}).F1_score=[sequence_db.(fields{i}).F1_score;F1_score];
          ind = ind +1;
        end
      end
    end
end