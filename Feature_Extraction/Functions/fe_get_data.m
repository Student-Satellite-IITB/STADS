function [img, centroid_data] = fe_get_data(img, i, j, star_num, centroid_data)
    % base case
    if img(i, j) <= 9 % arbitrary threshold
        return;
    end
    
    % changing the data in centroid_data accordingly
    % -2 is there so that it matches with the output of python generated
    % images
    centroid_data{star_num, 'x_sum'} = centroid_data{star_num, 'x_sum'} + img(i, j) * (i - 2);
    centroid_data{star_num, 'y_sum'} = centroid_data{star_num, 'y_sum'} + img(i, j) * (j - 2);
    centroid_data{star_num, 'pixel_sum'} = centroid_data{star_num, 'pixel_sum'} + img(i, j);
    % setting to 0 so that i does not go into infinite loop
    img(i, j) = 0;
    
    % calling its four neighbours recursively
    [img, centroid_data] = getData(img, i - 1, j, star_num, centroid_data);
    [img, centroid_data] = getData(img, i + 1, j, star_num, centroid_data);
    [img, centroid_data] = getData(img, i, j - 1, star_num, centroid_data);
    [img, centroid_data] = getData(img, i, j + 1, star_num, centroid_data);
end
