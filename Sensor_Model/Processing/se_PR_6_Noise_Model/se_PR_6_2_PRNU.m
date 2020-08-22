function se_Image_Mat = se_PR_6_2_PRNU(se_Image_Mat, se_er)
    % Photo Response Non-Uniformity for the Sensor Model
    %   This function adds the Photo Response Non-Uniformity into the Image Matrix
    %
    % -----------
    % References:
    % -----------
    %
    % Photo Response Non-Uniformity in Standard Deviation / Signal % is the
    % non - uniformity in spatial variation of Pixel Values for specific
    % illumination. 
    %
    % http://isl.stanford.edu/~abbas/ee392b/lect07.pdf
    % https://www.spiedigitallibrary.org/conference-proceedings-of-spie/10757/107570A/CMOS-image-sensor--characterizing-its-PRNU-photo-response-non/10.1117/12.2321168.full?SSO=1
    % http://caeleste.be/wp-content/uploads/2018/05/MS-thesis-characterization.pdf
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
    %   - se_er.PRNU     (Double)
    %       Photo Response Non-Uniformity
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
    
    % Define the pseudo-random generator used
    rng(se_er.rng_Seed);
    
    % Add PRNU to the image
    se_Image_Mat = se_Image_Mat + se_er.PRNU * randn(size(se_Image_Mat)) .* se_Image_Mat;
end

