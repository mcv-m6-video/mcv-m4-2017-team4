function [ out ] = GaussianTesting( inputFolder,dirList,mean_dataset,sd_dataset,numberTraining,gaussianColor,alphaVal,WriteResults,datasetName)
%Testing for the Non-recursive Gaussian modeling for background substraction
%The function compute the backgraund substraction of a set of images

%Inicialize the matrix
imsize = size(imread(strcat(inputFolder,dirList(1).name)));
if(gaussianColor)
    out = zeros([imsize length(dirList)-numberTraining+1]);
else
    out = zeros([imsize(1:2) length(dirList)-numberTraining+1 ]);
end

i=1;

for ii=numberTraining+1:length(dirList)
    
    if(gaussianColor)
        current_image = rgb2gray(imread(strcat(inputFolder,dirList(ii).name)));
        %Background
        out(:,:,i) = ~(abs(current_image-mean_dataset) < (alphaVal*(sd_dataset)));
        if(WriteResults)
            imwrite(out(:,:,i),strrep(inputFolder, '/input/', '/results/'));
        end
    else
        current_image = double(rgb2gray(imread(strcat(inputFolder,dirList(ii).name))));
        %Background
        out(:,:,i) = ~(abs(current_image-mean_dataset) < (alphaVal*(sd_dataset+2)));
        if(WriteResults)
            imwrite(background,strcat('./results/recursive/backgroundMask/',datasetName,'/',num2str(ii),'_alpha_',num2str(alphaVal),'.png'));
        end    
    end
    i=i+1;
end;

end

