function images = readImages(totalImages, imgPath)

    disp('Reading all the images...');
    % Read one image and obtain the dimensions
    fname=sprintf('%s/%i.jpg',imgPath,0);
    tempImg = double(imread(fname,'jpg'));
    dim = size(tempImg);
    images = zeros(totalImages, dim(1), dim(2), dim(3));
    %parfor_progress(totalImages);
    for i=1:totalImages
        fname=sprintf('%s/%i.jpg',imgPath,i-1);
        clear tempImg;
        tempImg = imread(fname,'jpg');
        % Make the image the same size (rotate)
        tempImg = reshape(tempImg, [dim(1), dim(2), dim(3)]);
        images(i,:,:,:)= tempImg;
        %parfor_progress;
    end
    %parfor_progress(0);
