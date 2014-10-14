function hists = computeHist(totalImages, images, numFilters,bins)

    hists=zeros([totalImages,bins*3*numFilters]);%One filter for each band

    parfor_progress(totalImages);% External library Copyright (c) 2011, Jeremy Scheff
    totRows = size(images(1,:,:,:),2);
    totCols = size(images(1,:,:,:),3);

    minRange = 0;
    maxRange = 256;
    histRange = [minRange:(maxRange-minRange)/(bins-1):maxRange]

    tempSpectralHist = zeros(3*bins*numFilters,1);
    for i=0:totalImages-1

        for j=0:numFilters-1
            im = images(i*numFilters+1+j,:,:,:);
            im = squeeze(im);%Remove the first 'simgle' dimension

            % ---- Using bins ---------
            %tempSpectralHist(j*bins*3+1:j*bins*3+bins) = hist(reshape(im(:,:,1),[1 totRows*totCols]),bins);
            %tempSpectralHist(j*bins*3+bins+1:j*bins*3+2*bins) = hist(reshape(im(:,:,2),[1 totRows*totCols]),bins);
            %tempSpectralHist(j*bins*3+2*bins+1:j*bins*3+3*bins) = hist(reshape(im(:,:,3),[1 totRows*totCols]),bins);
            
            % ---- Using ranges ---------
            tempSpectralHist(j*bins*3+1:j*bins*3+bins) = hist(reshape(im(:,:,1),[1 totRows*totCols]),histRange);
            tempSpectralHist(j*bins*3+bins+1:j*bins*3+2*bins) = hist(reshape(im(:,:,2),[1 totRows*totCols]),histRange);
            tempSpectralHist(j*bins*3+2*bins+1:j*bins*3+3*bins) = hist(reshape(im(:,:,3),[1 totRows*totCols]),histRange);
        end

        hists(i+1,:)= tempSpectralHist;
        parfor_progress;
    end
    parfor_progress(0);
