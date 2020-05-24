function centroids = fe_region_growth(arr_in_img)
    %% pad and get constants
    % put a padding of zeroes all around
    arr_out_img = padarray(arr_in_img, [1, 1], 0, 'both');
    % get the x and y sizes respectively for iterating across the image
    arr_shape = size(arr_out_img);
    x_size = arr_shape(1);
    y_size = arr_shape(2);
    % number of pixels to be skipped
    n = 3;
    
    %% initialization to zeroes
    % creating table that will contain the centroid data sums
    x_sum = zeros(50, 1);
    y_sum = zeros(50, 1);
    pixel_sum = zeros(50, 1);
    num_pixels = zeros(50, 1);
    centroid_data = table(x_sum, y_sum, pixel_sum, num_pixels);
    
    %% iterating through image
    star_num = 1; % counter for star number
    for i = 2 : n : x_size - 1
        for j = 2 : n : y_size-1
            if arr_out_img(i, j) > 9 % arbitrary threshold for now
                [arr_out_img, centroid_data] = fe_get_data(arr_out_img, i, j, star_num, centroid_data);
                star_num  = star_num + 1;
            end
        end
    end
    
    %% getting the final required data
    x_cen = centroid_data{1:star_num-1, 'x_sum'}./centroid_data{1:star_num-1, 'pixel_sum'};
    y_cen = centroid_data{1:star_num-1, 'y_sum'}./centroid_data{1:star_num-1, 'pixel_sum'};
    centroids = [x_cen, y_cen];
    
end
