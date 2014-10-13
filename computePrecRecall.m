function precision_recall = computePrecRecall(totalImages, orderedIndexes)

    % First dimension  has 1,...,totalImages for each column
    % Second dimension has the Precision for each image
    % Third dimension has the Recall for each image
    precision_recall=zeros([totalImages,totalImages,3]);
    parfor_progress(totalImages);% External library Copyright (c) 2011, Jeremy Scheff
    for j=1:totalImages
        correct_ones = 0;
        parfor_progress;
        for i=1:totalImages
            precision_recall(j,i,1)=i;
            curr_c=ceil(orderedIndexes(i,j)/100);
            if curr_c == ceil(j/100),
                correct_ones = correct_ones+1;
            end
            precision_recall(j,i,2) = correct_ones/i;
            precision_recall(j,i,3) = correct_ones/100;
        end
    end
    parfor_progress(0);

