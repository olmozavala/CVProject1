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


    %% Average precision and rank 
    display('Computing average precision and rank....');
    switch problem
        case 1
            avgPR1=computeAvgPR(totalImages, ind, precision_recall);
        case 2
            avgPR2=computeAvgPR(totalImages, ind, precision_recall);
    end
    
end

    %% Plot average precision 
    figure('Position',[100,100,1000,600])
    subplot(1,2,1); 
    plot(1:10,simplicityPR(:,1),'*',1:10,avgPR1(:,1),'o',1:10,avgPR2(:,1),'s');
    title('Average Precision')
    xlabel('Category ID');
    ylabel('Precision');
    legend('SIMPLIcity','Color Histogram','Spectral Histogram');
    xlim([0,11]);
    grid on;

    %% Plot average rank
    subplot(1,2,2); 
    plot(1:10,simplicityPR(:,2),'*',1:10,avgPR1(:,2),'o',1:10,avgPR2(:,2),'s');
    title('Average Rank')
    xlabel('Category ID');
    ylabel('Rank');
    legend('SIMPLIcity','Color Histogram','Spectral Histogram');
    xlim([0,11]);
    grid on;

    %plot curve for image x
    % x=499;
    % plot(precision_recall(x,:,2),precision_recall(x,:,3));
    % xlabel('Precision');
    % ylabel('Recall');


