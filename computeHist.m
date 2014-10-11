function hists = computeHist(totalImages, images, numFilters,bins)

    hists=zeros([totalImages*numFilters,bins*3*numFilters]);%One filter for each band

    display('Computing histograms....');
    parfor_progress(totalImages);% External library Copyright (c) 2011, Jeremy Scheff
    parfor i=1:totalImages
        im = images(i,:,:,:);
        im = squeeze(im);%Remove the first 'simgle' dimension
        [h_im_r]=hist(reshape(im(:,:,1),[1 size(im,1)*size(im,2)]),bins);
        [h_im_g]=hist(reshape(im(:,:,2),[1 size(im,1)*size(im,2)]),bins);
        [h_im_b]=hist(reshape(im(:,:,3),[1 size(im,1)*size(im,2)]),bins);
        hists(i,:)=[h_im_r h_im_g h_im_b];
        parfor_progress;
    end
    parfor_progress(0);
