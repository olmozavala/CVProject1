clf
clear
close all

%histograms
h=waitbar(0,'Creating histograms');
hists=zeros([1000,768]);
tic;
for i=0:999
    waitbar(i/1000);
    fname=sprintf('corel/%i.jpg',i);
    clear im
    im=double(imread(fname,'jpg'));
    [h_im_r]=hist(reshape(im(:,:,1),[1 size(im,1)*size(im,2)]),256);
    [h_im_g]=hist(reshape(im(:,:,2),[1 size(im,1)*size(im,2)]),256);
    [h_im_b]=hist(reshape(im(:,:,3),[1 size(im,1)*size(im,2)]),256);
    hists(i+1,:)=[h_im_r h_im_g h_im_b];
end
toc;

%histogram intersections
close(h);h=waitbar(0,'Calculating histogram distances');
dists=zeros([1000,1000]);
tic;
for i=1:1000
    waitbar(i/1000);
    for j=1:1000
    dists(i,j)=sum(min(hists(i,:),hists(j,:)));
    end
end
toc;
[Y, ind] = sort(-dists);

%precision recall[query image, all images, PR]
%every image is queried against all 1000 images
close(h);h=waitbar(0,'Calculating precision recall');
precision_recall=zeros([1000,1000,3]);

for j=1:1000
    waitbar(j/1000);
    correct_ones = 0;
    for i=1:1000
        precision_recall(j,i,1)=i;
        curr_c=ceil(ind(i,j)/100);
        if curr_c == ceil(j/100),
            correct_ones = correct_ones+1;
        end
    precision_recall(j,i,2) = correct_ones/i;
    precision_recall(j,i,3) = correct_ones/100;
    end
end
close(h)

%plot curve for image x
x=401;
plot(precision_recall(x,:,2),precision_recall(x,:,3));
xlabel('Precision');
ylabel('Recall');
set(gcf,'Color',[1 1 1]);
