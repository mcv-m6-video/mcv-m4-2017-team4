function [image_res,params] = adaptative_model(frame,imagen_previa,params)
    gray_image=double(rgb2gray(frame));
    crop_invalidpixels=frame(:,:,1)==0 & frame(:,:,2)==0 & frame(:,:,2)==0;
%     aux_image=abs(double(frame(:,:,1))-params.mean(:,:,1))>=params.alpha.*(params.var(:,:,1)+2)&abs(double(frame(:,:,2))-params.mean(:,:,2))>=params.alpha.*(params.var(:,:,2)+2)&abs(double(frame(:,:,3))-params.mean(:,:,3))>=params.alpha.*(params.var(:,:,3)+2);
    image_res=abs(gray_image-params.mean)>=params.alpha.*(sqrt(params.var)+2);
  
    if params.shadow_active
        image_res=shadow_removal(frame,image_res,imagen_previa,params);
    end
    [image_res]=computed_morphology(image_res);  
    
    image_res=image_res>0;
    mask=~image_res;
    mask(crop_invalidpixels)=0;
    params.mean(mask)=params.rho*gray_image(mask) + (1-params.rho)*params.mean(mask);
    params.var(mask)=params.rho*(gray_image(mask)-params.mean(mask)).^2+(1-params.rho)*params.var(mask);
    image_res(crop_invalidpixels)=0;
end