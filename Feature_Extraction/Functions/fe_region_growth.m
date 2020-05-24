function centroids = fe_region_growth(filename)
    % read the file containing image
    orig_img = readmatrix(filename);
    % put a padding of zeroes all around
    img = padarray(orig_img, [1, 1], 0, 'both');
    % get the x and y sizes respectively for iterating across the image
    shape = size(img);
    x_size = shape(1);
    y_size = shape(2);
    % number of pixels to be skipped
    n = 3;
    % creating table that will contain the centroid data sums
    x_sum = zeros(50, 1);
    y_sum = zeros(50, 1);
    pixel_sum = zeros(50, 1);
    num_pixels = zeros(50, 1);
    centroid_data = table(x_sum, y_sum, pixel_sum, num_pixels);
    % keeping track of the star number
    star_num = 1;
    for i = 2 : n : x_size - 1
        for j = 2 : n : y_size-1
            if img(i, j) > 9 % arbitrary threshold for now
                [img, centroid_data] = fe_get_data(img, i, j, star_num, centroid_data);
                star_num  = star_num + 1;
            end
        end
    end

    x_cen = centroid_data{1:star_num-1, 'x_sum'}./centroid_data{1:star_num-1, 'pixel_sum'};
    y_cen = centroid_data{1:star_num-1, 'y_sum'}./centroid_data{1:star_num-1, 'pixel_sum'};
    centroids = [x_cen, y_cen];
end
