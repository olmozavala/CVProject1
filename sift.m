clf
clear
close all
addpath(genpath('externalLib'));
addpath(genpath('Variables'));
totalImages = 1000;

% Running in parallel, check if the pool of threads is already open
if matlabpool('size') == 0 
    infoLocal = parcluster('local');
    maxWorkers = infoLocal.NumWorkers;
    matlabpool('open',maxWorkers);
end


% disp('Reading all the images...');
% origImages = readImages(totalImages, 'corel');
    

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


%% Compare descriptors to determine scores 
display('Computing Scores...');
if exist('Variables/scores.mat', 'file')
    load('scores.mat','score');
else
    for i=1:totalImages
        tic;
        parfor j=1:totalImages
            [matches, scores{i,j}] = vl_ubcmatch(descriptors{i}, descriptors{j});
%             scores{i,j}=uint8(score);
        end
        fprintf('%d of 1000: %c',i);
        toc;
    end
    save('Variables/scores.mat','scores');
end
scores = score;
clear score;
toc;

% Normalizing the distances
maxScore = max(max(scores));
normScores = scores./maxScore;

% Obtaining finalScore
siftScore = zeros(totalImages,totalImages);
for i=1:totalImages
    currNumOfDesc = length(descriptors{i});
    for j=1:totalImages
        % This is our proposed formula
        siftScore(i,j) = mean(normScores(i,:))/( length(normScores(i,:))/currNumOfDesc );
    end
end
