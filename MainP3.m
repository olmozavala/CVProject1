%% Problem 3 (25 points) Content-based image retrieval
% For this problem the objective was to compare images using its histogram.
% We search similar images depending on how similar their histograms were. 
%close all;
%clear all;
%clc;

folders = {'pict/c1/' 'pict/c2/' 'pict/c3/'};

total = 30;%Total number of images
nbins = 256;%Number of bins per histogram
allNames = cell(total,1);
idx = 1;

% Obtains all the names of the images
for testFolder=1:3
    for queryImage=0:9
        tempImgName = strcat(num2str(queryImage),'.ppm');
        testImageName = strcat(folders(testFolder),tempImgName);
        allNames(idx) = testImageName;
        idx = idx+1;
    end
end

figure('Position', [1000, 100, 1400, 400]);
for exercise=1:3
    % Selects one of the _base_ images.
    baseImageName = char(strcat(folders(exercise),'1.ppm'));
    baseImage = imread(baseImageName);

    % Initializes the arrays that contains the amount of histogram overlap
    avgOverlap = zeros(total,1);
    avgOverlapImgs = cell(total,1);

    % Obtains the percentage of histogram overlap for each image
    for retrieved=1:total
        testImage = imread(char(allNames(retrieved)));
        avgOverlap(retrieved) = oz_avgPorcOverlap(baseImage, testImage, nbins);
    end

    % Orders the Overlap of the histograms
    [sortOverlap sortIndx] = sort(avgOverlap, 'descend');
    disp(strcat('Top 10 images for_ ',baseImageName));
    disp(allNames(sortIndx(1:10))); 

    % Compute Precision Recall
    relevant = 0;
    precision = zeros(total,1);
    recall = zeros(total,1);
    for retrieved=1:total
        if  ( sortIndx(retrieved) > ((exercise-1)*10) && ...
              sortIndx(retrieved) <= ((exercise)*10)) 
            relevant = relevant + 1;
        end
        precision(retrieved) = relevant/retrieved;
        recall(retrieved) = relevant/10;
    end
    % I couldn't find any better way to plot the precision/recall
    subplot(1,3,exercise); hold on; plot(precision,recall,'-*');
    title(strcat('Precision recall for',baseImageName));
    xlabel('Precision');
    ylabel('Recall');
end
