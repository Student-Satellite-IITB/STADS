function se_Image_Mat = se_PR_6_5_Read_Noise(se_Image_Mat, se_er, se_ig)
% Photo Response Non-Uniformity for the Sensor Model
    %   This function adds the Photo Response Non-Uniformity into the Image Matrix
    %
    % -----------
    % References:
    % -----------
    %
    % Dynamic Range DR = 20 log_10 (N_Saturation / N_Read) where N is the
    % number of electrons. The Read Noise is fairly constant. The values
    % are given in # Electrons and is constant for all pixels
    %
    % References:
    % uio.no/studier/emner/matnat/ifi/nedlagte-emner/INF5440/v10/undervisningsmateriale/F5e.pdf
    % https://www.adimec.com/read-noise-versus-shot-noise-what-is-the-difference-and-when-does-it-matter/
    % https://andor.oxinst.com/learning/view/article/understanding-read-noise-in-scmos-cameras
    % https://camera.hamamatsu.com/jp/en/technical_guides/read_noise/index.html
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
    % se_er: (Structure)
    %   The Sensor Model Error Constants. MUST contain:
    %   - se_er.FPN     (Double)
    %       Fixed Pixel Noise
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
    %   Updated Image Matrix containing PRNU
    %   Comments:
    %   - Each pixel value is 10 Bits, i.e. 0 to 1023
    
    % =====
    % Code:
    % =====
    
    % Define the Read Noise Level
    se_Read_Noise = round(se_ig.Full_Well / 10 ^ (se_er.DR / 20));
    
    % Adding the Read Noise - Constant
    se_Image_Mat = se_Image_Mat + se_ig.Gain * se_Read_Noise;
    
    % Round the Double values to Integer Values
    se_Image_Mat = round(se_Image_Mat);

end

