function dists = computeHistDist(hists,totalImages)

    display('Calculating histogram distances');
    parfor_progress(totalImages);% External library Copyright (c) 2011, Jeremy Scheff
    dists=zeros([totalImages,totalImages]);
    parfor i=1:totalImages
        parfor_progress;
        for j=1:totalImages
            dists(i,j)=sum(min(hists(i,:),hists(j,:)));
        end
    end
    parfor_progress(0);

