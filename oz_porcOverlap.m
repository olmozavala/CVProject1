%%%
% This function returns the % of overlap between 2 histograms
function porcOverlap = oz_porcOverlap(h, h2)

sumHist = sum(h);
nbins = length(h);%Obtain the number of bins
sumOverlap = 0;

for i=1:nbins
    minVal = min(h(i),h2(i));% How many values are the same
    sumOverlap = sumOverlap + minVal;
end

porcOverlap = sumOverlap/sumHist;% What is the % of histogram intersected
