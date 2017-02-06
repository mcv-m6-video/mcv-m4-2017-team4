% function [mean_res,std_res]=compute_mean_std(sequence_db,input_path,input_name)
%       sequence_part=sequence_db.(fields{i});
%       numb_frames=sequence_part.frames(2)-sequence_part.frames(1)+1;
%       frames_sequence=sequence_part.frames(1):sequence_part.frames(2);
%       train_frames=round(numb_frames/2);
%       image_res=imread(strcat(sequence_part.path,input_path,input_name,sprintf('%06d',sequence_part.frames(1)),'.jpg'));%input image name
%       train_sequence_image=double(zeros(size(image_res,1),size(image_res,2),size(image_res,3),train_frames));
%       %train part
%       for count_train=1:train_frames
%           
%           train_frame=frames_sequence(1);
%           frames_sequence(1)=[];%erase the index from the range
%           train_image=imread(strcat(sequence_part.path,input_path,input_name,sprintf('%06d',train_frame),'.jpg'));
%           
%           train_sequence_image(:,:,:,count_train)=train_image;
%       end
%       size_train=size(size(train_sequence_image));
%       mean_res=mean(train_sequence_image,size_train(end));
%       std_res=std(double(train_sequence_image),0,size_train(end));
% end
function [mean_res,var_res]=compute_mean_std(sequence_part,input_path,input_name)
      numb_frames=sequence_part.frames(2)-sequence_part.frames(1)+1;
      frames_sequence=sequence_part.frames(1):sequence_part.frames(2);
      train_frames=round(numb_frames);
      image_res=imread(strcat(sequence_part.path,input_path,input_name,sprintf('%06d',sequence_part.frames(1)),'.jpg'));%input image name
      train_sequence_image=double(zeros(size(image_res,1),size(image_res,2),train_frames));
      %train part
      for count_train=1:train_frames
          
          train_frame=frames_sequence(1);
          frames_sequence(1)=[];%erase the index from the range
          train_image=rgb2gray(imread(strcat(sequence_part.path,input_path,input_name,sprintf('%06d',train_frame),'.jpg')));
          train_sequence_image(:,:,count_train)=train_image;
      end
      size_train=size(size(train_sequence_image));
      mean_res=mean(train_sequence_image,size_train(end));
      var_res=var(double(train_sequence_image),0,size_train(end));
end