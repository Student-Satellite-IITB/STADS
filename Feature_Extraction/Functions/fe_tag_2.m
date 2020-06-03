function [arr_sums_x, arr_sums_y, arr_weights, arr_num, arr_flags, tag_num, final_tag_num] = fe_tag_2(arr_in_img)
    load('constants_feature_extraction_2.mat', "THRESHOLD", "NUM_FINAL_TAGS", "NUM_TAGS_PER_REGION", "NUM_REGIONS");    % Loading constants
    [rows,columns] = size(arr_in_img);
    
    % setting the "output" array with two layers, one for the tag, one for the oriiginal image, padding it to the left, right and top
    arr_out_img = zeros(rows+1, columns+2, 2, 'int32');
    arr_out_img(2:rows+1, 2:columns+1, 1) = arr_in_img;
    
    % initialising counters
    tag_num = 1;
    final_tag_num = 1;
    
    % initialising the output array
    % the first column is sum_intensity_times_x, the second column is
    % sum_intensity_times_y, the third column is sum_intensity, the fourth
    % is num_pixels and the fifth is final_tag
    arr_sums = zeros(NUM_REGIONS, 5, 'int32');
    
    % initialising the array containing final tags and tags associated with them
    arr_final_tags = zeros(NUM_FINAL_TAGS, NUM_TAGS_PER_REGION, 'int32');
    
    % looping over the input image
    for j_set_tags = 2:rows+1
        for i_set_tags = 2:columns+1
            
            % "intensity" is the value stored at [j_tag, i_tag]
            intensity = arr_out_img(j_set_tags, i_set_tags, 1);
                
                % if the pixel is bright,
                if intensity > THRESHOLD
                        
                        % set the value of the pixel to the i_left as
                        % i_left, set the value of the pixel to above as i_above
                        i_left = arr_out_img(j_set_tags, i_set_tags-1, 1);
                        i_above = arr_out_img(j_set_tags-1, i_set_tags, 1);
                        
                        % sequence to be followed if the pixel to the left is bright
                        if i_left>THRESHOLD
                            % set "tag_left" as the tag of the pixel to the left
                            tag_left = arr_out_img(j_set_tags, i_set_tags-1, 2);
                            
                            % if the pixel above is also bright
                            if i_above>THRESHOLD
                                % set "tag_above" as the tag of the pixel above
                                tag_above = arr_out_img(j_set_tags-1, i_set_tags, 2);
                                
                                % if both left and above have the same tag
                                if tag_above == tag_left
                                    % update the tag
                                    tag = tag_above;
                                    arr_out_img(j_set_tags, i_set_tags, 2) = tag;
                                    
                                    % update values in arr_sums
                                    arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_set_tags, intensity*j_set_tags, intensity, 1, 0];
                                
                                % if both the pixel above and to the left are bright, and have different tags
                                else
                                    
                                    % if tag of the pixel above is associated with a nonzero final tag
                                    if arr_sums(tag_above, 5) >0
                                        final_tag_above = arr_sums(tag_above, 5);
                                        
                                        % if the tag of the pixel to the left is also associated with a nonzero final tag
                                        if arr_sums(tag_left, 5) >0
                                            final_tag_left = arr_sums(tag_left, 5);
                                            
                                            % if the two final tags are equal
                                            if final_tag_above == final_tag_left
                                                % update values for the tag
                                                % corresponding to the tag
                                                % of the pixel above
                                                tag = tag_above;
                                                arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_set_tags, intensity*j_set_tags, intensity, 1, 0];
                                                arr_out_img(j_set_tags, i_set_tags, 2) = tag;
                                            
                                            % if the tags of the pixel above and the pixel to the left are associated with different final tags,
                                            else
                                                % update the values
                                                % corresponding to the tag
                                                % of the pixel above
                                                tag = tag_above;
                                                arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_set_tags, intensity*j_set_tags, intensity, 1, 0];
                                                arr_out_img(j_set_tags, i_set_tags, 2) = tag;
                                                
                                                % merge the data
                                                % corresponding to the two
                                                % final tags
                                                larger_final_tag = max(final_tag_above, final_tag_left);
                                                smaller_final_tag = min(final_tag_above, final_tag_left);
                                                num_iterations = arr_final_tags(larger_final_tag, 1);
                                                num_skip = arr_final_tags(smaller_final_tag, 1);
                                                for i_final_tag_change  = 1:num_iterations
                                                    arr_final_tags(smaller_final_tag, num_skip + 1 + i_final_tag_change) = arr_final_tags(larger_final_tag, i_final_tag_change+1);
                                                    arr_sums(arr_final_tags(larger_final_tag, i_final_tag_change), 5) = smaller_final_tag;
                                                    arr_final_tags(larger_final_tag, i_final_tag_change + 1) = 0;
                                                end
                                                arr_final_tags(larger_final_tag, 1) = 0;
                                                arr_final_tags(smaller_final_tag, 1) = num_skip + num_iterations;
                                            end
                                            
                                        % if the final tag of the tag associated with the pixel to the left is zero, but that associated with the one above isn't
                                        else
                                            % update the data of the tag
                                            % of the pixel above
                                            tag = tag_above;
                                            arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_set_tags, intensity*j_set_tags, intensity, 1, 0];
                                            arr_out_img(j_set_tags, i_set_tags, 2) = tag;
                                            % set final_tag as the final
                                            % tag of the region that the
                                            % pixel above is in, update
                                            % corresponding data
                                            final_tag = arr_sums(tag_above, 5);
                                            arr_final_tags(final_tag, arr_final_tags(final_tag, 1)+2) = tag;
                                            arr_sums(tag_left, 5) = final_tag;
                                            arr_final_tags(final_tag, 1) = arr_final_tags(final_tag, 1) + 1;
                                        end
                                    
                                    % if the final tag of the tag of the pixel above is zero
                                    else
                                        
                                        % if the final tag of the tag of the pixel to the left is nonzero
                                        if arr_sums(tag_left, 5) >0
                                            % update the data corresponding
                                            % to the tag of the pixel above
                                            tag = tag_above;
                                            arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_set_tags, intensity*j_set_tags, intensity, 1, 0];
                                            arr_out_img(j_set_tags, i_set_tags, 2) = tag;
                                            % add the tag of the pixel
                                            % above to the final tag
                                            % corresponding to the pixel to
                                            % the left
                                            final_tag = arr_sums(tag_left, 5);
                                            arr_final_tags(final_tag, arr_final_tags(final_tag, 1) + 2) = tag;
                                            arr_sums(tag_above, 5) = final_tag;
                                            arr_final_tags(final_tag, 1) = arr_final_tags(final_tag, 1) + 1;
                                        
                                        % if the final tags of both tag_left and tag_above are zero
                                        else
                                            % update data corresponding to
                                            % the tag of the pixel above
                                            tag = tag_above;
                                            arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_set_tags, intensity*j_set_tags, intensity, 1, 0];
                                            arr_out_img(j_set_tags, i_set_tags, 2) = tag;
                                            % generate a new final tag,
                                            % update correspooonding data
                                            arr_final_tags(final_tag_num, 1) = 2;
                                            arr_final_tags(final_tag_num, 2:3) = [tag_above, tag_left];
                                            arr_sums(tag_above, 5) = final_tag_num;
                                            arr_sums(tag_left, 5) = final_tag_num;
                                            final_tag_num = final_tag_num+1;
                                        end
                                    end
                                end
                            
                             % if the pixel above is dim but the pixel to the left is bright
                            else
                                % update the data corresponding to the tag
                                % of the pixel to the left
                                tag = tag_left;
                                arr_out_img(j_set_tags, i_set_tags, 2) = tag;
                                arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_set_tags, intensity*j_set_tags, intensity, 1, 0];
                            end
                        else
                            % if the pixel above is bright is bright but the pixel to the left is dim
                            if i_above > THRESHOLD
                                % update the data corresponding to the tag
                                % of pixel above
                                tag_above = arr_out_img(j_set_tags-1, i_set_tags, 2);
                                tag = tag_above;
                                arr_out_img(j_set_tags, i_set_tags, 2) = tag;
                                arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_set_tags, intensity*j_set_tags, intensity, 1, 0];
                            
                            % if both the pixel above and to the left are dim
                            else
                                
                                % if the pixel to the right and the one to the right and above are bright
                                if arr_out_img(j_set_tags, i_set_tags+1, 1)>THRESHOLD && arr_out_img(j_set_tags-1, i_set_tags+1, 1)>THRESHOLD
                                    % update the data corresponding to the
                                    % tag of the pixel above the pixel to
                                    % the right
                                    tag = arr_out_img(j_set_tags-1, i_set_tags+1, 2);
                                    arr_out_img(j_set_tags, i_set_tags, 2) = tag;
                                    arr_sums(tag, :) = arr_sums(tag, :) + [intensity*i_set_tags, intensity*j_set_tags, intensity, 1, 0];
                                
                                % if none of the conditions are satisfied,
                                % generate a new tag, update the
                                % corresponding data
                                else
                                arr_sums(tag_num, :) = [intensity*i_set_tags, intensity*j_set_tags, intensity, 1, 0];
                                arr_out_img(j_set_tags, i_set_tags, 2) = tag_num;
                                tag_num = tag_num +1;
                                end
                            end
                        end
                end
        end
    end
    
   % formatting outputs
    arr_sums_x = arr_sums(:, 1);
    arr_sums_y  = arr_sums(:, 2);
    arr_weights = arr_sums(:, 3);
    arr_num = arr_sums(:, 4);
    arr_flags = arr_sums(:, 5);
end