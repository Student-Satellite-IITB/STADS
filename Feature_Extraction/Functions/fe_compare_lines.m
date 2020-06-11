function [arr_region_data, bool_merge_regions, num_merge_regions, arr_merge_regions] = fe_compare_lines(arr_line_prev, arr_line, num_prev, num_line)
% input: 
% arr_line_prev: 
%       array containing start, end and tag of each range in the
%       previous row
% -arr_line:
%       the first column is weighted sum of x values, the second is sum of
%       weights, the third is number of pixels, the fourth and fifth are the
%       start and end pixels for each range
% -num_prev:
%       the number of ranges in the previous line
% -num_line
%       the number of ranges in the current line
% returns:
% -arr_region_data: 
%       the first column is the region tag, the second column
%       is the weighted sum of x values, the third is the sum of weights and the
%       fourth is the number of pixels for each region tag
% -bool_merge_regions:
%       boolean for whether there are regions to be merged
% -arr_merge_regions:
%       array containing region tags in the final array to be merged, with
%       each row containing tags corresponding to a connected region
% -num_merge_regions:
%       number of nonempty rows in arr_merge_regions

    load("constants_feature_extraction_3.mat", "NUM_REGIONS_LINE", "NUM_MERGE_LINE", "NUM_TAGS_MERGE");
    counter_int = 1;
    bool_merge_regions = false;
    num_merge_regions = 0;
    arr_region_data = zeros(NUM_REGIONS_LINE, 4);
    arr_merge_regions = zeros(NUM_MERGE_LINE, NUM_TAGS_MERGE);
    for i = 1:num_line
        [start_range, end_range] = arr_line(i, 4:5);
        for counter_int = counter_int:num_prev
            [start_prev, end_prev] = arr_line_prev(counter_int, 2:3);
            if fe_compare_ranges(start_range, end_range, start_prev, end_prev)
                tag_prev = arr_line_prev(counter_int, 1);
            end
        end
    end
end