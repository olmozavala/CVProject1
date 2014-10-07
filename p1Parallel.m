clc;
clear all;
close all;

addpath('externalLib');
%histograms
totalImages = 1000;

% Running in parallel, check if the pool of threads is already open
if matlabpool('size') == 0 
    matlabpool open 4 % Opens 4 threads
end

tic;
hists = computeHist(totalImages,'corel');
toc;

%histogram intersections
tic;
dists = computeHistDist(hists,totalImages);
[Y, ind] = sort(-dists);
toc;

%precision recall[query image, all images, PR]
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

