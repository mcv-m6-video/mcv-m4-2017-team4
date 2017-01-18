function imageShadowRemoved=shadow_removal(imRGB,binMask,previous_image)
    %imwrite(binMask,'Results/sample.png')
    alpha = 0.1;
    beta = 0.9;
    prev_image = previous_image;
    image = imRGB;
    mask = repmat(binMask, [1, 1, 3]);
    image(~mask) = 0;
    prev_image(~mask) = 0;
    l_image = double(image(:,:,1)) + double(image(:,:,2)) + double(image(:,:,3)); %lightness measure
%     r_image = double(image(:,:,1))./l_image;
%     g_image = double(image(:,:,2))./l_image;
    l_prev_image = double(prev_image(:,:,1)) + double(prev_image(:,:,2)) + double(prev_image(:,:,3)); %lightness measure
%     r_prev_image = double(prev_image(:,:,1))./l_prev_image;
%     g_prev_image = double(prev_image(:,:,2))./l_prev_image;
    cd = l_image./l_prev_image;
    shadow = (cd > alpha) - (cd >= beta);
    %imwrite(shadow,'Results/shadow.png')
    imageShadowRemoved = binMask - shadow;
    %imwrite(imageShadowRemoved,'Results/shadowRemoved.png')
end