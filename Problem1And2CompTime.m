clc;
clear all;
close all;

addpath('externalLib');
%histograms
totalImages = 1000;

% Running in parallel, check if the pool of threads is already open
if matlabpool('size') == 0 
    infoLocal = parcluster('local');
    maxWorkers = infoLocal.NumWorkers;
    matlabpool('open',maxWorkers);
end

bins = [256 100];% Number of bins for each problem

imgHists = zeros(totalImages, bins(1)*3); % Histograms for problem 1
imgSpectralHists = zeros(totalImages, bins(2)*7*3); % Histograms for problem 2 (using 7 filters)

display('Reading images and computing the histograms....');
tic;
parfor_progress(totalImages);
parfor currIndx =1:totalImages
    %% Read images
    fname=sprintf('corel/%i.jpg',currIndx-1);
    currImgInt = imread(fname,'jpg');

    % Reducing size of image
    currImg = double(impyramid(currImgInt,'reduce'));

    [filteredImg numFilters]= filterImages(currImg,3,1);% Filtered image for problem 2
    %imshow(uint8(squeeze(filteredImg(1,:,:,1))));

    imgHists(currIndx,:) = computeHist(1, currImg, 1, bins(1));
    %plot(imgHists(currIndx,:));
    imgSpectralHists(currIndx,:) = computeHist(1, filteredImg, numFilters, bins(2));
    %plot(imgSpectralHists(currIndx,:));

    parfor_progress;
end
parfor_progress(0);
toc;

%% Average precision and rank for Simplicity method for each class
simplicityPR=[  0.47477 178.3529;
                0.32446 242.0187;
                0.33027 261.6305;
                0.36296 260.7511;
                0.98117 49.3074;
                0.39964 197.1079;
                0.40218 298.6917;
                0.71858 91.5890;
                0.34188 230.2441;
                0.33971 271.2211 ];
liuxSpectralHistsPR=[  0.4667 294.7775;
                0.3267 356.1816;
                0.3078 367.0497;
                0.6075 173.8379;
                0.9914 51.3128;
                0.3967 309.7915;
                0.8038 134.9138;
                0.4826 242.4062;
                0.2358 365.6872;
                0.3578 310.5087 ];
liuxHistsPR=[  0.6585 183.6762;
                0.3012 359.4082;
                0.3166 346.1323;
                0.3969 208.4408;
                0.9876 55.0364;
                0.4851 238.9864;
                0.5461 274.5182;
                0.6388 312.1988;
                0.2228 387.1628;
                0.4890 270.5475 ];            


%% Histogram intersections
titles = {'Color histogram','Spectral histogram'};
for problem=1:2
    switch problem
        case 1
            hists = imgHists;
        case 2
            hists = imgSpectralHists;
    end
    tic;
    display('Calculating histogram distances');
    dists = computeHistDist(hists,totalImages);
    [Y, ind] = sort(-dists);
    toc;

    %% Precision recall[query image, all images, PR]
    %every image is queried against all totalImages images
    tic;
    display('Computing precision recall....');
    precision_recall = computePrecRecall(totalImages, ind);
    toc;

    %% Used to display a single precission recall
    figure
    idx = 401;
    plot( precision_recall(idx,:,2), ...
        precision_recall(idx,:,3),'r*-');
    title(strcat( strcat('Precision Recall for image: ',num2str(idx)), ...
            titles(problem)));
    grid;
    
    figure
    idx = 1;
    plot( precision_recall(idx,:,2), ...
        precision_recall(idx,:,3),'r*-');
    title(strcat( strcat('Precision Recall for image: ',num2str(idx)), ...
            titles(problem)));
    grid;
    
    %% Average precision and rank 
    display('Computing average precision and rank....');
       tic;
    switch problem
        case 1
            imgHistsPR=computeAvgPR(totalImages, ind, precision_recall);
        case 2
            imgSpectralHistsPR=computeAvgPR(totalImages, ind, precision_recall);
    end
    toc;
end

    %% Plot average precision 
    figure('Position',[100,100,1500,600])
    subplot(1,2,1); 
    %Simplicity results
    plot(1:10,simplicityPR(:,1),'r*');
    hold on
    %Liu results
    plot(1:10,liuxHistsPR(:,1),'bo');
    plot(1:10,liuxSpectralHistsPR(:,1),'bs');
    %Our results
    plot(1:10,imgHistsPR(:,1),'go');
    plot(1:10,imgSpectralHistsPR(:,1),'gs');
    hold off
    title('Average Precision')
    xlabel('Category ID');
    ylabel('Precision');
    legend('SIMPLIcity','Liu Color Histogram','Liu Spectral Histogram','Color Histogram','Spectral Histogram');
    legend('Location','northwest');
    xlim([0,11]);
    grid on;

    %% Plot average rank
    subplot(1,2,2); 
    %Simplicity results
    plot(1:10,simplicityPR(:,2),'r*');
    hold on
    %Liu results
    plot(1:10,liuxHistsPR(:,2),'bo');
    plot(1:10,liuxSpectralHistsPR(:,2),'bs');
    %Our results
    plot(1:10,imgHistsPR(:,2),'go');
    plot(1:10,imgSpectralHistsPR(:,2),'gs');
    hold off
    title('Average Rank')
    xlabel('Category ID');
    ylabel('Rank');
    legend('SIMPLIcity','Liu Color Histogram','Liu Spectral Histogram','Color Histogram','Spectral Histogram');
    legend('Location','southwest');
    xlim([0,11]);
    grid on;

    %plot curve for image x
    % x=499;
    % plot(precision_recall(x,:,2),precision_recall(x,:,3));
    % xlabel('Precision');
    % ylabel('Recall');


