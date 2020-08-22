function se_Image_Mat = se_PR_6_3_Dark_Noise(se_Image_Mat, se_ig, se_er)
    % Dark Noise for the Sensor Model
    %   This function adds the Dark  Noise into the Image Matrix
    %
    % -----------
    % References:
    % -----------
    %
    % Dark Noise in # Electrons is the noise due the reverse bias
    % leakage current in all diodes. The noise value in the datasheet is
    % gives as the variance of the values from the mean. Hence, this is
    % modelled as a white noise with Standard Deviation as the value given in the
    % datasheet (Dark Temporal Noise + Dark Signal * Exposure Time)
    %
    % https://harvestimaging.com/blog/?p=795
    % https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=10773
    % https://camera.hamamatsu.com/jp/en/technical_guides/dark_noise/index.html
    %
    % -----------
    % Parameters:
    % -----------
    %
    % se_Image_Mat: (Array (1024, 1280))
    %   Image Matrix without Photon Shot Noise
    %   Comments:
    %   - Each pixel value is 10 Bits, i.e. 0 to 1023
    %
    % se_ig: (Structure)
    %   The Sensor Model Constants. MUST contain:
    %   - se_ig.Gain                    (Double, In LBS10 / Electron)
    %       Gain per photoelectron - Gives the pixel value (10 Bits)
    %
    % se_er: (Structure)
    %   The Sensor Model Error Constants. MUST contain:
    %   - se_er.DTN     (Double)
    %       Dark Temporal Noise
    %
    % --------
    % Returns:
    % --------
    %
    % se_Image_Mat: (Array (1024, 1280))
    %   Updated Image Matrix containing Photon Shot Noise
    %   Comments:
    %   - Each pixel value is 10 Bits, i.e. 0 to 1023
    
    % =====
    % Code:
    % =====
    
    % Add Dark Noise to the image
    se_Image_Mat = se_Image_Mat + se_ig.Gain * round((se_er.DTN * ones(size(se_Image_Mat)) + (se_er.DS * se_ig.Exposure_Time) * randn(size(se_Image_Mat))));
    % Notice the rounding - as # Electrons can't be fractional
end

