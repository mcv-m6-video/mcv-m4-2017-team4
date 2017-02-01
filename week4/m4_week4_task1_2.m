function m4_week4_task1_2()
    kitti_sequence=[45];%45,157
    train_folder='./optical_flow/training/image_0/';
    gt_folder='./optical_flow/training/flow_noc/'; 

    block_size=8;
    area_size=16;
    tau = 3;
    task=1.2;%could be cahnge to test fix size in the task 1.1
    opticalflow_param='HS';
    for count_seq=1:size(kitti_sequence,2)
        'SEQUENCIA'
        disp(kitti_sequence(count_seq))
            if(strcmp(opticalflow_param,'LK'))
                opticFlow = opticalFlowLK;
            elseif(strcmp(opticalflow_param,'LKDOG'))
                opticFlow = opticalFlowLKDoG;
            elseif(strcmp(opticalflow_param,'HS'))
                opticFlow = opticalFlowHS;
            elseif(strcmp(opticalflow_param,'F'))
                opticFlow = opticalFlowFarneback;
            end


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
                 F_est(:,:,2)=flow.Vy;
            end
            gt_name=strcat(gt_folder,image_name,'_10.png');
            F_gt  = flow_read(gt_name);
            errorMSEN = task31_MSEN(F_gt,F_est)
            errorPEPN = task32_PEPN(F_gt,F_est,tau)
            
            hold on;
            imshow(current_image)
            hold on;
            quiver(F_est(:,:,1),F_est(:,:,2),'autoscale','off');
           
    end
end