function [arr_img, centroid_data_st] = fe_get_data(arr_img, i_region_growth, j_region_growth, star_num, centroid_data_st,FE_const)
    %% loading constants
    %load('fe_constants_region_growth.mat', 'THRESHOLD');
    THRESHOLD =FE_const.THRESHOLD;
    %% base case
    if arr_img(j_region_growth, i_region_growth) <= THRESHOLD
        return;
    end

    %% updating centroid_data
    % -1 because of the padding added
    centroid_data_st(star_num, 1) = centroid_data_st(star_num, 1) + arr_img(j_region_growth, i_region_growth) * (i_region_growth - 1);
    centroid_data_st(star_num, 2) = centroid_data_st(star_num, 2) + arr_img(j_region_growth, i_region_growth) * (j_region_growth - 1);
    centroid_data_st(star_num, 3) = centroid_data_st(star_num, 3) + arr_img(j_region_growth, i_region_growth);
    centroid_data_st(star_num, 4) = centroid_data_st(star_num, 4) + 1;
    % setting to 0 so that i does not go into infinite loop
    arr_img(j_region_growth, i_region_growth) = 0;

    %% recursive call to 4 neighbours
    [arr_img, centroid_data_st] = fe_get_data(arr_img, i_region_growth - 1, j_region_growth, star_num, centroid_data_st,FE_const);
    [arr_img, centroid_data_st] = fe_get_data(arr_img, i_region_growth + 1, j_region_growth, star_num, centroid_data_st,FE_const);
    [arr_img, centroid_data_st] = fe_get_data(arr_img, i_region_growth, j_region_growth - 1, star_num, centroid_data_st,FE_const);
    [arr_img, centroid_data_st] = fe_get_data(arr_img, i_region_growth, j_region_growth + 1, star_num, centroid_data_st,FE_const);
end
