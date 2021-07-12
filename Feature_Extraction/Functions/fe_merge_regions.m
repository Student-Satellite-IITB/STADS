function arr_centroids = fe_merge_regions(arr_centroids, arr_merge_regions, num_merge_regions)
%{
input:
-arr_centroids:
    array cnontaining data corresponding to tagged regions
-arr_merge_regions:
    array containing the regions to be merged
-num_merge_regions:
    number of rows containing merge data in arr_merge_regions
%}
    load("constants_feature_extraction_3.mat", "NUM_MERGE_LINE")
    
    
    for i_merge = 1:NUM_MERGE_LINE
        
        % if there are no regions to be merged, exit
        if num_merge_regions == 0
            break
        else
            % if the ith row is nonempty, merge the latter rows to the one
            % mentioned first, and put zeros in the rows that were merged
            if arr_merge_regions(i_merge, 1) > 0
                merge_row_to = arr_merge_regions(i_merge, 2);
                num_merge_regions = num_merge_regions-1;
                for i_merge_row = 3:arr_merge_regions(i_merge, 1) + 1
                    merge_row_from = arr_merge_regions(i_merge, i_merge_row);
                    arr_centroids(merge_row_to, :) = arr_centroids(merge_row_to, :) + arr_centroids(merge_row_from, :);
                    arr_centroids(merge_row_from, :) = zeros(1, 4);
                end
            end
        end
    end
end