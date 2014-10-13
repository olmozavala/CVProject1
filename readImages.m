function images = readImages(totalImages, imgPath)

    % Read one image and obtain the dimensions
    fname=sprintf('%s/%i.jpg',imgPath,0);
    tempImg = double(imread(fname,'jpg'));
    dim = size(tempImg);
    images = zeros(totalImages, dim(1), dim(2), dim(3));
    parfor_progress(totalImages);
    for i=1:totalImages
        fname=sprintf('%s/%i.jpg',imgPath,i-1);
        clear tempImg;
        tempImg = imread(fname,'jpg');
        if( size(tempImg,1) ~= dim(1) ) %The image is rotated
            images(i,:,:,1)= tempImg(:,:,1)';
            images(i,:,:,2)= tempImg(:,:,2)';
            images(i,:,:,3)= tempImg(:,:,3)';
        else
            images(i,:,:,:)= tempImg;
        end
        parfor_progress;
    end
    parfor_progress(0);
