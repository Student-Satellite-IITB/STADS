function [arr_sums, arr_merge] = tag(arr_in_img)
    load('constants_feature_extraction.mat', NUM_MERGE, NUM_REGIONS, THRESHOLD);    % Loading constants
    [length,breadth] = size(arr_in_img);    % setting the size of the array
    arr_out_img = zeros(length+1, breadth+1, 2);    % adding a layer of zeros to the left and top to account for edge cases and another component for tags
    arr_out_img(2:length+1, 2:breadth+1, 1) = arr_in_img;   % setting the first component at every pixel as the reading, thus making two layers for the image, one for the image and one for tags
    tag_num = 1;    % counter for generating new tags
    merge_num = 1;  % counter to add elements to the merge array
    arr_sums = zeros(NUM_REGIONS,3);    % initialising the sums array. sum of x coordinates in the first coloumn, sum of y coordinates in the second and number of pixels in the third
    arr_merge = zeros(NUM_MERGE, 2);    % initialising the merge array. smaller tag to be merged in the first coloumn, larger one in the second
    for i_tag = 2:length+1  % looping over the rows of the input image
        for j_tag = 2:breadth+1 % looping over the elements of each row
            if arr_out_img(i_tag, j_tag, 1) > THRESHOLD    % if the pixel is bright,
                left = arr_out_img(i_tag-1, j_tag, 1);  % set the value of the pixel to the left as left
                above = arr_out_img(i_tag, j_tag-1, 1);  % set the value of the pixel to the right as right
                if left > THRESHOLD
                    if above >THRESHOLD
                        if arr_out_img(i_tag-1, j_tag, 2) == arr_out_img(i_tag, j_tag-1, 2) % if both left and right are bright, and they have the same tag
                            tag = arr_out_img(i_tag, j_tag-1, 2);   % set the common tag as "tag"
                            arr_out_img(i_tag, j_tag, 2) = tag; % tag the current pixel with the common tag
                            arr_sums(tag) = arr_sums(tag, :) + [i_tag, j_tag, 1];   % add the location and the weight to the  sums array
                        else  % if both left and right are bright, and they have different tags
                            tag_left = arr_out_img(i_tag-1, j_tag, 2);  % set the tag of the left pixel as "tag_left"
                            tag_above = arr_out_img(i_tag, j_tag-1, 2); % set the tag of pixel above as "tag_above"
                            arr_merge(merge_num, :) = [min(tag_left, tag_above), max(tag_left, tag_above)]; % add both to the merge array, smaller one first at merge counter
                            merge_num = merge_num +1;   % increment merge counter
                            arr_out_img(i_tag, j_tag, 2) = tag_above;    % tag current pixel with tag of pixel above
                            arr_sums(tag_above) = arr_sums(tag_above) + [i_tag, j_tag, 1];    % add the coordinates to the corresponding element in the sums array
                        end
                    else % if the pixel to the left is bright, but the one above isn't
                        tag = arr_out_img(i_tag-1, j_tag, 2);   % set "tag" as the tag of the pixel to the left
                        arr_out_img(i_tag, j_tag, 2) = tag; % set the tag of the current pixel as "tag"
                        arr_sums(tag, :) = arr_sums(tag, :) + [i_tag, j_tag, 1];    % add the coordinates and weight to the sums array
                    end
                else
                    if above >THRESHOLD   % if the pixel above is bright and the one to the left isn't
                        tag = arr_out_img(i_tag, j_tag+1, 2);   % set "tag" as the tag of the pixel above
                        arr_out_img(i_tag, j_tag, 2) = tag; % set the tag of the current pixel as "tag"
                        arr_sums(tag, :) = arr_sums(tag, :) + [i_tag, j_tag, 1];    % add the coordinates and weight to the sums array
                    else    % if both the pixel above and the pixel to the left are not bright enough
                        if arr_out_img(i_tag +1, j_tag, 1) >THRESHOLD && arr_out_img(i_tag+1, j_tag-1, 1) >THRESHOLD    % if both the pixel to the right and the pixel above that are bright
                            tag = arr_out_img(i_tag+1, j_tag-1, 2);     % set "tag" as the tag of the pixel to the right and above
                            arr_out_img(i_tag, j_tag, 2) = tag; % tag the current pixel with "tag"
                            arr_sums(tag, :) = arr_sums(tag, :) + [i_tag, j_tag, 1];    % update the corresponding entry in the sums array
                        else
                            arr_out_img(i_tag, j_tag, 2) = tag_num; % tag the current pixel with the tag counter
                            arr_sums(tag_num) = arr_sums(tag_num, :) + [i_tag, j_tag, 1];  % add the coordinates and the weight to the corresponding element of the sums array
                            tag_num = tag_num +1;   % increment the tag counter
                        end
                    end
                end
            end
        end
    end
