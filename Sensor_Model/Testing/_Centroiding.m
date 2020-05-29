I = se_Image_Mat;
Ibw = im2bw(I);
Ibw = imfill(Ibw,'holes');
Ilabel = bwlabel(Ibw);
stat = regionprops(Ilabel,'centroid');
imshow(I); hold on;
for x = 1: numel(stat)
    plot(stat(x).Centroid(1),stat(x).Centroid(2),'ro');
end