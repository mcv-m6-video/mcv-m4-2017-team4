function m4_week4_task2_own_block()
    sequence=[950:1050];
    train_folder='./traffic/input/';
    gt_folder='./optical_flow/training/flow_noc/'; 
    new_folder='./traffic/input_1/';
    new_gt='./traffic/groundtruth_1/';
    area_size=8;
    block_size=16;
    tau = 3;
    task=1.1;
    opticalflow='LK';
    videostabilization='Own';
    v = VideoWriter('traffic_own');
    open(v);
    v_gt = VideoWriter('traffic_own_gt');
    open(v_gt);
    
    image_name_pre=sprintf('in%06d',sequence(1));
    previous_frame=strcat(train_folder,image_name_pre,'.jpg');
    previous_image=imread(previous_frame);
    imwrite(previous_image,strcat(new_folder,image_name_pre,'.jpg'));
    gt_image=imread(strcat(gt_folder,groundtruth_name,sprintf('%06d',sequence(1)),'.png'));
    imwrite(gt_image,strcat(new_gt,groundtruth_name,sprintf('%06d',sequence(1)),'.png'));
    writeVideo(v_gt,gt_image);
    
    for count_seq=2:size(sequence,2)
        if(strcmp(opticalflow,'LK'))
            opticFlow = opticalFlowLK;
        elseif(strcmp(opticalflow,'HS'))
            opticFlow = opticalFlowHS;
        elseif(strcmp(opticalflow,'F'))
            opticFlow = opticalFlowFarneback;
        end
        'SEQUENCIA'
        disp(sequence(count_seq))
        
        image_name_curr=sprintf('in%06d',sequence(count_seq));
        current_frame=strcat(train_folder,image_name_curr,'.jpg');
        current_image=imread(current_frame);
        
        if(task==1.1)
            F_est=block_matching(double(rgb2gray(previous_image)),double(rgb2gray(current_image)),block_size,area_size);
        elseif(task==1.2)
             flow_novalid = estimateFlow(opticFlow,rgb2gray(previous_image));
             flow = estimateFlow(opticFlow,rgb2gray(current_image));
             F_est=zeros(size(current_image,1),size(current_image,2),2);
             F_est(:,:,1)=flow.Vx;
             F_est(:,:,2)=flow.Vy;
        end
        if (strcmp(videostabilization,'Own'))
            Vx=F_est(:,:,1);
            Vy=F_est(:,:,2);
            vectors_relevants=find(F_est(:,:,3)~=0);
            motion=[Vx(vectors_relevants) Vy(vectors_relevants)];
            V_mov=mode(motion);
           
            out = imtranslate(current_image, [V_mov(1) V_mov(2)]);
            previous_image=out;
            imwrite(out,strcat(new_folder,image_name_curr,'.jpg'));
            gt_image=imread(strcat(gt_folder,groundtruth_name,sprintf('%06d',sequence(count_seq)),'.png'));
            gt_compensate=imtranslate(gt_image,[V_mov(1) V_mov(2)]);
            writeVideo(v_gt,gt_compensate);
            imwrite(gt_compensate,strcat(new_gt,groundtruth_name,sprintf('%06d',sequence(count_seq)),'.png'));
            writeVideo(v,out);
        end
        
    end
    
    close(v)
end