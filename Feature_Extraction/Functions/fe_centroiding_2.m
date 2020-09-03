function [arr_centroids] = fe_centroiding_2(sis_output, fe_const)
    % reading in the image, converting it to grayscale
    % arr_img = rgb2gray(imread(img_path));
    % getting interediate output from tag_2 and merge_tag_3
    % load('constants_feature_extraction_2.mat', "PIXEL_WIDTH");    % Loading constants
    PIXEL_WIDTH = fe_const.PIXEL_WIDTH;
    arr_img = sis_output.image;
    [arr_sums_x, arr_sums_y, arr_weights, arr_num, arr_final_tags, tag_num, final_tag_num] = fe_tag_2(arr_img);
    [arr_star_coordinates, num_stars] = fe_merge_tag(arr_sums_x, arr_sums_y, arr_weights, arr_num, arr_final_tags, tag_num, final_tag_num);
    % adding star ids and formatting the output
    arr_centroids = zeros(num_stars, 3);
    arr_centroids(:, 1) = 1:num_stars;
    arr_centroids(:, 2:3) = arr_star_coordinates(1:num_stars, :) * PIXEL_WIDTH;
end
