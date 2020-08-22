function se_Image_Mat = se_PR_6_Noise_Model(se_Image_Mat, se_er, se_op, se_ig, se_in)
    % Noise Model - Processing - Main Function
    %   This is the main function for Noise Model within the Sensor Model, 
    % and calls all the other functions for the Noise Model.
    %
    % -----------
    % Parameters:
    % -----------
    %
    % se_Image_Mat: (Array (1024, 1280))
    %   Input no-noie Image Matrix
    %   Comments:
    %   - Each pixel value is 10 Bits, i.e. 0 to 1023
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
    %   - se_ig.Capture_Rate            (Double, In Hz)
    %       Rate at which images are captured
    %   - se_ig.Gain                    (Double, In LBS10 / Electron)
    %       Gain per photoelectron - Gives the pixel value (10 Bits)
    %   - se_ig.Exposure_Time           (Double, In Seconds)
    %       Exposure Time for the CMOS Sensor per Image
    %   - se_ig.Full_Well               (Double)
    %       Full Well Capacity of Each Pixel, in # Electrons
    %
    % se_er: (Structure)
    %   The Sensor Model Error Constants. MUST contain:
    %   - se_er.DTN     (Double)
    %       Dark Temporal Noise
    %   - se_er.FPN     (Double)
    %       Fixed PAttern Noise
    %   - se_er.PLS     (Double)
    %       Parasitic Light Sensitivity
    %   - se_er.PRNU    (Double)
    %       Photo Response Non-Uniformity
    %   - se_er.PSNL    (Double)
    %       Pixel Storage Node Leakage
    %   - se_er.DS      (Double)
    %       Dark Signal
    %   - se_er.SNR     (Double)
    %       Signal to Noise Ratio
    %   - se_er.DR      (Double)
    %       Dynamic Range
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
    %   Updated Image Matrix containing all noises
    %   Comments:
    %   - Each pixel value is 10 Bits, i.e. 0 to 1023
    
    % --------------------------------------------------------------------
    
    % =====
    % Code:
    % =====
    
    % --------------------------------------------------------------------
    
    % ===================
    % Pre-existing Noise:
    % ===================
    
    % ----------------------------
    % Parasitic Light Sensitivity:
    % ----------------------------
    
    se_Image_Mat = se_PR_0_PLS(se_Image_Mat, se_er, se_ig);
    
    % ================
    % Temporal Noises:
    % ================
    
    % ------------------
    % Photon Shot Noise:
    % ------------------
    
    % Apply Photon Shot Noise - Poisson Distribution
    se_Image_Mat = se_PR_6_1_Photon_Shot_Noise(se_Image_Mat);
    if (se_in.Debug_Run == 1); disp('Noise Model: Photon Noise Applied'); end
    
    % --------------------------------------------------------------------
    
    % ===============
    % Spatial Noises:
    % ===============
    
    % ------------------------------
    % Photo Response Non-Uniformity:
    % ------------------------------
    
    % Add the PRNU to Image (Signal Dependent)
    se_Image_Mat = se_PR_6_2_PRNU(se_Image_Mat, se_er);
    if (se_in.Debug_Run == 1); disp('Noise Model: PRNU Added'); end
    
    % --------------------------------------------------------------------
    
    % ================
    % Temporal Noises:
    % ================
    
    % --------------------
    % Dark Temporal Noise:
    % --------------------
    
    % Add Dark Noise
    se_Image_Mat = se_PR_6_3_Dark_Noise(se_Image_Mat, se_ig, se_er);
    if (se_in.Debug_Run == 1); disp('Noise Model: Dark Noise Added'); end
    
    % --------------------------------------------------------------------
    
    % ===============
    % Spatial Noises:
    % ===============
    
    % --------------------
    % Fixed Pattern Noise:
    % --------------------
    
    % Add Fixed Pattern Noise
    se_Image_Mat = se_PR_6_4_Fixed_Pattern_Noise(se_Image_Mat, se_er);
    if (se_in.Debug_Run == 1); disp('Noise Model: Fixed Pattern Noise Added'); end
    
    % --------------------------------------------------------------------
    
    % =====================
    % Discretisation Noise:
    % =====================
    
    % Round the Double values to Integer Values
    se_Image_Mat = round(se_Image_Mat);
    if (se_in.Debug_Run == 1); disp('Noise Model: Image Matrix Discretised'); end
    
    % --------------------------------------------------------------------
    
    % ================
    % Temporal Noises:
    % ================
    
    % ---------------
    % Read Out Noise:
    % ---------------
    
    se_Image_Mat = se_PR_6_5_Read_Noise(se_Image_Mat, se_er, se_ig);
    if (se_in.Debug_Run == 1); disp('Noise Model: Read Out Noise Added'); end
    
    % --------------------------------------------------------------------
    
    % ===========
    % PSNL Noise:
    % ===========
    
    % Appying Pixel Storage Node Leakage
    se_Image_Mat = se_PR_6_6_PSNL(se_Image_Mat, se_er, se_ig, se_op);
    if (se_in.Debug_Run == 1); disp('Noise Model: Pixel Storage Node Leakage Added'); end
    
    % ============
    % Trim Values:
    % ============
    
    % As the Pixel Values can't be outside the range [0, 1023]
    se_Image_Mat = max(se_Image_Mat, 0);
    se_Image_Mat = min(se_Image_Mat, 1023);
    
    % ===============
    % Display Sucess:
    % ===============
    
    fprintf('Noise Model: Success \n \n');
end

