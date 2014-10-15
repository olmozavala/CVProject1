clf
clear
close all
addpath(genpath('externalLib'));
addpath(genpath('Variables'));

% Running in parallel, check if the pool of threads is already open
if matlabpool('size') == 0 
    infoLocal = parcluster('local');
    maxWorkers = infoLocal.NumWorkers;
    matlabpool('open',maxWorkers);
end

totalImages = 1000;

disp('Reading all the images...');
origImages = readImages(totalImages, 'corel');
    

%% Calculate descriptors for images
tic;
display('Detecting SIFT features and descriptors...');
parfor_progress(totalImages);
if exist('Variables/descriptors.mat', 'file')
    load('descriptors.mat','descriptors');
else
    for i=1:totalImages
        [fa, descriptors{i}] = vl_sift(single(rgb2gray(uint8(squeeze(origImages(i,:,:,:))))));
        parfor_progress;
    end
    save('Variables/descriptors.mat','descriptors');
end
toc;


%% Compare descriptors to determine scores 
%Total Images set to 100 for TESTING PURPOSES!!!!
totalImages = 100;
tic;
display('Computing Scores...');
parfor_progress(totalImages*totalImages);
if exist('Variables/scores.mat', 'file')
    load('scores.mat','scores');
else
    for i=1:totalImages
        for j=1:totalImages
            [matches, scores{i,j}] = vl_ubcmatch(descriptors{i}, descriptors{j});
            parfor_progress;
        end
    end
    save('Variables/scores.mat','scores');
end
toc;