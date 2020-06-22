function arr_centroids = fe_merge_regions(arr_centroids, arr_merge_regions, num_merge_regions)
    if num_merge_regions>0
        for i_merge = 1:num_merge_regions
            if arr_merge_regions(i_merge, 1) > 0
                merge_row_to = arr_merge_regions(i_merge, 2);
                for i_merge_row = 3:arr_merge_regions(i_merge, 1) + 1
                    arr_centroids(merge_row_to, :) = arr_centroids(merge_row_to, :) + arr_centroids(arr_merge_regions(i_merge, i_merge_row), :);
                end
            end
        end
    end
end