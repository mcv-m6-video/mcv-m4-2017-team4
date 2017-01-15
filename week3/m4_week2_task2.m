function m4_week2_task2()
    %CONFIG PARAMETERS
    param.gaussianColor = false;
    param.alpha = 0.25;
    param.maxAlpha = 5;
    param.minAlpha = 0;
    param.minP = 0;
    param.maxP = 1;
    param.pStep = 0.1;
    %Get the Datasets
    datasets = dir('Dataset/');
    datasets = datasets(find(vertcat(datasets.isdir)));
    datasets = datasets(3:end);

    alphaTest = {'Fall' 'Highway' 'Traffic'};

    %best alphas obtained in task 1
    alphaParam = [2, 1.5, 1.7];
    alphaMap = containers.Map(alphaTest,alphaParam);
    TP = zeros([length(datasets) (param.maxP+abs(param.minP))/0.1]); FP=TP;FN=FP;TN=FN;F1=TN;Recall=F1;Precision=Recall;
    for i=1:length(datasets)

        %Training 
        %---------
        %List the images for training
        inputFolder = strcat('Dataset/',datasets(i).name,'/input/');
        dirList = dir(inputFolder);
        %Remove the . .. from the list
        dirList = dirList(3:end);
        %Use the half of the Dataset to train
        numberTraining = floor(length(dirList) / 2);

        [train_mean_dataset{i}, train_sd_dataset{i}] = GaussianTraining(inputFolder,dirList,numberTraining,param.gaussianColor);

    %%   
       %Groundtruth
       %List the groundtruth images
        groundtruthFolder = strcat('Dataset/',datasets(i).name,'/groundtruth/');
        groundtruthList = dir(groundtruthFolder);
        groundtruthList = groundtruthList(3:end);
        imsize = size(imread(strcat(groundtruthFolder,groundtruthList(1).name)));
        groundtruth = zeros([imsize(1:2) length(dirList)-numberTraining+1 ]);
        for test_image=numberTraining+1:length(dirList)
           groundtruth(:,:,test_image-numberTraining) = imread(strcat(groundtruthFolder,strrep(groundtruthList(test_image).name,'in','gt')));
        end
       % estimate p for the recursive cases
       t=1;
       for p=param.minP:param.pStep:param.maxP 
           i_img=1;
           mean_dataset{i} = train_mean_dataset{i}; %asign the original mean calculated in train in every loop
           sd_dataset{i} = train_sd_dataset{i};
           background = zeros([imsize(1:2) length(dirList)-numberTraining+1 ]);
           for j = numberTraining+1:length(dirList)
                [mean_dataset{i}, sd_dataset{i},background(:,:,i_img)] = GaussianAdaptativeClassify (inputFolder,...
                    dirList,j,param.gaussianColor,sd_dataset{i},mean_dataset{i},alphaParam(i),p,true,datasets(i).name);
                i_img=i_img+1;
           end
           %Evaluation
           [TP(i,t),FP(i,t),FN(i,t),TN(i,t),F1(i,t),Recall(i,t),Precision(i,t)] = GaussianEvaluation(background,groundtruth);
           t=t+1;
       end
       
      % estimate p, alpha with a grid search
       pvalue = param.minP:param.pStep:param.maxP;
       alpha = param.minAlpha:param.alpha:param.maxAlpha

       [a,p] = ndgrid(alpha, pvalue);
       inda=0   
       for indx = 1:size(a,1)
           for indy=1:size(a,2)
               i_img=1;
               background = zeros([imsize(1:2) length(dirList)-numberTraining+1 ]);
               for j = numberTraining+1:length(dirList)
                    [mean_dataset{i}, sd_dataset{i},background(:,:,i_img)] = GaussianAdaptativeClassify (inputFolder,...
                        dirList,j,param.gaussianColor,sd_dataset{i},mean_dataset{i},a(indx,indy),p(indx,indy),true,datasets(i).name);
                    i_img=i_img+1;
               end
               %Evaluation
               [TP(i,indx,indy),FP(i,indx,indy),FN(i,indx,indy),TN(i,indx,indy),F1(i,indx,indy),...
                   Recall(i,indx,indy),Precision(i,indx,indy)] = GaussianEvaluation(background,groundtruth);
           end
       end
    end   
    %% Results
%     TP, FP, FN, TN
    x=param.minP:param.pStep:param.maxP;
    for i=1:length(datasets)
        len = length(TP(i,:));
        figure()
        plot((1:len),TP(i,:),(1:len), FP(i,:),(1:len), FN(i,:),(1:len), TN(i,:))
        set(gca,'XTickLabel',x)
        legend('TP','FP','FN','TN')
        title(strcat('Evaluation - Recursive Gaussian modeling - "',datasets(i).name,'" Dataset'))
        xlabel('p Threshold')
        ylabel('Nº Pixels')
    end
    %%    
    %F1-scores curve plots
    x=param.minP:param.pStep:param.maxP;
    figure()
    for i=1:length(datasets)
        hold on
        plot(x,F1(i,:))
    end
    legend('Fall','Highway','Traffic','Location','best')
    for i=1:length(datasets)
        hold on
        [y z] = max(F1(i,:));
        plot(x(z),y,'x','MarkerSize',5)
        strmax = num2str(F1(i,z),'%.2f');
        text(x(z),y,strmax,'HorizontalAlignment','center','VerticalAlignment','bottom');
    end
    title(strcat('F1 Score - Recursive Gaussian modeling'))
    xlabel('p value')
    ylabel('F1 Score')

    %Precision-Recall curve plots
    figure()
    for i=1:length(datasets)     
        hold on
        plot(Recall(i,:),Precision(i,:))      
    end
    legend('Fall','Highway','Traffic','Location','best')
    title(strcat('Precision vs Recall - Recursive Gaussian modeling - "','AUC=',num2str(trapz(Recall(i,:),Precision(i,:)))))
    xlabel('Recall')
    ylabel('Precision')
end