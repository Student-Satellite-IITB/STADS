I = se_Image_Mat - 5;
Ibw = im2bw(I);
Ibw = imfill(Ibw,'holes');
Ilabel = bwlabel(Ibw);
stat = regionprops(Ilabel,'centroid');
centroids = cat(1,stat.Centroid);
centroids(:, 1) = centroids(:, 1) - 1280 / 2;
centroids(:, 2) = centroids(:, 2) - 1024 / 2;
imshow(I); hold on;
for x = 1: numel(stat)
    plot(stat(x).Centroid(1),stat(x).Centroid(2),'ro');
end