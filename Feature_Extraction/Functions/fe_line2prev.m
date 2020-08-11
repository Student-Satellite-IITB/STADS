function [num_prev, arr_line_prev] = fe_line2prev(arr_line, num_line, arr_regions, arr_region_flags, arr_merge_regions)
%{
input:
-arr_line:
    array containing data (corresponding to the current row)
    to be converted to the previous row data format
-num_line:
    number of rows in arr_line
-arr_regions:
    array containing the region corresponding to each row in arr_line
-arr_region_flags:
    array containing flags corresponding to each region, 0 if they have
    none
-arr_merge_regions:
    array containing the merge information for the regions with flags

output:
-arr_line_prev:
    array containing the data of the row in the required format
%}

    arr_line_prev = zeros(num_line, 3);
    if num_line>0
        for i_convert = 1:num_line
            if size(arr_merge_regions,1)>0
                if arr_region_flags(i_convert)
                    region = arr_regions(i_convert);
                    region_flag = arr_region_flags(region);
                end
            end
            % if the region is to be merged, change the tag to the one it is to
            % be merged into
            if region_flag
                region = arr_merge_regions(region_flag, 2);
            end

            % add tags and start and end values to the final array
            arr_line_prev(i_convert, 1) = region;
            arr_line_prev(i_convert, 2:3) = arr_line(i_convert, 4:5);
        end
        num_prev = num_line;
    else
        num_prev = 0;
        arr_line_prev = [];
    end
end