function [test_image_res]=computed_morphology(test_image_res)
          test_image_res=bwareaopen(test_image_res,30); 
          test_image_res=imclose(test_image_res,strel('square',3));
          test_image_res=imfill(uint8(test_image_res),4,'holes');
end