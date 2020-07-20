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


    % loading constants and initializing arrays for data and output
    load("constants_feature_extraction_3.mat", "LENGTH", "NUM_REGIONS", "NUM_RANGES_ROW", "BREADTH", "STAR_MIN_PIXELS", "STAR_MAX_PIXELS");
    arr_centroids = zeros(NUM_REGIONS, 3);
    arr_centroid_data = zeros(NUM_REGIONS, 4);
    
    % parsing the first row and tagging all ranges separately
    [arr_row, num_ranges] = fe_extract_row_data(arr_image(1, :));
    arr_centroid_data(1:num_ranges, 1) = arr_row(1:num_ranges, 1);
    arr_centroid_data(1:num_ranges, 3:4) = arr_row(1:num_ranges, 2:3);
    arr_centroid_data(1:num_ranges, 2) = arr_row(1:num_ranges, 2);
    num_tags = num_ranges;
    arr_regions = 1:num_ranges;
    
    % initializing counters and auxiliary arrays
    arr_merge_regions = 0;
    num_merge_regions = 0;
    
    
    for i_row = 2:BREADTH
        
        % converting the data from the previous row to the correct format
        % and merging tags in the current row
        prev_row = fe_line2prev(arr_row, num_ranges, arr_regions, arr_merge_regions, num_merge_regions);
        
        % getting data from the new row
        [arr_row, num_ranges] = fe_extract_row_data(arr_image(i_row, :));
        
        % comparing the new row and the previous row, getting the data to
        % be added, the tags to be merged, tags for the ranges in the
        % current row and related data
        [arr_region_data, arr_regions, num_tags, num_merge_regions, arr_merge_regions] = fe_compare_lines(prev_row, arr_row, num_prev, num_ranges, num_tags);
        
        % adding the data to the accumulating table
        arr_centroid_data = fe_add_centroid_data(arr_centroid_data, arr_region_data, i_row);
        
        % merging the tags in the accumulating table
        arr_centroid_data = fe_merge_regions(arr_centroid_data, arr_merge_regions, num_merge_regions);
    end
    
    % finding the centroids and the number of stars for regions that
    % satisfy the criteria
    num_stars = 0;
    for i_centroid =  1:num_tags
        if arr_centroid_data(i_centroid, 4) > STAR_MIN_PIXELS && arr_centroid_data(i_centroid, 4) < STAR_MAX_PIXELS
            num_stars = num_stars+1;
            arr_centroids(num_stars, 2:3) = arr_centroid_data(i_centroid, 1:2)/arr_centroid_data(i_centroid, 3);
        end
    end
    
    % adding star IDs
    arr_centroids(:, 1) = 1:num_stars;
end