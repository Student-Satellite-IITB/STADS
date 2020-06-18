function [arr_centroids, num_stars] = fe_centroiding_line(arr_image)
%{
input:
-arr_image:
        input image in .mat format
output:
- arr_centroids
        array containing star id in the first column and the corresponding
        centroid coordinates the second and third columns
%}

    load("constants_feature_extraction_3.mat", "LENGTH", "NUM_REGIONS");
    arr_centroids = zeros(NUM_REGIONS, 3);
    num_stars = 0;
    
    
end