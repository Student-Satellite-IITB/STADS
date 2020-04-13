function [arr_sums, arr_merge] = tag(arr_in_img)
    load('constants_feature_extraction.mat', NUM_MERGE, NUM_REGIONS, THRESHOLD);
    [length,breadth] = size(arr_in_img);
    arr_out_img = zeros(length+2, breadth+2, 2);
    arr_out_img(2:length+1, 2:breadth+1, 1) = arr_in_img;
    tag_num = 1;
    merge_num = 1;
    arr_sums = zeros(NUM_REGIONS,3);
    arr_merge = zeros(NUM_MERGE, 2);
    for i_tag = 2:length+1
        for j_tag = 2:breadth+1
            if arr_out_img(i_tag, j_tag, 1) > THRESHOLD
                left = arr_out_img(i_tag-1, j_tag, 1);
                above = arr_out_img(i_tag, j_tag-1, 1);
                if left ==1
                    if above == 1
                        if arr_out_img(i_tag-1, j_tag, 2) == arr_out_img(i_tag, j_tag-1, 2)
                            tag = arr_out_img(i_tag, j_tag-1, 2);
                            arr_out_img(i_tag, j_tag, 2) = tag;
                            arr_sums(tag) = arr_sums(tag, :) + [i_tag, j_tag, 1];
                        else
                            tag_left = arr_out_img(i_tag-1, j_tag, 2);
                            tag_above = arr_out_img(i_tag, j_tag-1, 2);
                            arr_merge(merge_num, :) = [min(tag_left, tag_above), max(tag_left, tag_above)];
                            merge_num = merge_num +1;
                            arr_out_img(i_tag, j_tag, 2) = tag_left;
                            arr_sums(tag_left) = arr_sums(tag_left) + [i_tag, j_tag, 1];
                        end
                    else
                        tag = arr_out_img(i_tag-1, j_tag, 2);
                        arr_out_img(i_tag, j_tag, 2) = tag;
                        arr_sums(tag, :) = arr_sums(tag, :) + [i_tag, j_tag, 1];
                    end
                else
                    if above == 1
                        tag = arr_out_img(i_tag, j_tag+1, 2);
                        arr_out_img(i_tag, j_tag, 2) = tag;
                        arr_sums(tag, :) = arr_sums(tag, :) + [i_tag, j_tag, 1];
                    else
                        arr_out_img(i_tag, j_tag, 2) = tag_num;
                        arr_sums(tag_num) = [i_tag, j_tag, 1];
                        tag_num = tag_num +1;
                    end
                end
            end
        end
    end
