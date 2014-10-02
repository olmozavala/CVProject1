function hw1_3()
% hw1_3 main 
clear
close all
figure
prcurve(1);
prcurve(2);
prcurve(3);

end

function match=histinter(img1, img2)
%compute the histogram intersection
h1=[imhist(img1(:,:,1));imhist(img1(:,:,2));imhist(img1(:,:,3))];
h2=[imhist(img2(:,:,1));imhist(img2(:,:,2));imhist(img2(:,:,3))];
imhist(img1)
match=sum(min(h1,h2));


end

function prcurve(class)
%compute and plot precision recall curve
clmatch=zeros(30,2);
for j=1:3
for i=0:9
    img1= imread(['hw1\c' num2str(class) '\1.ppm']);
    img2= imread(['hw1\c' num2str(j) '\' num2str(i) '.ppm']);
    match=histinter(img1,img2);
    clmatch(i+1+10*(j-1),1)=match;
    clmatch(i+1+10*(j-1),2)=i+1+10*(j-1);
end
end
[sclmatch, filenum] = sort(-clmatch);
precision_recall=([30,3]);
correct_ones=0;
for i=1:30
    precision_recall(i,1)=i;
    if class==ceil(filenum(i)/10)
        correct_ones=correct_ones+1;
    end
    precision_recall(i,2)=correct_ones/i;
    precision_recall(i,3)=correct_ones/10;
end
precision_recall
subplot(2,3,class); 
plot(precision_recall(:,2),precision_recall(:,3),'-*');
title(['C' num2str(class)]);
axis([0 1 0 1]); 
grid;
end