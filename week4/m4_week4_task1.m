function m4_week4_task1()
    kitti_sequence=[45,157];
    train_folder='./optical_flow/training/image_0/';
    gt_folder='./optical_flow/training/flow_noc/'; 

    area_size=20;
    block_size=20;
    tau = 3;
    task=1.2;
    
    for count_seq=1:size(kitti_sequence,2)
        opticFlow = opticalFlowLK;
        'SEQUENCIA'
        disp(kitti_sequence(count_seq))
        image_name=sprintf('%06d',kitti_sequence(count_seq));
        previous_frame=strcat(train_folder,image_name,'_10.png');
        current_frame=strcat(train_folder,image_name,'_11.png');
        previous_image=imread(previous_frame);
        current_image=imread(current_frame);
        if(task==1.1)
            F_est=block_matching(previous_image,current_image,block_size,area_size);
        elseif(task==1.2)
             flow_novalid = estimateFlow(opticFlow,previous_image);
             flow = estimateFlow(opticFlow,current_image);
             F_est=zeros(size(current_image,1),size(current_image,2),2);
             F_est(:,:,1)=flow.Vx;
             F_est(:,:,1)=flow.Vy;
        end
        gt_name=strcat(gt_folder,image_name,'_10.png');
        F_gt  = flow_read(gt_name);
        errorMSEN = task31_MSEN(F_gt,F_est);
        errorPEPN = task32_PEPN(F_gt,F_est,tau);
        errorMSEN
        errorPEPN
        
        
    end
end