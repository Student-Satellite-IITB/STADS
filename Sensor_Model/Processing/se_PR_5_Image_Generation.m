function [se_Image_Mat] = se_PR_5_Image_Generation(se_T, se_op, se_ig, se_in)
    % Image Generation from the centroids
    %   This function generates the image from the centroids
    %
    % -----------
    % Parameters:
    % -----------
    %
    % se_T: (Table (n_1, m_1))
    %   The SKY2000 Catalogue Preprocessed for Sensor Model. 
    %   Comments: 
    %   - n_1 - # stars in the catalogue
    %   - m_1 - # fields
    %   - Variable Names - Sensor_y_Pixels, Sensor_z_Pixels
    %
    % se_op: (Structure)
    %   The Constants from Optics. It MUST contain:
    %
    %   - se_op.CMOS (Structure)
    %       CMOS Related Values
    %       - se_op.CMOS.Length_Pix (Double, In Pixels)
    %           Length of CMOS in Pixels
    %       - se_op.CMOS.Width_Pix  (Double, In Pixels)
    %           Width of CMOS in Pixels
    %
    % se_ig: (Structure)
    %   The Sensor Model Constants. MUST contain:
    %   - se_ig.Pixel_Spread            (Double)
    %       The number of pixels the Gaussian function spreads to (based on
    %       the defocus value)
    %   - se_ig.Gain                    (Double, In LBS10 / Electron)
    %       Gain per photoelectron - Gives the pixel value (10 Bits)
    %   - se_ig.C_1                     (Double)
    %       Constant in # Photoelectrons = C_1 * C_2 ^ (-Magnitude)
    %   - se_ig.C_2                     (Double)
    %       Constant in # Photoelectrons = C_1 * C_2 ^ (-Magnitude)
    %
    % se_in: (Structure)
    %   The Sensor Model Constants. MUST contain:
    %   - se_in.Debug_Run           (Boolean)
    %       Whether or not to display Debug Messages.
    %
    % --------
    % Returns:
    % --------
    %
    % se_Image_Mat: (Array (1024, 1280))
    %   Comments:
    %   - Each pixel value is 10 Bits, i.e. 0 to 1023
    
    % =====
    % Code:
    % =====
    
    % Define arrays x_c and y_c containing centroids and m_c containing
    % magnitudes
    y_c = (table2array(se_T(:, find(string(se_T.Properties.VariableNames) =='Sensor_y_Pixels'))))';     %#ok<FNDSB>
    z_c = (table2array(se_T(:, find(string(se_T.Properties.VariableNames) =='Sensor_z_Pixels'))))';     %#ok<FNDSB>
    m_c = (table2array(se_T(:, find(string(se_T.Properties.VariableNames) =='Magnitude'))))';           %#ok<FNDSB>
    if (se_in.Debug_Run == 1); disp('Image Generation: Centroids with Magnitude Loaded'); end
    
    % Change frames from the centre of the Frame to the first pixel and
    % flip along Y for calculations
    y_c = y_c + se_op.CMOS.Length_Pix / 2 - 0.5;
    z_c = -z_c + se_op.CMOS.Width_Pix / 2 - 0.5;
    if (se_in.Debug_Run == 1); disp('Image Generation: Centroids shifted from the Centre Frame to (1,1) Frame (Flipped)'); end
    
    % Define n to hold the number of stars
    n = size(y_c);
    
    % Broadcasting the centroids
    y_c = repmat(reshape(y_c, 1, 1, []), se_op.CMOS.Width_Pix, se_op.CMOS.Length_Pix);
    z_c = repmat(reshape(z_c, 1, 1, []), se_op.CMOS.Width_Pix, se_op.CMOS.Length_Pix);
    m_c = repmat(reshape(m_c, 1, 1, []), se_op.CMOS.Width_Pix, se_op.CMOS.Length_Pix);
    
    % Initialising Grid
    [Y, Z] = meshgrid(1:se_op.CMOS.Length_Pix, 1:se_op.CMOS.Width_Pix);
    if (se_in.Debug_Run == 1); disp('Image Generation: Grid Initialised'); end
    
    % Broadcasting the Grid
    Y = repmat(Y, [1, n]);
    Z = repmat(Z, [1, n]);
    
    % Calculating the Pixel Values
    Pixel_Values = se_ig.Gain * se_ig.C_1 * se_ig.C_2 .^ (-m_c) / (se_ig.Gauss_Sigma * sqrt(2 * pi)) .* exp(-((Y - y_c) .^2 + (Z - z_c) .^ 2) / (2 * se_ig.Gauss_Sigma ^ 2));
    if (se_in.Debug_Run == 1); disp('Image Generation: Pixel Values Calculated'); end
    
    % Generate Image Matrix
    se_Image_Mat =  sum(Pixel_Values, 3);
    
    % Flip back the Matrix
    se_Image_Mat = flip(se_Image_Mat, 1);
    if (se_in.Debug_Run == 1); disp('Image Generation: Image Matrix Generated'); end
    
    % Display Sucess
    fprintf('Image Generation: Success \n \n');
end


