function hists = computeHist(totalImages, images, numFilters,bins)

    hists=zeros([totalImages,bins*3*numFilters]);%One filter for each band

    if(totalImages>1 || numFilters>1) % We have more than one image
        totRows = size(images(1,:,:,:),2);
        totCols = size(images(1,:,:,:),3);
    else
        totRows = size(images,1);
        totCols = size(images,2);
    end

    minRange = 0;
    maxRange = 256;
    histRange = [minRange:(maxRange-minRange)/(bins-1):maxRange];
    tempSpectralHist = zeros(3*bins*numFilters,1);
    for i=0:totalImages-1
        for j=0:numFilters-1
            % Modifying the range depending on the filter used (it didn't help)
            %{
            switch j
                case 0
                    minRange = 0;
                    maxRange = 256;
                case 1
                    minRange = -256;
                    maxRange = 256;
                case 2
                    minRange = -256;
                    maxRange = 256;
                case 3
                    minRange = -512;
                    maxRange = 512;
                case 4
                    minRange = -512;
                    maxRange = 512;
                case 5
                    minRange = 0;
                    maxRange = 256;
                case 6
                    minRange = 0;
                    maxRange = 256;
                case 1
            end
                    
            histRange = [minRange:(maxRange-minRange)/(bins-1):maxRange];
            }%
            if(totalImages>1 || numFilters>1) % We have more than one image
                im = images(i*numFilters+1+j,:,:,:);
                im = squeeze(im);%Remove the first 'simgle' dimension
            else
                im = images;
            end

            % ---- Using bins ---------
            %tempSpectralHist(j*bins*3+1:j*bins*3+bins) = hist(reshape(im(:,:,1),[1 totRows*totCols]),bins);
            %tempSpectralHist(j*bins*3+bins+1:j*bins*3+2*bins) = hist(reshape(im(:,:,2),[1 totRows*totCols]),bins);
            %tempSpectralHist(j*bins*3+2*bins+1:j*bins*3+3*bins) = hist(reshape(im(:,:,3),[1 totRows*totCols]),bins);
            
            % ---- Using ranges ---------
            tempSpectralHist(j*bins*3+1:j*bins*3+bins) = hist(reshape(im(:,:,1),[1 totRows*totCols]),histRange);
            tempSpectralHist(j*bins*3+bins+1:j*bins*3+2*bins) = hist(reshape(im(:,:,2),[1 totRows*totCols]),histRange);
            tempSpectralHist(j*bins*3+2*bins+1:j*bins*3+3*bins) = hist(reshape(im(:,:,3),[1 totRows*totCols]),histRange);
        end

        if(totalImages>1) % We have more than one image
            hists(i+1,:)= tempSpectralHist;
        else
            hists= tempSpectralHist;
        end
    end
