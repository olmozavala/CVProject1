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

%% Read images
tic;
images = readImages(totalImages, 'corel');
toc;

%% Apply filters. 
% The output should contain one extra dimension, for the number
% of filters applied. If we use one filter, then filterImg size = images, for 
% two filters filterIMg size = 2*images
tic;
% The option indicates which filters are we using. 
% Option = 1. Only using the intensity filter (no filter)
% Option = 2. Uses LoG filter
option = 2;
[filteredImg numFilters]= filterImages(images,option);
toc;

%% Compute histograms for each filtered image
tic;
bins = 256;
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

%plot curve for image x
x=401;
plot(precision_recall(x,:,2),precision_recall(x,:,3));
xlabel('Precision');
ylabel('Recall');
set(gcf,'Color',[1 1 1]);

