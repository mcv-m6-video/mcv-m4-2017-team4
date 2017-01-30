function evaluated_video()
    filename='traffic_block.avi';
    vidObj  = VideoReader(filename);
    vidHeight = vidObj.Height;
    vidWidth = vidObj.Width;
    
    video_s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
    k = 1;
    while hasFrame(vidObj)
        video_s(k).cdata = readFrame(vidObj);
        k = k+1;
    end
    global_path='./';
    groundtruth_path='groundtruth/';
    groundtruth_name='gt';
    color_space='RGB';%RGB,YUV,HSV
    sequence_db.traffic.frames=[950 1050];
    
    sequence_db.traffic.alpha=[0.5];
    
    sequence_db.traffic.path=strcat(global_path,'traffic/');
    
    fields = fieldnames(sequence_db);
    
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

  sequence_db_result=compute_video(color_space,sequence_db,groundtruth_path,groundtruth_name,video_s)
  for i=1:numel(fields) 
    disp(sequence_db_result.(fields{i}))
  end
  plot_grafics(sequence_db_result);
end