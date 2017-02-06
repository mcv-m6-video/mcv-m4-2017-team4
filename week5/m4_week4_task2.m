function m4_week4_task2()
    sequence=[950:1050];
    train_folder='./traffic/input/';
    new_folder='./traffic/input_1/';
    gt_folder='./traffic/groundtruth/'; 
    new_gt='./traffic/groundtruth_1/';
    groundtruth_name='gt';
    v = VideoWriter('traffic_1');
    open(v);
    v_gt = VideoWriter('traffic_1_gt');
    open(v_gt);
    
    hbm = vision.BlockMatcher('ReferenceFrameSource', 'Input port', 'BlockSize', [15 15]);
    hbm.OutputValue = 'Horizontal and vertical components in complex form';
    
    
    image_name_pre=sprintf('in%06d',sequence(1));
    previous_frame=strcat(train_folder,image_name_pre,'.jpg');
    previous_image=imread(previous_frame);
    imwrite(previous_image,strcat(new_folder,image_name_pre,'.jpg'));
    
    
    gt_image=imread(strcat(gt_folder,groundtruth_name,sprintf('%06d',sequence(1)),'.png'));
    imwrite(gt_image,strcat(new_gt,groundtruth_name,sprintf('%06d',sequence(1)),'.png'));
    writeVideo(v,previous_image);
    for count_seq=2:size(sequence,2)

        'SEQUENCIA'
        disp(sequence(count_seq))
        
        image_name_curr=sprintf('in%06d',sequence(count_seq));
        current_frame=strcat(train_folder,image_name_curr,'.jpg');
        current_image=imread(current_frame);
        motion = step(hbm, double(rgb2gray(previous_image)), double(rgb2gray(current_image)));
        Vx = real(mode(mode(motion)));
        Vy = imag(mode(mode(motion)));
        out = imtranslate(current_image,[-Vx -Vy]);
        previous_image=out;    
        writeVideo(v,out);
        imwrite(out,strcat(new_folder,image_name_curr,'.jpg'));
        
        gt_image=imread(strcat(gt_folder,groundtruth_name,sprintf('%06d',sequence(count_seq)),'.png'));
        gt_compensate=imtranslate(gt_image,[-Vx -Vy]);
        imwrite(gt_compensate,strcat(new_gt,groundtruth_name,sprintf('%06d',sequence(count_seq)),'.png'));
        writeVideo(v_gt,gt_compensate);
        
    end
    
    close(v)
end