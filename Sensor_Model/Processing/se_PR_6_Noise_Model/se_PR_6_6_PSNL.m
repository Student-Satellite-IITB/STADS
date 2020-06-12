function se_Image_Mat = se_PR_6_6_PSNL(se_Image_Mat, se_er, se_ig, se_op)
    % Pixel Storage Node Leakage for the Sensor Model
    %   This function adds the Pixel Storage Node Leakage into the Image Matrix
    %
    % -----------
    % References:
    % -----------
    %
    % In the time it takes for the values to be read from the pixel, some
    % electrons leak from the Storage Node. This is caharacterised by Pixel
    % Storage Node Leakage in # Electrons per Second. Here, we havae
    % subtracted the PSNL from the actual value.
    % For our case right now, this is zero. 
    %
    % References:
    % https://www.mdpi.com/1424-8220/19/24/5550/htm
    % https://www.onsemi.com/pub/Collateral/AND9049-D.PDF
    %
    % -----------
    % Parameters:
    % -----------
    %
    % se_Image_Mat: (Array (1024, 1280))
    %   Image Matrix without Photon Shot Noise
    %   Comments:
    %   - Each pixel value is 10 Bits, i.e. 0 to 1023
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
    % se_er: (Structure)
    %   The Sensor Model Error Constants. MUST contain:
    %   - se_er.PSNL        (Double)
    %       Pixel Storage Nodel Leakage (Electrons / Second)
    %   - se_er.Read_Rate   (Double)
    %       Rate at which data is read from the sensor
    %
    % se_ig: (Structure)
    %   The Sensor Model Constants. MUST contain:
    %   - se_ig.Gain                    (Double, In LBS10 / Electron)
    %       Gain per photoelectron - Gives the pixel value (10 Bits)
    %
    % --------
    % Returns:
    % --------
    %
    % se_Image_Mat: (Array (1024, 1280))
    %   Updated Image Matrix containing PSNL
    %   Comments:
    %   - Each pixel value is 10 Bits, i.e. 0 to 1023
    
    % =====
    % Code:
    % =====
    
    % Calculate the PSNL Noise at each pixel
    row     = repmat(1:se_op.CMOS.Length_Pix, [se_op.CMOS.Width_Pix, 1]);
    column  = repmat((1:se_op.CMOS.Width_Pix)', [1, se_op.CMOS.Length_Pix]);
    PSNL_Noise_Time = (row + (se_op.CMOS.Width_Pix - column) * se_op.CMOS.Length_Pix) / se_er.Read_Rate;
    PSNL_Noise = se_ig.Gain * round(se_er.PSNL * PSNL_Noise_Time);
    % Notice the rounding - as number of electrons can't be fractional
    
    % Add the PSNL Noise to each pixel
    se_Image_Mat = se_Image_Mat - PSNL_Noise;
end

