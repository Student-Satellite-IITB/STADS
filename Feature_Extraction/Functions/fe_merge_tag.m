%function to output the position of centroids of stars found in an image*/

%{
input consisting of
1. An array of sums of coordinates along x and y
2. An array of weights
3. An array of the count of number of pixels in each tagged region
4. An array of final tags corresponding to each tag
5. Count of number of tags
6. Count of number of final tags
%}

function [arr_star_coordinates, num_stars] = merge_tag_3(arr_sum_x, arr_sum_y, arr_weights, arr_num_pixels, arr_final_tag, num_tags, num_final_tags)
    
    load('constants_feature_extraction_2.mat', "NUM_REGIONS", "MIN_PIXELS", "MAX_PIXELS", "LENGTH", "BREADTH");    %loading constants

    %correcting values
    num_tags = num_tags - 1;
    num_final_tags = num_final_tags - 1;
    
    %an array defined to contain the position of centroids of a star
    arr_star_coordinates = zeros(num_tags, 2);    %(k, 1)=pos_x  (k, 2)=pos_y

    %variable to count number of stars
    num_stars=0;

    %variable to count number of singly tagged stars
    num_single_tag_stars=0;

    %variable to count number of zero rows in arr_sums
    num_zero_rows=0;

    %array of variables to sum the values of different tagged regions of the same star ("summation variables")
    arr_tot_sum_x = zeros(num_final_tags, 1);
    arr_tot_sum_y = zeros(num_final_tags, 1);
    arr_tot_weights = zeros(num_final_tags, 1);
    arr_tot_pixels = zeros(num_final_tags, 1);

    %loop to find position of centroids of stars with single tagged region and update values of summation variables for multi tagged stars
    for i_centroids_single=1:num_tags
        %if region is singly tagged
        if (arr_final_tag(i_centroids_single) == 0)
            %if number of pixels in region is out of range
            if (arr_num_pixels(i_centroids_single) < MIN_PIXELS || arr_num_pixels(i_centroids_single) > MAX_PIXELS)
                continue;   %skip this iteration of loop
            end
            %incrementing number of stars and single tagged stars by 1
            num_single_tag_stars = num_single_tag_stars + 1;
            num_stars = num_stars + 1;
            %updating values of centroid
            arr_star_coordinates(num_final_tags + num_single_tag_stars, 1) = (arr_sum_x(i_centroids_single)/arr_weights(i_centroids_single) - 1) - LENGTH/2;
            arr_star_coordinates(num_final_tags + num_single_tag_stars, 2) = -1*(arr_sum_y(i_centroids_single)/arr_weights(i_centroids_single) - 1) + BREADTH/2;
        %if region has multiple tags
        else
            %update summation variables
            arr_tot_sum_x(arr_final_tag(i_centroids_single)) = arr_tot_sum_x(arr_final_tag(i_centroids_single)) + arr_sum_x(i_centroids_single);
            arr_tot_sum_y(arr_final_tag(i_centroids_single)) = arr_tot_sum_y(arr_final_tag(i_centroids_single)) + arr_sum_y(i_centroids_single);
            arr_tot_weights(arr_final_tag(i_centroids_single)) = arr_tot_weights(arr_final_tag(i_centroids_single)) + arr_weights(i_centroids_single);
            arr_tot_pixels(arr_final_tag(i_centroids_single)) = arr_tot_pixels(arr_final_tag(i_centroids_single)) + arr_num_pixels(i_centroids_single);
        end
    end
    
    %loop to find position of centroids of stars with more than one tagged regions
    for i_centroids_multi=1: num_final_tags
        %if number of pixels in region is within range and with positive weight
        if (arr_tot_pixels(i_centroids_multi) > MIN_PIXELS && arr_tot_pixels(i_centroids_multi) < MAX_PIXELS && arr_tot_weights(i_centroids_multi) > 0)
            %updating values of centroid
            arr_star_coordinates(i_centroids_multi - num_zero_rows, 1) = (arr_tot_sum_x(i_centroids_multi)/arr_tot_weights(i_centroids_multi) - 1) - LENGTH/2;
            arr_star_coordinates(i_centroids_multi - num_zero_rows, 2) = -1*(arr_tot_sum_y(i_centroids_multi)/arr_tot_weights(i_centroids_multi) - 1) + BREADTH/2;
            %incrementing number of stars by 1
            num_stars = num_stars + 1;
        %if number of pixels in region is out of range or with zero weight
        else
            num_zero_rows = num_zero_rows + 1;  %increment number of zero rows by 1
        end
    end
    
    %to remove possible zero rows present between dense rows
    %multi tagged regions have been written sequentially in the array beginning at index 1. Single tagged region have been written sequentially beginning at index <value of num_final_tags>
    %rows of coordinates of single tagged regions are adjusted to a lower index and the final couple of rows are overwritten to zero
    %if the number of zero rows between dense rows is positive
    if (num_zero_rows > 0)
        for i_remove_zero_rows = (num_final_tags - num_zero_rows + 1): num_stars
            arr_star_coordinates(i_remove_zero_rows, 1) = arr_star_coordinates(i_remove_zero_rows + num_zero_rows,1);
            arr_star_coordinates(i_remove_zero_rows, 2) = arr_star_coordinates(i_remove_zero_rows + num_zero_rows,2);
        end
        for i_overwrite_rows = (num_stars + 1): (num_stars + num_zero_rows)
            arr_star_coordinates(i_overwrite_rows, 1) = 0;
            arr_star_coordinates(i_overwrite_rows, 2) = 0;
        end
    end
end

%{
output consisting of
1. centroids of stars (arr_star_coordiantes) in a frame of reference where x+ is rightwards and y+ is upwards centered at the middle of the image
2. number of stars (num_stars)
%}

%end of function
