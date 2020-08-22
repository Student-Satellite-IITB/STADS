function se_Image_Mat = se_PR_0_PLS(se_Image_Mat, se_er, se_ig)
    % Add Noise due to electrons when Shutter is closed
    %   This function adds the noise due to electrons when the shutter is
    %   closed
    %
    % -----------
    % References:
    % -----------
    %
    % When the shutter is closed, the memory node can still be struck by
    % electrons. Even though its sensitivity id lower (By a factor of PLS),
    % This can lead to noise in the sensor output. Note that the time taken
    % has to be 1 / Capture Rate and not the Exposure Time as the memory
    % node can be struck by electrons at any moment. (Check)
    % Anyways, it's too less to be of any concern right now.
    %
    % https://www.onsemi.com/pub/Collateral/KAC-06040-D.PDF
    % https://www.researchgate.net/publication/322707775_Development_of_Low_Parasitic_Light_Sensitivity_and_Low_Dark_Current_28_mm_Global_Shutter_Pixel
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
    
    % Add the PLS related noise
    se_Image_Mat = se_Image_Mat + se_ig.Gain * se_er.PLS * (1 / se_ig.Capture_Rate);
end

