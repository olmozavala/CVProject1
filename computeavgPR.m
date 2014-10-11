function avgPR = computeAvgPR(totalImages, orderedIndexes, precision_recall)

    avgPR=zeros(10,2);
    display('Computing average precision and rank....');
    parfor_progress(totalImages);% External library Copyright (c) 2011, Jeremy Scheff
    %% Average precision and rank 
    for i=1:totalImages
        parfor_progress;
        category=ceil(i/100);
        %average precision
        avgPR(category,1)=avgPR(category,1)+sum(precision_recall(i,1:100,2));
        %average rank (there is probably a better way)
        for j=1:totalImages
            if ceil(orderedIndexes(j,i)/100)==category 
                avgPR(category,2)=avgPR(category,2)+j;
            end
        end
    end
    avgPR=avgPR/10000;
    parfor_progress(0);
