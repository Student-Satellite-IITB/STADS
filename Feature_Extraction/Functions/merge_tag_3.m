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

function [arr_star_coordinates, num_stars] = merge_tag_5(sum_x, sum_y, weights, num_pixels, final_tag, num_tags, num_final_tags)
    
    load('constants_feature_extraction_2.mat', "NUM_REGIONS", "MIN_PIXELS", "MAX_PIXELS", "LENGTH", "BREADTH");    %loading constants

    %correcting values
    num_tags = num_tags - 1;
    num_final_tags = num_final_tags - 1;
    
    %an array defined to contain the position of centroids of a star
    arr_star_coordinates = zeros(NUM_REGIONS,2);    %(k,1)=pos_x  (k,2)=pos_y

    %variable to count number of stars
    num_stars=0;

    %variable to count number of singly tagged stars
    num_single_tag_stars=0;

    %variable to count number of zero rows in arr_sums
    num_zero_rows=0;

    %array of variables to sum the values of different tagged regions of the same star ("summation variables")
    tot_sum_x = zeros(num_final_tags,1);
    tot_sum_y = zeros(num_final_tags,1);
    tot_weights = zeros(num_final_tags,1);
    tot_pixels = zeros(num_final_tags,1);

    %loop to find position of centroids of stars with single tagged region and update values of summation variables for multi tagged stars
    for I=1:num_tags
        %if region is singly tagged
        if (final_tag(I) == 0)
            %if number of pixels in region is out of range
            if (num_pixels(I) < MIN_PIXELS || num_pixels(I) > MAX_PIXELS)
                continue;   %skip this iteration of loop
            end
            %incrementing number of stars and single tagged stars by 1
            num_single_tag_stars = num_single_tag_stars + 1;
            num_stars = num_stars + 1;
            %updating values of centroid
            arr_star_coordinates(num_final_tags + num_single_tag_stars,1) = (sum_x(I)/weights(I) - 1) - LENGTH/2;
            arr_star_coordinates(num_final_tags + num_single_tag_stars,2) = -1*(sum_y(I)/weights(I) - 1) + BREADTH/2;
        %if region has multiple tags
        else
            %update summation variables
            tot_sum_x(final_tag(I)) = tot_sum_x(final_tag(I)) + sum_x(I);
            tot_sum_y(final_tag(I)) = tot_sum_y(final_tag(I)) + sum_y(I);
            tot_weights(final_tag(I)) = tot_weights(final_tag(I)) + weights(I);
            tot_pixels(final_tag(I)) = tot_pixels(final_tag(I)) + num_pixels(I);
        end
    end
    
    %loop to find position of centroids of stars with more than one tagged regions
    for I=1: num_final_tags
        %if number of pixels in region is within range and with positive weight
        if (tot_pixels(I) > MIN_PIXELS && tot_pixels(I) < MAX_PIXELS && tot_weights(I) > 0)
            %updating values of centroid
            arr_star_coordinates(I - num_zero_rows,1) = (tot_sum_x(I)/tot_weights(I) - 1) - LENGTH/2;
            arr_star_coordinates(I - num_zero_rows,2) = -1*(tot_sum_y(I)/tot_weights(I) - 1) + BREADTH/2;
            %incrementing number of stars by 1
            num_stars = num_stars + 1;
        %if number of pixels in region is out of range or with zero weight
        else
            num_zero_rows = num_zero_rows + 1;  %increment number of zero rows by 1
        end
    end
    
    %to remove possible zero rows present between dense rows
    %if the number of zero rows between dense rows is positive
    if (num_zero_rows > 0)
        for I = (num_final_tags - num_zero_rows + 1): num_stars
            arr_star_coordinates(I,1) = arr_star_coordinates(I + num_zero_rows,1);
            arr_star_coordinates(I,2) = arr_star_coordinates(I + num_zero_rows,2);
        end
        for I = (num_stars + 1): (num_stars + num_zero_rows)
            arr_star_coordinates(I,1) = 0;
            arr_star_coordinates(I,2) = 0;
        end
    end
end

%{
output consisting of
1. centroids of stars (arr_star_coordiantes)
2. number of stars (num_stars)
%}

%end of function
