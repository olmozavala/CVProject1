clc;
%clear all;
%close all;

addpath('externalLib');
%histograms
totalImages = 1000;

% Running in parallel, check if the pool of threads is already open
% if matlabpool('size') == 0 
%     infoLocal = parcluster('local');
%     maxWorkers = infoLocal.NumWorkers;
%     matlabpool('open',maxWorkers);
% end

%% Read images
tic;
origImages = readImages(totalImages, 'corel');
toc;

%% Reduce size of images (testing to improve speed)
tic;
display('Reducing size of pyramids...');
imgDims = size(origImages);
images = zeros(imgDims(1), ceil(imgDims(2)/2), ceil(imgDims(3)/2), 3);
parfor i=1:totalImages
    images(i,:,:,:) = impyramid(squeeze(origImages(i,:,:,:)),'reduce');
end
clear origImages;
toc;

%% Apply filters. 
% The output should contain one extra dimension, for the number
% of filters applied. If we use one filter, then filterImg size = images, for 
% two filters filterIMg size = 2*images
tic;
% The option indicates which filters are we using. 
% Option = 1. Only using the intensity filter (no filter)
% Option = 2. Uses LoG filter
option = 3;
[filteredImg numFilters]= filterImages(images,option);
toc;

%% Compute histograms for each filtered image
tic;
bins = 20;
hists = computeHist(totalImages, filteredImg, numFilters, bins);
toc;

%% Histogram intersections
tic;
dists = computeHistDist(hists,totalImages);
[Y, ind] = sort(-dists);
toc;

%% Precision recall[query image, all images, PR]
%every image is queried against all totalImages images
tic;
precision_recall = computePrecRecall(totalImages, ind);
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

%% Average precision and rank 
avgPR=computeAvgPR(totalImages, ind, precision_recall);

%% Plot average precision 
subplot(1,2,1); 
plot(1:10,simplicityPR(:,1),'*',1:10,avgPR(:,1),'o');
xlabel('Category');
ylabel('Precision');
legend('Simplicity','Color Histogram');
xlim([0,11]);
grid on;

%% Plot average rank
subplot(1,2,2); 
plot(1:10,simplicityPR(:,2),'*',1:10,avgPR(:,2),'o');
xlabel('Category');
ylabel('Rank');
legend('Simplicity','Color Histogram');
xlim([0,11]);
grid on;

%plot curve for image x
% x=499;
% plot(precision_recall(x,:,2),precision_recall(x,:,3));
% xlabel('Precision');
% ylabel('Recall');

