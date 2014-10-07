function hists = computeHist(totalImages, imgPath)

    hists=zeros([totalImages,768]);
    display('Computing histograms....');
    parfor_progress(totalImages);% External library Copyright (c) 2011, Jeremy Scheff
    parfor i=1:totalImages
        fname=sprintf('%s/%i.jpg',imgPath,i-1);
        im=double(imread(fname,'jpg'));
        [h_im_r]=hist(reshape(im(:,:,1),[1 size(im,1)*size(im,2)]),256);
        [h_im_g]=hist(reshape(im(:,:,2),[1 size(im,1)*size(im,2)]),256);
        [h_im_b]=hist(reshape(im(:,:,3),[1 size(im,1)*size(im,2)]),256);
        hists(i,:)=[h_im_r h_im_g h_im_b];
        parfor_progress;
    end
    parfor_progress(0);
