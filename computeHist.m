function hists = computeHist(totalImages, images, numFilters,bins)

    hists=zeros([totalImages,bins*3*numFilters]);%One filter for each band

    display('Computing histograms....');
    parfor_progress(totalImages);% External library Copyright (c) 2011, Jeremy Scheff
    totRows = size(images(1,:,:,:),2);
    totCols = size(images(1,:,:,:),3);

    minRange = -256;
    maxRange = 512;
    histRange = [minRange:(maxRange-minRange)/(bins-1):maxRange]

    tempSpectralHist = zeros(3*bins*numFilters,1);
    for i=1:totalImages

        for j=0:numFilters-1
            im = images(i+j,:,:,:);
            im = squeeze(im);%Remove the first 'simgle' dimension

            % 0 - bins
            %tempSpectralHist(j*bins*3+1:j*bins*3+bins) = hist(reshape(im(:,:,1),[1 totRows*totCols]),bins);
            % bins - bins*2
            %tempSpectralHist(j*bins*3+bins+1:j*bins*3+2*bins) = hist(reshape(im(:,:,1),[1 totRows*totCols]),bins);
            % bins - bins*3
            %tempSpectralHist(j*bins*3+2*bins+1:j*bins*3+3*bins) = hist(reshape(im(:,:,1),[1 totRows*totCols]),bins);
            tempSpectralHist(j*bins*3+1:j*bins*3+bins) = hist(reshape(im(:,:,1),[1 totRows*totCols]),histRange);
            % bins - bins*2
            tempSpectralHist(j*bins*3+bins+1:j*bins*3+2*bins) = hist(reshape(im(:,:,1),[1 totRows*totCols]),histRange);
            % bins - bins*3
            tempSpectralHist(j*bins*3+2*bins+1:j*bins*3+3*bins) = hist(reshape(im(:,:,1),[1 totRows*totCols]),histRange);

        end
        hists(i,:)= tempSpectralHist;
        parfor_progress;
    end
    parfor_progress(0);
