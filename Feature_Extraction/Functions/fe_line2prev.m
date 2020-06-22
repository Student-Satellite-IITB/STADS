function arr_line_prev = fe_line2prev(arr_line, num_line, arr_regions, arr_region_data, arr_merge_regions)
    arr_line_prev = zeros(num_line, 3);
    for i_convert = 1:num_line
        region = arr_regions(i_convert);
        region_flag = arr_region_data(region, 4);
        if region_flag
            region = arr_merge_regions(region_flag, 2);
        end
        arr_line_prev(i_convert, 1) = region;
        arr_line_prev(i_convert, 2:3) = arr_line(i_convert, 4:5);
    end
end