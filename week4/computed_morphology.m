function [test_image_res]=computed_morphology(test_image_res)
          test_image_res=imfill(uint8(test_image_res),4);
          test_image_res=bwareaopen(test_image_res,5); 
          test_image_res=imclose(test_image_res,strel('disk',2));
          test_image_res=imfill(uint8(test_image_res),4);
          test_image_res=imopen(test_image_res,strel('disk',1));
end