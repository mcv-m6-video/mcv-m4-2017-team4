function [ mean_dataset, sd_dataset ] = GaussianTraining( inputFolder,dirlist,numberTraining,gaussianColor)
%Train for the Non-recursive Gaussian modeling for background substraction
%The function compute the mean and standard deviation of a set of images 
    
    %Load the images and compute the sum of the images
    %Inicialize the matrix
    size_im = size(imread(strcat(inputFolder,dirlist(1).name)));
    if(gaussianColor)
        im_array = zeros([size_im numberTraining]);
    else
        im_array = zeros([size_im(1:2) numberTraining]);
    end
    %Read and cummulate sum
    for ii=1:numberTraining
        if(gaussianColor)
            im_array(:,:,ii) =imread(strcat(inputFolder,dirlist(ii).name));
        else
            im_array(:,:,ii) = rgb2gray(imread(strcat(inputFolder,dirlist(ii).name)));
        end
    end;
    mean_dataset = mean(im_array,3);
    sd_dataset = std(im_array,0,3);
    %Mean and standard deviation
    %mean_dataset = uint8(cumsum_image / numberTraining);
    %Normalization (origv - min)/(max - min) * 255.0
    %sd_dataset = (((cumsum_image - (cumsum_image / numberTraining)).^2) / numberTraining).^(1/2);
    %sd_dataset = uint8((sd_dataset - min(sd_dataset(:))) / (max(sd_dataset(:))-min(sd_dataset(:))) * 255);
end

