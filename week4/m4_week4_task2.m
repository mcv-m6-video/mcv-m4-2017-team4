function m4_week4_task2()
    sequence=[950:1050];
    train_folder='./traffic/input/';
    gt_folder='./optical_flow/training/flow_noc/'; 

    area_size=20;
    block_size=20;
    tau = 3;
    task=1.1;
    opticalflow='LK';
    videostabilization='Own';
    v = VideoWriter('traffic_own');
    open(v);
    
    hbm = vision.BlockMatcher('ReferenceFrameSource', 'Input port', 'BlockSize', [15 15]);
    hbm.OutputValue = 'Horizontal and vertical components in complex form';
    
    
    image_name_pre=sprintf('in%06d',sequence(1));
    previous_frame=strcat(train_folder,image_name_pre,'.jpg');
    previous_image=imread(previous_frame);
    
    
    writeVideo(v,previous_image);
    for count_seq=2:size(sequence,2)

        'SEQUENCIA'
        disp(sequence(count_seq))
        
        image_name_curr=sprintf('in%06d',sequence(count_seq));
        current_frame=strcat(train_folder,image_name_curr,'.jpg');
        current_image=imread(current_frame);
        motion = step(hbm, double(rgb2gray(previous_image)), double(rgb2gray(current_image)));
        Vx = double(real(mode(mode(motion))));
        Vy = double(imag(mode(mode(motion))));

        %Tform for wrapping
%         tform = affine2d(eye(3));
%         tform.T = tform.T + [0 0 0;0 0 0; -vx -vy 0];
        
        out = imtranslate(current_image,[-Vx -Vy]);%imwarp(current_image, tform,'OutputView',imref2d(size(current_image)));
        previous_image=out;    
        writeVideo(v,out);
        
    end
    
    close(v)
end