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

%% Obtaining finalScore

% Obtaining max distance
maxDist = 0;
for i=1:totalImages
    for j=1:totalImages
        currMax = max(scores{i,j});
        if(currMax > maxDist)
            maxDist = currMax;
        end
    end
end

display('Computing our sift score');
siftScore = zeros(totalImages,totalImages);
siftMinDistance = zeros(totalImages,totalImages);
siftScoreOnlyDistance = zeros(totalImages,totalImages);
parfor_progress(totalImages);
parfor i=1:totalImages
    currNumOfDesc = length(descriptors{i});
    for j=1:totalImages
        % This is our proposed formula
        siftScore(i,j) = (mean(scores{i,j}/maxDist))/( length(scores{i,j})/currNumOfDesc );
        siftMinDistance(i,j) = min([scores{i,j} 2]);
        siftScoreOnlyDistance(i,j) = (mode(scores{i,j}./maxDist));
    end
    parfor_progress;
end

orderedIndexes = zeros(totalImages,totalImages);
for i=1:totalImages
    [val orderedIndexes(i,:)] = sort(siftScore(i,:));
end

precision_recall = computePrecRecall(totalImages, orderedIndexes);

avgPR = computeAvgPR(totalImages, orderedIndexes, precision_recall);

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

%% Plot average precision 
figure('Position',[100,100,1500,600])
subplot(1,2,1); 
%Simplicity results
plot(1:10,simplicityPR(:,1),'r*');
hold on
plot(1:10,avgPR(:,1),'gs');
hold off
title('Average Precision')
xlabel('Category ID');
ylabel('Precision');
legend('SIMPLIcity','Sift');
legend('Location','northwest');
xlim([0,11]);
grid on;
