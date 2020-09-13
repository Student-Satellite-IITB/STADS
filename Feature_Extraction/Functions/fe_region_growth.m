function centroids_st = fe_region_growth(sis_output, FE_const)
    %% pad and get constants
    % load all constants
    % load('fe_constants_region_growth.mat');
    % put a padding of zeroes all around
    arr_in_img = sis_output.image;
    MAX_STARS = FE_const.MAX_STARS;
    SKIP_PIXELS = FE_const.SKIP_PIXELS;
    PIXEL_WIDTH = FE_const.PIXEL_WIDTH;
    STAR_MIN_PIXEL = FE_const.STAR_MIN_PIXEL;
    STAR_MAX_PIXEL = FE_const.STAR_MAX_PIXEL;
    THRESHOLD = FE_const.THRESHOLD;
    
    % SKIP_PIXELS,THRESHOLD,STAR_MIN_PIXEL,STAR_MAX_PIXEL
    % arr_out_img = padarray(arr_in_img, [1, 1], 0, 'both');% SEtD A CODE
    % SNIPPET TO CORRECT THIS,WHICH IS AS FOLLOWS:
    % put a padding of zeroes all around
    arr_out_img = zeros(1024+2, 1280+2, 2, 'int32');
    arr_out_img(2:1024+1, 2:1280+1, 1) = arr_in_img;
    % get the x and y sizes respectively for iterating across the image
    arr_shape = size(arr_out_img);
    y_size = arr_shape(1);
    x_size = arr_shape(2);

    %% initialization to zeroes
    % creating a matrix that will contain the centroid data sums
    % order of columns is [x_sum, y_sum, pixel_sum, num_pixels]
    centroid_data_st = zeros(MAX_STARS, 4);

    %% iterating through image
    star_num = 1; % counter for star number
    for j_region_growth = 2 : SKIP_PIXELS : y_size - 1
        for i_region_growth = 2 : SKIP_PIXELS : x_size-1
            if arr_out_img(j_region_growth, i_region_growth) > THRESHOLD
                [arr_out_img, centroid_data_st] = fe_get_data(arr_out_img, i_region_growth, j_region_growth, star_num, centroid_data_st,FE_const);
                star_num  = star_num + 1;
            end
        end
    end

    %% getting the final required data
    mask = (centroid_data_st(:, 4) <= STAR_MIN_PIXEL) | (centroid_data_st(:, 4) > STAR_MAX_PIXEL);
    centroid_data_st(mask, :) = [];
    c_x_cen = centroid_data_st(:, 1)./centroid_data_st(:, 3) - ((x_size - 2)/2 + 0.5);
    c_y_cen = -1*(centroid_data_st(:, 2)./centroid_data_st(:, 3) - ((y_size - 2)/2 + 0.5));
    c_stars = size(c_x_cen, 1);
    c_x_cen = c_x_cen * PIXEL_WIDTH;
    c_y_cen = c_y_cen * PIXEL_WIDTH;
    centroids_st = [reshape(1:c_stars, c_stars, 1), c_x_cen,c_y_cen];

end
