% The parameter option indicates which filters are we using.
function [filteredImg numFilters] = filterImages(images, option)
    switch option
        case 1 %No filters (just the intensity filter)
            filteredImg = images;
            numFilters = 1;
        case 2 % Using just GaussMask
            kernelSize = 5;
            sigma = 0.7;
            filteredImg = zeros(size(images));
            numFilters = 1;
            gaussMask = oz_gaussMask(kernelSize, sigma);
            parfor_progress(length(images));
            for i=1:length(images)
                filteredImg(i,:,:,1) = conv2(squeeze(images(i,:,:,1)),gaussMask, 'same');
                filteredImg(i,:,:,2) = conv2(squeeze(images(i,:,:,2)),gaussMask, 'same');
                filteredImg(i,:,:,3) = conv2(squeeze(images(i,:,:,3)),gaussMask, 'same');
                parfor_progress;
            end
            parfor_progress(0);
            % If you want to visualize any (i) of the filtered images use:
            %imshow(uint8(squeeze(filteredImg(i,:,:,3)))); % 3 is the band of the image (blue)
        case 3 % Using the 4 filters from the paper
            dimsImages = size(images);
            numFilters = 7;

            filteredImg = zeros(dimsImages(1)*numFilters, dimsImages(2), dimsImages(3), dimsImages(4));
            kernelSize = 5;
            sigma = 0.7;

            theta = 0;
            gabor = gaborFilter(kernelSize, sigma, theta);

            dx = [0 -1 1]; % Range [-256 256]
            dy = [0 -1 1]'; % Range [-256 256]
            dxx = [-1 2 -1];% Range [-512 512]
            dyy = [-1 2 -1]';% Range [-512 512]
            maskLoG = maskLoGFunc(kernelSize, sigma);% Range ?
            gaussMask = oz_gaussMask(kernelSize, sigma);% Range [0 256]

            % TODO missing Gabor filter
            parfor_progress(length(images));
            for i=0:length(images)-1
                % First filter is the intensity filter
                filteredImg(i*numFilters+1,:,:,1) = images(i+1,:,:,1);
                filteredImg(i*numFilters+1,:,:,2) = images(i+1,:,:,2);
                filteredImg(i*numFilters+1,:,:,3) = images(i+1,:,:,3);
                %min(min(filteredImg(i*numFilters+1,:,:,3)))
                %max(max(filteredImg(i*numFilters+1,:,:,3)))
                % Second filter is dx
                filteredImg(i*numFilters+2,:,:,1) = conv2(squeeze(images(i+1,:,:,1)),dx, 'same');
                filteredImg(i*numFilters+2,:,:,2) = conv2(squeeze(images(i+1,:,:,2)),dx, 'same');
                filteredImg(i*numFilters+2,:,:,3) = conv2(squeeze(images(i+1,:,:,3)),dx, 'same');
                %min(min(filteredImg(i*numFilters+2,:,:,3)))
                %max(max(filteredImg(i*numFilters+2,:,:,3)))
                % Third filter is dy
                filteredImg(i*numFilters+3,:,:,1) = conv2(squeeze(images(i+1,:,:,1)),dy, 'same');
                filteredImg(i*numFilters+3,:,:,2) = conv2(squeeze(images(i+1,:,:,2)),dy, 'same');
                filteredImg(i*numFilters+3,:,:,3) = conv2(squeeze(images(i+1,:,:,3)),dy, 'same');
                %min(min(filteredImg(i*numFilters+3,:,:,3)))
                %max(max(filteredImg(i*numFilters+3,:,:,3)))
                % Fordth filter is dxx
                filteredImg(i*numFilters+4,:,:,1) = conv2(squeeze(images(i+1,:,:,1)),dxx, 'same');
                filteredImg(i*numFilters+4,:,:,2) = conv2(squeeze(images(i+1,:,:,2)),dxx, 'same');
                filteredImg(i*numFilters+4,:,:,3) = conv2(squeeze(images(i+1,:,:,3)),dxx, 'same');
                %min(min(filteredImg(i*numFilters+4,:,:,3)))
                %max(max(filteredImg(i*numFilters+4,:,:,3)))
                % Fifth filter is dxx
                filteredImg(i*numFilters+5,:,:,1) = conv2(squeeze(images(i+1,:,:,1)),dyy, 'same');
                filteredImg(i*numFilters+5,:,:,2) = conv2(squeeze(images(i+1,:,:,2)),dyy, 'same');
                filteredImg(i*numFilters+5,:,:,3) = conv2(squeeze(images(i+1,:,:,3)),dyy, 'same');
                %min(min(filteredImg(i*numFilters+5,:,:,3)))
                %max(max(filteredImg(i*numFilters+5,:,:,3)))
                % Sixth filter is LoG
                filteredImg(i*numFilters+6,:,:,1) = conv2(squeeze(images(i+1,:,:,1)),maskLoG, 'same');
                filteredImg(i*numFilters+6,:,:,2) = conv2(squeeze(images(i+1,:,:,2)),maskLoG, 'same');
                filteredImg(i*numFilters+6,:,:,3) = conv2(squeeze(images(i+1,:,:,3)),maskLoG, 'same');
                %min(min(filteredImg(i*numFilters+6,:,:,3)))
                %max(max(filteredImg(i*numFilters+6,:,:,3)))
                % Seventh filter is Gauss
                filteredImg(i*numFilters+7,:,:,1) = conv2(squeeze(images(i+1,:,:,1)),gaussMask, 'same');
                filteredImg(i*numFilters+7,:,:,2) = conv2(squeeze(images(i+1,:,:,2)),gaussMask, 'same');
                filteredImg(i*numFilters+7,:,:,3) = conv2(squeeze(images(i+1,:,:,3)),gaussMask, 'same');
                %min(min(filteredImg(i*numFilters+7,:,:,3)))
                %max(max(filteredImg(i*numFilters+7,:,:,3)))
                parfor_progress;
            end
            parfor_progress(0);
        case 4 % Intensity and Gauss
            dimsImages = size(images);
            numFilters = 2;

            filteredImg = zeros(dimsImages(1)*numFilters, dimsImages(2), dimsImages(3), dimsImages(4));
            kernelSize = 5;
            sigma = 0.7;

            gaussMask = oz_gaussMask(kernelSize, sigma);% Range [0 256]

            % TODO missing Gabor filter
            parfor_progress(length(images));
            for i=0:length(images)-1
                % First filter is the intensity filter
                filteredImg(i*numFilters+1,:,:,1) = images(i+1,:,:,1);
                filteredImg(i*numFilters+1,:,:,2) = images(i+1,:,:,2);
                filteredImg(i*numFilters+1,:,:,3) = images(i+1,:,:,3);
                %min(min(filteredImg(i*numFilters+1,:,:,3)))
                %max(max(filteredImg(i*numFilters+1,:,:,3)))
                % Second filter is dx
                %filteredImg(i*numFilters+2,:,:,1) = images(i+1,:,:,1);
                %filteredImg(i*numFilters+2,:,:,2) = images(i+1,:,:,2);
                %filteredImg(i*numFilters+2,:,:,3) = images(i+1,:,:,3);
                % Second filter is dx
                filteredImg(i*numFilters+2,:,:,1) = conv2(squeeze(images(i+1,:,:,1)),gaussMask, 'same');
                filteredImg(i*numFilters+2,:,:,2) = conv2(squeeze(images(i+1,:,:,2)),gaussMask, 'same');
                filteredImg(i*numFilters+2,:,:,3) = conv2(squeeze(images(i+1,:,:,3)),gaussMask, 'same');
                %min(min(filteredImg(i*numFilters+4,:,:,3)))
                %max(max(filteredImg(i*numFilters+4,:,:,3)))
                parfor_progress;
            end
            parfor_progress(0);

            % If you want to visualize any (i) of the filtered images use:
            %imshow(uint8(squeeze(filteredImg(i,:,:,3)))); % 3 is the band of the image (blue)
    end
