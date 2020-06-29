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

    load("constants_feature_extraction_3.mat", "LENGTH", "NUM_REGIONS", "NUM_RANGES_ROW", "BREADTH");
    arr_centroids = zeros(NUM_REGIONS, 3);
    num_stars = 0;
    arr_centroid_data = zeros(NUM_REGIONS, 5);
    
    [arr_row, num_ranges] = fe_extract_row_data(arr_image(1, :));
    arr_centroid_data(1:num_ranges, 1) = arr_row(1:num_ranges, 1);
    arr_centroid_data(1:num_ranges, 3:4) = arr_row(1:num_ranges, 2:3);
    arr_centroid_data(1:num_ranges, 2) = arr_row(1:num_ranges, 2);
    num_tags = num_ranges;
    arr_merge_regions = 0;
    num_merge_regions = 0;
    
    for i_row = 2:BREADTH
        
    end
end