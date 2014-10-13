% The parameter option indicates which filters are we using.
function [filteredImg numFilters] = filterImages(images, option)
    switch option
        case 1 %No filters (just the intensity filter)
            filteredImg = images;
            numFilters = 1;
        case 2 % Using just GaussMask
            filteredImg = zeros(size(images));
            numFilters = 1;
            kernelSize = 5;
            sigma = 0.7;
            gaussMask = oz_gaussMask(kernelSize, sigma);
            for i=1:length(images)
                filteredImg(i,:,:,1) = conv2(squeeze(images(i,:,:,1)),gaussMask, 'same');
                filteredImg(i,:,:,2) = conv2(squeeze(images(i,:,:,2)),gaussMask, 'same');
                filteredImg(i,:,:,3) = conv2(squeeze(images(i,:,:,3)),gaussMask, 'same');
            end
            % If you want to visualize any (i) of the filtered images use:
            %imshow(uint8(squeeze(filteredImg(i,:,:,3)))); % 3 is the band of the image (blue)

    end
