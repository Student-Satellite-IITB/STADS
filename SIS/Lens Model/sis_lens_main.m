function [sis_photon_profile] = sis_lens_main(sis_T, sis_input)
    %% Lens to Sensor Frame
    
    
    sis_T = [sis_T repmat(array2table(sis_input.lls.Lens.Focal_Length - sis_input.lls.CMOS.Defocus, 'VariableNames', {'Focal_Length'}), size(sis_T.RA))];
    sis_T = [sis_T repmat(array2table(sis_input.lls.CMOS.Pixel_Size - sis_input.lls.CMOS.Defocus, 'VariableNames', {'Pixel_Size'}), size(sis_T.RA))];
   
    sis_T = [sis_T rowfun(@Lens2Sensor_y, sis_T, 'InputVariables', {'r3' 'Focal_Length'}, 'OutputVariableName', 'Sensor_y')...
                 rowfun(@Lens2Sensor_z, sis_T, 'InputVariables', {'r3' 'Focal_Length'}, 'OutputVariableName', 'Sensor_z')];
    sis_T = [sis_T rowfun(@y2y_Pix, sis_T, 'InputVariables', {'Sensor_y' 'Pixel_Size'}, 'OutputVariableName', 'Sensor_y_Pixels')...
                 rowfun(@z2z_Pix, sis_T, 'InputVariables', {'Sensor_z' 'Pixel_Size'}, 'OutputVariableName', 'Sensor_z_Pixels')];
    if (sis_input.gen.Debug_Run == true); disp('Lens to Sensor: Transformation Completed'); end
    
    
    % Display Sucess
    fprintf('Lens to Sensor: Success \n \n');
    
    
    %% Trim to Sensor
    
    % Trim to Sensor Dimensions
    sis_T = sis_T(sis_T.Sensor_y <= + sis_input.lls.CMOS.Length / 2, :);
    sis_T = sis_T(sis_T.Sensor_y >= - sis_input.lls.CMOS.Length / 2, :);
    sis_T = sis_T(sis_T.Sensor_z <= + sis_input.lls.CMOS.Width / 2, :);
    sis_T = sis_T(sis_T.Sensor_z >= - sis_input.lls.CMOS.Width / 2, :);
    if (sis_input.gen.Debug_Run == 1); disp('Trim to Sensor: Table Modified'); end
    
    % Display Sucess
    fprintf('Trim to Sensor: Success \n \n');
    
    
    %% Gaussian Modelling
    % Define arrays x_c and y_c containing centroids and m_c containing
    % magnitudes
    y_c = (table2array(sis_T(:, find(string(sis_T.Properties.VariableNames) =='Sensor_y_Pixels'))))';     %#ok<FNDSB>
    z_c = (table2array(sis_T(:, find(string(sis_T.Properties.VariableNames) =='Sensor_z_Pixels'))))';     %#ok<FNDSB>
    m_c = (table2array(sis_T(:, find(string(sis_T.Properties.VariableNames) =='Magnitude'))))';           %#ok<FNDSB>
    if (sis_input.gen.Debug_Run == 1); disp('Image Generation: Centroids with Magnitude Loaded'); end
    
    % Change frames from the centre of the Frame to the first pixel and
    % flip along Y for calculations
    y_c = y_c + sis_input.lls.CMOS.Length_Pix / 2 + 0.5;
    z_c = -z_c + sis_input.lls.CMOS.Width_Pix / 2 + 0.5;
    if (sis_input.gen.Debug_Run == 1); disp('Image Generation: Centroids shifted from the Centre Frame to (0, 0) Frame (Flipped)'); end
    
    % Define n to hold the number of stars
    n = size(y_c);
    
    % Broadcasting the centroids
    y_c = repmat(reshape(y_c, 1, 1, []), sis_input.lls.CMOS.Width_Pix, sis_input.lls.CMOS.Length_Pix);
    z_c = repmat(reshape(z_c, 1, 1, []), sis_input.lls.CMOS.Width_Pix, sis_input.lls.CMOS.Length_Pix);
    m_c = repmat(reshape(m_c, 1, 1, []), sis_input.lls.CMOS.Width_Pix, sis_input.lls.CMOS.Length_Pix);
    
    % Initialising Grid
    [Y, Z] = meshgrid(1:sis_input.lls.CMOS.Length_Pix, 1:sis_input.lls.CMOS.Width_Pix);
    if (sis_input.gen.Debug_Run == 1); disp('Image Generation: Grid Initialised'); end
    
    % Broadcasting the Grid
    Y = repmat(Y, [1, n]);
    Z = repmat(Z, [1, n]);
    
    % Calculating the Pixel Values
    %%%% Want to discuss the formula
    %photon_values = sis_input.lls.Gain * sis_input.lls.C_1 * sis_input.lls.C_2 .^ (-m_c) / (sis_input.lls.Gauss_Sigma * sqrt(2 * pi)) .* exp(-((Y - y_c) .^2 + (Z - z_c) .^ 2) / (2 * sis_input.lls.Gauss_Sigma ^ 2));
    sigma  = sqrt(2) * sis_input.lls.Pixel_Spread / 3 ;
    photon_values = sis_input.lls.C_1 * sis_input.lls.C_2 .^ (-m_c) / (pi * sigma^2 ) .* exp(-((Y - y_c) .^2 + (Z - z_c) .^ 2)/(sigma^2));
    if (sis_input.gen.Debug_Run == 1); disp('Image Generation: Pixel Values Calculated'); end
    
    % Generate Image Matrix
    sis_photon_profile =  sum(photon_values, 3);
    
    if (sis_input.gen.Debug_Run == 1); disp('Image Generation: Image Matrix Generated'); end
    
    % Display Sucess
    fprintf('Image Generation: Success \n \n');
end



%% Functions for Lens to Sensor Frame

function y = Lens2Sensor_y(r3, Adjusted_Focal_Length)
    % Calculates the y Value on the Sensor
    % This function calculates the y Value on the Sensor
    %
    % -----------
    % Parameters:
    % -----------
    %
    % r3: (Array (3,1))
    %   The reference unit vector in the Lens Frame
    %   Comments: 
    %   - Format - (X, Y, Z)
    %   
    % Adjusted Focal Length: (Double)
    %   Equals to Focal Length - Defocus
    %
    % --------
    % Returns:
    % --------
    %
    % y: (Double)
    %   The y - Value on Sensor (In Metres)
    
    % =====
    % Code:
    % =====
    
    y = r3(2) * Adjusted_Focal_Length / r3(1);
end

function z = Lens2Sensor_z(r3, Adjusted_Focal_Length)
    % Calculates the z Value on the Sensor
    % This function calculates the z Value on the Sensor
    %
    % -----------
    % Parameters:
    % -----------
    %
    % r3: (Array (3,1))
    %   The reference unit vector in the Lens Frame
    %   Comments: 
    %   - Format - (X, Y, Z)
    %   
    % Adjusted Focal Length: (Double)
    %   Equals to Focal Length - Defocus
    %
    % --------
    % Returns:
    % --------
    %
    % z: (Double)
    %   The z - Value on Sensor (In Metres)
    
    % =====
    % Code:
    % =====
    
    z = r3(3) * Adjusted_Focal_Length / r3(1);
end

function y_Pix = y2y_Pix(y, Pixel_Size)
    % Calculates the y Value on the Sensor in Pixels
    % This function calculates the y Value on the Sensor in Pixels
    %
    % -----------
    % Parameters:
    % -----------
    %
    % y: (Double, In Metres)
    %   The y coordinate in Metres
    %   
    % Pixel_Size: (Double, In Metres)
    %   Pixel Size in Metres
    %
    % --------
    % Returns:
    % --------
    %
    % y_Pix: (Double)
    %   The y - Value on Sensor (In Pixels)
    
    % =====
    % Code:
    % =====
    
    y_Pix = y / Pixel_Size;
end

function z_Pix = z2z_Pix(z, Pixel_Size)
    % Calculates the z Value on the Sensor in Pixels
    % This function calculates the z Value on the Sensor in Pixels
    %
    % -----------
    % Parameters:
    % -----------
    %
    % z: (Double, In Metres)
    %   The z coordinate in Metres
    %   
    % Pixel_Size: (Double, In Metres)
    %   Pixel Size in Metres
    %
    % --------
    % Returns:
    % --------
    %
    % z_Pix: (Double)
    %   The z - Value on Sensor (In Pixels)
    
    % =====
    % Code:
    % =====
    
    z_Pix = z / Pixel_Size;
end

