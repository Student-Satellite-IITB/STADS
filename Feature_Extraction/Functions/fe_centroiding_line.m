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

    load("constants_feature_extraction_3.mat", "LENGTH", "NUM_REGIONS", "NUM_RANGES_ROW", "BREADTH", "STAR_MIN_PIXELS", "STAR_MAX_PIXELS");
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
    arr_regions = 1:num_ranges;
    
    for i_row = 2:BREADTH
        prev_row = fe_line2prev(arr_row, num_ranges, arr_regions, arr_merge_regions, num_merge_regions);
        [arr_row, num_ranges] = fe_extract_row_data(arr_image(i_row, :));
        [arr_region_data, arr_regions, num_tags, num_merge_regions, arr_merge_regions] = fe_compare_lines(prev_row, arr_row, num_prev, num_ranges, num_tags);
        arr_centroid_data = fe_add_centroid_data(arr_centroid_data, arr_region_data, i_row);
        arr_centroid_data = fe_merge_regions(arr_centroid_data, arr_merge_regions, num_merge_regions);
    end
    num_stars = sum(arr_centroid_data(:, 4)>STAR_MIN_PIXELS && arr_centroid_data(4, :)<STAR_MAX_PIXEL);
end