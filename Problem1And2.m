clc;
clear all;
close all;
addpath(genpath('externalLib'));
addpath(genpath('Variables'));

%histograms
totalImages = 1000;

% Running in parallel, check if the pool of threads is already open
if matlabpool('size') == 0 
    infoLocal = parcluster('local');
    maxWorkers = infoLocal.NumWorkers;
    matlabpool('open',maxWorkers);
end

bins = [256 100];% Number of bins for each problem (1 and 2)

imgHists = zeros(totalImages, bins(1)*3); % Histograms for problem 1
imgSpectralHists = zeros(totalImages, bins(2)*7*3); % Histograms for problem 2 (using 7 filters)

display('Reading images and computing the histograms....');
tic;
parfor_progress(totalImages);
parfor currIndx =1:totalImages
    % Read images
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

%% Histogram distances for each method
for problem=1:3
    switch problem
        case 1 % Color histogram
            hists = imgHists;
            display('Calculating histogram distances');
            dists = computeHistDist(hists,totalImages);            
        case 2 % Spectral histogram
            hists = imgSpectralHists;
            display('Calculating histogram distances');
            dists = computeHistDist(hists,totalImages);
        case 3 % Sift features
            dists=sift(totalImages);
    end
    [Y, ind] = sort(-dists);

    %% Precision recall[query image, all images, PR]
    %every image is queried against all totalImages images
    tic;
    display('Computing precision recall....');
    precision_recall = computePrecRecall(totalImages, ind);
    toc;


    %% Average precision and rank 
    display('Computing average precision and rank....');
    switch problem
        case 1
            imgHistsPR=computeAvgPR(totalImages, ind, precision_recall);
        case 2
            imgSpectralHistsPR=computeAvgPR(totalImages, ind, precision_recall);
        case 3
            siftPR=computeAvgPR(totalImages, ind, precision_recall);
    end
    
end

    %% Plot average precision 
    figure('Position',[100,100,1500,600])
    subplot(1,2,1); 
    %Simplicity results
    plot(1:10,simplicityPR(:,1),'r*','MarkerSize',10);
    hold on
    %Our results
    plot(1:10,imgHistsPR(:,1),'go','MarkerSize',10);
    plot(1:10,imgSpectralHistsPR(:,1),'bs','MarkerSize',10);
    plot(1:10,siftPR(:,1),'md','MarkerSize',10);
    hold off
    title('Average Precision')
    xlabel('Category ID');
    ylabel('Precision');
    legend('SIMPLIcity','Color Histogram','Spectral Histogram','Sift Features');
    legend('Location','northwest');
    xlim([0,11]);
    grid on;

    %% Plot average rank
    subplot(1,2,2); 
    %Simplicity results
    plot(1:10,simplicityPR(:,2),'r*','MarkerSize',10);
    hold on
    %Our results
    plot(1:10,imgHistsPR(:,2),'go','MarkerSize',10);
    plot(1:10,imgSpectralHistsPR(:,2),'bs','MarkerSize',10);
    plot(1:10,siftPR(:,2),'md','MarkerSize',10);
    hold off
    title('Average Rank','FontSize',20)
    xlabel('Category ID');
    ylabel('Rank');
    legend('SIMPLIcity','Color Histogram','Spectral Histogram','Sift Features');
    legend('Location','southwest');
    xlim([0,11]);
    grid on;



