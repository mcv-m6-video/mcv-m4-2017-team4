function poscorrMin=get_max_corr_pos(curr_i,curr_j,previous_image,current_image,block_size,area_size)
    original_block=double(current_image(curr_i:curr_i+block_size/2,curr_j:curr_j+block_size/2));
    image_size=size(previous_image);
    mini=1;
    minj=1;
    maxi=image_size(1);
    maxj=image_size(2);
    if (mini<curr_i-area_size/2)
        mini=curr_i-area_size/2;
    end
    if (minj<curr_j-area_size/2)
        minj=curr_j-area_size/2;
    end
    if (maxi>curr_i+area_size/2)
        maxi=curr_i+area_size/2;
    end
    if (maxj>curr_j+area_size/2)
        maxj=curr_j+area_size/2;
    end

    prev_block=double(previous_image(mini:maxi,minj:maxj));
    c = xcorr2(original_block,prev_block);
    [xpeak, ypeak] = find(c==max(c(:)));
    poscorrMin= [xpeak+mini ypeak+minj];
end