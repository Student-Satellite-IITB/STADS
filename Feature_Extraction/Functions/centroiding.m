function [arr_centroids] = centroiding(img_path)
    arr_img = rgb2gray(imread(img_path));
    [arr_sums_x, arr_sums_y, arr_weights, arr_num, arr_final_tags, tag_num, final_tag_num] = tag_2(arr_img);
    [arr_star_coordinates, num_stars] = merge_tag_3(arr_sums_x, arr_sums_y, arr_weights, arr_num, arr_final_tags, tag_num, final_tag_num);
    arr_centroids = zeros(num_stars, 3);
    arr_centroids(:, 1) = 1:num_stars;
    arr_centroids(:, 2:3) = arr_star_coordinates;
end