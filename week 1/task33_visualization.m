function task33_visualization(F_est,F_gt,errorMSEN,errorPEPN)
    F_err = flow_error_image(F_gt,F_est);
    figure,imshow([flow_to_color([F_est;F_gt]);F_err]);
    title(sprintf('MSEN: %.2f, PEPN: %.2f %%',errorMSEN,errorPEPN*100));
    figure,flow_error_histogram(F_gt,F_est);
end