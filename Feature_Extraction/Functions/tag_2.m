function [arr_sums_x, arr_sums_y, arr_weights, arr_num, arr_flags, tag_num, final_tag_num] = tag_2(arr_in_img)
    load('constants_feature_extraction_2.mat', "THRESHOLD", "NUM_FINAL_TAGS", "NUM_TAGS_PER_REGION", "NUM_REGIONS");    % Loading constants
    [rows,columns] = size(arr_in_img);    % setting the size of the array
    arr_out_img = zeros(rows+1, columns+2, 2, 'int32');    % adding a layer of zeros to the i_left and top to account for edge cases and another component for tags
    arr_out_img(2:rows+1, 2:columns+1, 1) = arr_in_img;   % setting the first component at every pixel as the reading, thus making two layers for the image, one for the image and one for tags
    tag_num = 1;    % counter for generating new tags
    final_tag_num = 1;      % counter for adding elements to the final tag array
    arr_sums = zeros(NUM_REGIONS, 5, 'int32');   % initialising the array contsining sums
    arr_final_tags = zeros(NUM_FINAL_TAGS, NUM_TAGS_PER_REGION, 'int32');    % initialising the array containing final tags and tags associated with them
    % looping over the input image
    for j_tag = 2:rows+1
        for i_tag = 2:columns+1
            intensity = arr_out_img(j_tag, i_tag, 1);   % "intensity" is the value stored at [j_tag, i_tag]
                if intensity > THRESHOLD    % if the pixel is bright,
                        i_left = arr_out_img(j_tag, i_tag-1, 1);  % set the value of the pixel to the i_left as i_left
                        i_above = arr_out_img(j_tag-1, i_tag, 1);  % set the value of the pixel to above as i_above
                        if i_left>THRESHOLD     % if the pixel to the left is bright
                            tag_left = arr_out_img(j_tag, i_tag-1, 2);  % set "tag_left" as the tag of the pixel to the left
                            if i_above>THRESHOLD    % if the pixel above is also bright
                                tag_above = arr_out_img(j_tag-1, i_tag, 2);     % set "tag_above" as the tag of the pixel above
                                if tag_above == tag_left % if both i_left and right are bright, and they have the same tag
                                    tag = tag_above;   % set the common tag as "tag"
                                    arr_out_img(j_tag, i_tag, 2) = tag; % tag the current pixel with the common tag
                                    arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_tag, intensity*j_tag, intensity, 1, 0];  % update values in arr_sums
                                else    % if both the pixel above and to the left are bright, and have different tags
                                    if arr_sums(tag_above, 5) >0    % if tag of the pixel above is associated with a nonzero final tag
                                        final_tag_above = arr_sums(tag_above, 5);   % set "final_tag_above" as the final tag of that region
                                        if arr_sums(tag_left, 5) >0     % if the tag of the pixel to the left is also associated with a nonzero final tag
                                            final_tag_left = arr_sums(tag_left, 5);     % set "final_tag_left" as the final tag of the region to which the pixel to the left belongs
                                            if final_tag_above == final_tag_left    % if the two final tags are equal
                                                tag = tag_above;    % set "tag" as the tag of the pixel above
                                                arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_tag, intensity*j_tag, intensity, 1, 0];  % update values corresponding to "tag"
                                                arr_out_img(j_tag, i_tag, 2) = tag; % tag the pixel with the tag of the tag above
                                            else    % if the tags of the pixel above and the pixel to the left are associated with different final tags,
                                                tag = tag_above;    % set "tag" as the tag of the pixel above
                                                arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_tag, intensity*j_tag, intensity, 1, 0]; % update values corresponding to "tag"
                                                arr_out_img(j_tag, i_tag, 2) = tag; % tag the current pixel with "tag"
                                                larger_final_tag = max(final_tag_above, final_tag_left);    % set values of the larger and smaller final tags
                                                smaller_final_tag = min(final_tag_above, final_tag_left);
                                                num_iterations = arr_final_tags(larger_final_tag, 1);   % the number of additions and removals from rows corresponding to the smaller and larger final tags is equal to number of tags associated with the larger final tag
                                                num_skip = arr_final_tags(smaller_final_tag, 1);   % number of elements to skip in the row associated with the smaller final tag
                                                % add each of the elements of the row of the larger final tag to the row of the smaller final tag 
                                                % make all the elements moved zero
                                                % change the final tag of all the tags moved
                                                for i_final_tag_change  = 1:num_iterations
                                                    arr_final_tags(smaller_final_tag, num_skip + 1 + i_final_tag_change) = arr_final_tags(larger_final_tag, i_final_tag_change+1);
                                                    arr_sums(arr_final_tags(larger_final_tag, i_final_tag_change), 5) = smaller_final_tag;
                                                    arr_final_tags(larger_final_tag, i_final_tag_change + 1) = 0;
                                                end
                                                arr_final_tags(larger_final_tag, 1) = 0;    % make the number of tags associated with the larger final tag zero
                                                arr_final_tags(smaller_final_tag, 1) = num_skip + num_iterations;   % update the number of tags assocciated with the smaler final tag
                                            end
                                        else    % if the final tag of the tag associated with the pixel to the left is zero, but that associated with the one above isn't
                                            tag = tag_above;    % set "tag" as the tag of the pixel above
                                            arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_tag, intensity*j_tag, intensity, 1, 0];  % update the row corresponding to "tag"
                                            arr_out_img(j_tag, i_tag, 2) = tag; % tag the current pixel with tag
                                            final_tag = arr_sums(tag_above, 5); % set final_tag as the final tag of the region that the pixelabove is in
                                            arr_final_tags(final_tag, arr_final_tags(final_tag, 1)+2) = tag;    % add tag to the row of final_tag
                                            arr_sums(tag_left, 5) = final_tag;   % set the final tag of the tag of the pixel to the left as final_tag
                                            arr_final_tags(final_tag, 1) = arr_final_tags(final_tag, 1) + 1;    % update the number of tags in the row corresponding to final_tag in arr_final_tag
                                        end
                                    else    % if the final tag of the tag of the pixel above is zero
                                        if arr_sums(tag_left, 5) >0     % if the final tag of the tag of the pixel to the left is nonzero
                                            tag = tag_above;    % set tag as the tag of the pixel above
                                            arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_tag, intensity*j_tag, intensity, 1, 0];  % update the row corresponding to "tag"
                                            arr_out_img(j_tag, i_tag, 2) = tag; % tag the current pixel with tag
                                            final_tag = arr_sums(tag_left, 5);  % set final_tag as the final tag of the tag of the pixel to the left
                                            arr_final_tags(final_tag, arr_final_tags(final_tag, 1) + 2) = tag;  % add tag to the row corresponding to final_tag in arr_final_tag
                                            arr_sums(tag_above, 5) = final_tag; % set final-tag as the final tag of the tag of the pixel above
                                            arr_final_tags(final_tag, 1) = arr_final_tags(final_tag, 1) + 1;    % increase the counter of tags assocoated with final_tag
                                        else    % if the final tags of both tag_left and tag_above are zero
                                            tag = tag_above;    
                                            arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_tag, intensity*j_tag, intensity, 1, 0];  % update the row corresponding to "tag"
                                            arr_out_img(j_tag, i_tag, 2) = tag; % tag the current pixel with tag
                                            arr_final_tags(final_tag_num, 1) = 2;   % set the number of tags associated with final_tag_num as 2
                                            arr_final_tags(final_tag_num, 2:3) = [tag_above, tag_left];     % set the second and third element of the row corresponding to final_tag_num as tag_above and tag_left
                                            arr_sums(tag_above, 5) = final_tag_num; % set the final tag of tag_above as final_tag_num
                                            arr_sums(tag_left, 5) = final_tag_num;  % set the tag of tag_left as final_tag_num
                                            final_tag_num = final_tag_num+1;    % increment final_tag_num
                                        end
                                    end
                                end
                            else % if the pixel above is dim but the pixel to the left is bright
                                tag = tag_left;
                                arr_out_img(j_tag, i_tag, 2) = tag; % tag the current pixel with tag
                                arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_tag, intensity*j_tag, intensity, 1, 0];  % update the corresponnding row in arr_sums
                            end
                        else
                            if i_above > THRESHOLD  % if the pixel above is bright is bright but the pixel to the left is dim
                                tag_above = arr_out_img(j_tag-1, i_tag, 2);
                                tag = tag_above;
                                arr_out_img(j_tag, i_tag, 2) = tag; % tag the current pixel with tag
                                arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_tag, intensity*j_tag, intensity, 1, 0];  % update the corresponding row in arr_sums
                            else    % if both the pixel above and to the left are dim
                                if arr_out_img(j_tag, i_tag+1, 1)>THRESHOLD && arr_out_img(j_tag-1, i_tag+1, 1)>THRESHOLD   % if the pixel to the right and the one to the right and above are bright
                                    tag = arr_out_img(j_tag-1, i_tag+1, 2);
                                    arr_out_img(j_tag, i_tag, 2) = tag;     % tag the current pixel with tag
                                    arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_tag, intensity*j_tag, intensity, 1, 0];  % update the corresponding row in arr_sums
                                else
                                arr_sums(tag_num, :) = [intensity*i_tag, intensity*j_tag, intensity, 1, 0];     % set the row corresponding to tag_num as the parameters of the current pixel
                                arr_out_img(j_tag, i_tag, 2) = tag_num; % tag the current pixel with tag_num
                                tag_num = tag_num +1;   % increment tag_num
                                end
                            end
                        end
                end
        end
    end
    arr_sums_x = arr_sums(:, 1);
    arr_sums_y  = arr_sums(:, 2);
    arr_weights = arr_sums(:, 3);
    arr_num = arr_sums(:, 4);
    arr_flags = arr_sums(:, 5);
end