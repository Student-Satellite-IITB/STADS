function se_T = se_PR_3_Lens2Sensor(se_T, se_op, se_in)
    % Transforms the Star Coordinates from Lens Frame to Sensor Frame
    %   This script transforms all star coordinates from the Lens Frame
    %   (3D) to the Sensor Frame (2D)
    %
    % -----------
    % Parameters:
    % -----------
    %
    % se_T: (Table (n_1, m_1))
    %   The SKY2000 Catalogue Preprocessed for Sensor Model. 
    %   Comments: 
    %   - n_1 - # stars
    %   - m_1 - # fields
    %   - Variable Name -  "r3" - Unit Vector
    %   - Format - (X, Y, Z)
    %
    % se_op: (Structure)
    %   The Constants from Optics. It MUST contain:
    %
    %   - se_op.CMOS (Structure)
    %       CMOS Related Values
    %       - se_op.CMOS.Defocus    (Double, In Metres)
    %           Defocus value in Metres
    %
    %   - se_op.Lens (Structure)
    %       Lens Related Values
    %       - se_op.Lens.Focal_Length
    %
    % se_in: (Structure)
    %   The Sensor Model Constants. MUST contain:
    %   - se_in.Debug_Run (boolean)
    %       Whether or not to display Debug Messages.
    %
    % --------
    % Returns:
    % --------
    %
    % se_T : (Table (n, m_1 + 2))
    %   The Updated Table with Cartesian Coordinates in the Lens Frame
    %   Comments:
    %   - Variable Names Added - Sensor_y, Sensor_z [(n, 1) each]
    
    % =====
    % Code:
    % =====
    
    % Add the broadcasted Focal Length and Pixel_Size to the table
    se_T = [se_T repmat(array2table(se_op.Lens.Focal_Length - se_op.CMOS.Defocus, 'VariableNames', {'Focal_Length'}), size(se_T.RA))];
    se_T = [se_T repmat(array2table(se_op.CMOS.Pixel_Size - se_op.CMOS.Defocus, 'VariableNames', {'Pixel_Size'}), size(se_T.RA))];
   
    se_T = [se_T rowfun(@Lens2Sensor_y, se_T, 'InputVariables', {'r3' 'Focal_Length'}, 'OutputVariableName', 'Sensor_y')...
                 rowfun(@Lens2Sensor_z, se_T, 'InputVariables', {'r3' 'Focal_Length'}, 'OutputVariableName', 'Sensor_z')];
    se_T = [se_T rowfun(@y2y_Pix, se_T, 'InputVariables', {'Sensor_y' 'Pixel_Size'}, 'OutputVariableName', 'Sensor_y_Pixels')...
                 rowfun(@z2z_Pix, se_T, 'InputVariables', {'Sensor_z' 'Pixel_Size'}, 'OutputVariableName', 'Sensor_z_Pixels')];
    if (se_in.Debug_Run == true); disp('Lens to Sensor: Transformation Completed'); end
    
    
    % Display Sucess
    fprintf('Lens to Sensor: Success \n \n');
end

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