function [arr_row_data, num_ranges]  = fe_extract_row_data(arr_row)
%{
input:
-arr_row:
      a row of the input image
output:
-arr_range_data:
      array containing the sum of x value times the intensity of bright
      pixels in a range of bright pixels in the first column, sum of
      intensities of those pixels in the second, the number of pixels in
      the third and the start and end pixel of the range in the fourth
      and fifth respectively
- num_ranges:
      the number of ranges in the row
%}
    % loading constants
    load("constants_feature_extraction_3.mat", "NUM_RANGES_ROW", "BREADTH", "THRESHOLD");
    
    % initializing variables
    arr_row_data = zeros(NUM_RANGES_ROW, 5);
    num_ranges = 0;
    range_bool = 0;
    
    for i_row = 1:BREADTH
        intensity = arr_row(i_row);
        
        % if the pixel is bright
        if intensity > THRESHOLD
            
            % if the previous pixel is also bright, update the data there
            if range_bool == 1
                arr_row_data(num_ranges, 1:3) = arr_row_data(num_ranges, 1:3) + [intensity*i_row, intensity, 1];
            
            % if not, start a new range
            else
                range_bool = 1;
                num_ranges = num_ranges+1;
                arr_row_data(num_ranges, 1:4) = arr_row_data(num_ranges, 1:4) + [intensity*i_row, intensity, 1, i_row];
            end
            
        % if the pixel is dim, but the previous one was bright, end the
        % range
        elseif range_bool == 1
            arr_row_data(num_ranges, 5) = i_row-1;
            range_bool  = 0;
        end
    end
    arr_row_data = arr_row_data(1:num_ranges, :);
end