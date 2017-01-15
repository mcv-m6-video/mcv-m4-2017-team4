function [mean_dataset, sd_dataset,background] = GaussianAdaptativeClassify (inputFolder,dirList,j,gaussianColor,sd_dataset,mean_dataset,alpha,p,WriteResults,datasetName)
   %Classify for the Recursive Gaussian modeling for background substraction

   current_image = imread(strcat(inputFolder,dirList(j).name));
   if ~gaussianColor 
       current_image = double(rgb2gray(current_image));
   end 
       
   background = (abs(current_image-mean_dataset) > (alpha*(sd_dataset+2)));
   
   img_back=background.*current_image;
   
   mean_dataset = (1-p)*mean_dataset+p*img_back;
   sd_dataset = sqrt((1-p)*sd_dataset.^2)+p*(img_back-mean_dataset).^2;

   if(WriteResults)
       imwrite(background,strcat('./results/recursive/backgroundMask/',datasetName,'/',num2str(j),'_alpha_',num2str(alpha),'_p_',num2str(p),'.png'));
   end
   
end