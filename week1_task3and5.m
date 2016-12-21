function week1_task3and5()
    clear all; close all; dbstop error;
    % error threshold for PEPN
    tau = 3;
    %Load optical flow results & optical flow GT
    F_est = flow_read('flow_results/LKflow_000157_10.png');
    F_gt  = flow_read('flow_results/GT/000157_10.png');
    % task 3.1 Mean Square Error in Non-occluded areas
    errorMSEN = task31_MSEN(F_gt,F_est);
    % task 3.2 Percentage of Erroneous Pixels in Non-occluded areas
    errorPEPN = task32_PEPN(F_gt,F_est,tau);
    %task 3.3 visualizations
    %task33_visualization(F_est,F_gt,errorMSEN,errorPEPN);
    %task 5 Quiver
    im = imread('flow_results/000157_10c.png');
    %imagesc(im)
    figure,imshow(im)
    hold on
    quiver(F_est(:,:,1),F_est(:,:,2),'autoscale','off');
end
