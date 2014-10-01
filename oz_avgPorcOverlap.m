%% This function computes the average % of overlap between all the histograms of an RGB image
function avgOverlap = oz_avgPorcOverlap(img, img2,nbins)

hr = imhist(img(:,:,1),nbins);
hg = imhist(img(:,:,2),nbins);
hb = imhist(img(:,:,3),nbins);

hr2 = imhist(img2(:,:,1),nbins);
hg2 = imhist(img2(:,:,2),nbins);
hb2 = imhist(img2(:,:,3),nbins);

porcOverR = oz_porcOverlap(hr, hr2);
porcOverG = oz_porcOverlap(hg, hg2);
porcOverB = oz_porcOverlap(hb, hb2);

avgOverlap = (porcOverR + porcOverG + porcOverB)/3;
