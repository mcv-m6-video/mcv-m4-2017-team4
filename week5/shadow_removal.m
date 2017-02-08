function imageShadowRemoved=shadow_removal(imRGB,binMask,previous_image)
    alpha = 0.5;
    beta = 1.4;
    prev_image = previous_image;
    image = imRGB;
    mask = repmat(binMask, [1, 1, 3]);
    image(~mask) = 0;
    prev_image(~mask) = 0;
    l_image = double(image(:,:,1)) + double(image(:,:,2)) + double(image(:,:,3)); %lightness measure
    l_prev_image = double(prev_image(:,:,1)) + double(prev_image(:,:,2)) + double(prev_image(:,:,3)); %lightness measure
    cd = l_image./l_prev_image;
    shadow = (cd > alpha) - (cd >= beta);
    imageShadowRemoved = binMask - shadow;
end