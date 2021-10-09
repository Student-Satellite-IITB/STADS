function arr_centroid_data = fe_add_centroid_data(arr_centroid_data, arr_centroid_data_new, i_row)
%{
input:
-arr_centroid_data:
    array containing previously collected data
-num_row:
    the row from which the new data was collected
-arr_centroid_data_new:
    array with new data from the num_row^th row
output:
-arr_centroid_data:
    updated array containing consolidated data
%}

    % sum of x coordinate times intensity
    arr_centroid_data(:, 1) = arr_centroid_data(:, 1) + arr_centroid_data_new(:, 1);
    
    % sum of intensities and number of pixels
    arr_centroid_data(:, 3:4) = arr_centroid_data(:, 3:4) + arr_centroid_data_new(:, 2:3);
    
    % y*sum of intensities
    arr_centroid_data(:, 2) = arr_centroid_data(:, 2) + arr_centroid_data_new(:, 2) * i_row;
end