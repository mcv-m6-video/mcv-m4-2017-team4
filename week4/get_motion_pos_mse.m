function posMseMin=get_motion_pos_mse(curr_i,curr_j,previous_image,current_image,block_size,area_size)
    current_block=double(current_image(curr_i:curr_i+block_size,curr_j:curr_j+block_size));
    image_size=size(previous_image);
    mini=1;
    minj=1;
    maxi=image_size(1)-block_size;
    maxj=image_size(2)-block_size;
    mseMin=Inf;
    posMseMin=[0 0];
    if (mini<curr_i-area_size)
        mini=curr_i-area_size;
    end
    if (minj<curr_j-area_size)
        minj=curr_j-area_size;
    end
    if (maxi>curr_i+area_size)
        maxi=curr_i+area_size;
    end
    if (maxj>curr_j+area_size)
        maxj=curr_j+area_size;
    end

   for i=mini:1:maxi
        for j=minj:1:maxj
            previous_block=double(previous_image(i:i+block_size,j:j+block_size));
            squarediff=(current_block-previous_block).^2;
            mseAux=sqrt(sum(squarediff(:)));
            if (mseMin>mseAux)
                mseMin=mseAux;
                posMseMin=[i j];
            end
        end
   end
end