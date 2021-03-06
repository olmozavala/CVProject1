function siftScore = sift(totalImages)


%% Calculate descriptors for images
tic;
if exist('Variables/descriptors.mat', 'file')
    load('descriptors.mat','descriptors');
else
    display('Detecting SIFT features and descriptors...');
    parfor_progress(totalImages);
    for i=1:totalImages
        [fa, descriptors{i}] = vl_sift(single(rgb2gray(uint8(squeeze(origImages(i,:,:,:))))));
        parfor_progress;
    end
    save('Variables/descriptors.mat','descriptors');
end


%% Compare descriptors to determine scores 
if exist('Variables/scores.mat', 'file')
    load('scores.mat','score');
else
    display('Computing Scores...');
    for i=1:totalImages
        tic;
        parfor j=1:totalImages
            [matches, scores{i,j}] = vl_ubcmatch(descriptors{i}, descriptors{j});
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
parfor i=1:totalImages
    for j=1:totalImages
        % Utilize Cantor pairing to ensure one to one mapping for 
        % number of matched descriptors with their average
        % distance(Euclidean)
        k1=round(mean(scores{i,j})/maxDist);
        k2=length(scores{i,j});
        siftScore(i,j) = (0.5*(k1+k2)*(k1+k2+1))+k2;
    end
end

end
