function centroids_st = fe_region_growth(arr_in_img)
    %% pad and get constants
    % load all constants
    load('fe_constants_region_growth.mat');
    % put a padding of zeroes all around
    arr_out_img = padarray(arr_in_img, [1, 1], 0, 'both');
    % get the x and y sizes respectively for iterating across the image
    arr_shape = size(arr_out_img);
    x_size = arr_shape(1);
    y_size = arr_shape(2);
    
    %% initialization to zeroes
    % creating table that will contain the centroid data sums
    x_sum = zeros(MAX_STARS, 1);
    y_sum = zeros(MAX_STARS, 1);
    pixel_sum = zeros(MAX_STARS, 1);
    num_pixels = zeros(MAX_STARS, 1);
    centroid_data_st = table(x_sum, y_sum, pixel_sum, num_pixels);
    
    %% iterating through image
    star_num = 1; % counter for star number
    for i_region_growth = 2 : SKIP_PIXELS : x_size - 1
        for j_region_growth = 2 : SKIP_PIXELS : y_size-1
            if arr_out_img(i_region_growth, j_region_growth) > THRESHOLD 
                [arr_out_img, centroid_data_st] = fe_get_data(arr_out_img, i_region_growth, j_region_growth, star_num, centroid_data_st);
                star_num  = star_num + 1;
            end
        end
    end
    
    %% getting the final required data
    mask = (centroid_data_st{:, 'num_pixels'} <= STAR_MIN_PIXEL) | (centroid_data_st{:, 'num_pixels'} > STAR_MAX_PIXEL);
    centroid_data_st(mask, :) = [];
    c_x_cen = -1*(centroid_data_st{:, 'x_sum'}./centroid_data_st{:, 'pixel_sum'} - ((x_size - 2)/2 + 0.5));
    c_y_cen = centroid_data_st{:, 'y_sum'}./centroid_data_st{:, 'pixel_sum'} - ((y_size - 2)/2 + 0.5);
    c_stars = size(c_x_cen, 1);
    centroids_st = [reshape(1:c_stars, c_stars, 1), c_y_cen, c_x_cen];
    
end
