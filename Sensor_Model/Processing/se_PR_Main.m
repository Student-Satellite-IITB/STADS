function [se_Image_Mat, se_T] = se_PR_Main(se_T, se_bo, se_op, se_ig, se_er, se_in)
    % Sensor Model - Processing - Main Function % [se_Image, se_Image_Mat, se_T]
    %   This is the main function for Sensor Model, and calls all the other
    %   functions for the Sensor Model
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
    %   - Variable Names -  SSP_ID, RA, Dec, Magnitude, pm_RA, pm_Dec
    %   
    % se_bo: (Table (1, m_2))
    %   Boresight Inputs. 
    %   Comments: 
    %   - m_1 - # fields
    %   - Only 1 boresight input should be passed. 
    %   - Variable Names -  RA, Dec, Roll, se_r0 {(X, Y, Z)}
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
    %       - se_op.CMOS.Pixel_Size (Double, In Metres)
    %           Pixel Size in Metres
    %       - se_op.CMOS.Defocus    (Double, In Metres)
    %           Defocus value in Metres
    %       - se_op.CMOS.Length     (Double, In Metres)
    %           Length of CMOS in Metres
    %       - se_op.CMOS.Width      (Double, In Metres)
    %           Width of CMOS in Metres
    %       - se_op.CMOS.Diagonal   (Double, In Metres)
    %           Diagonal of CMOS in Metres
    %
    %   - se_op.Lens (Structure)
    %       Lens Related Values
    %       - se_op.Lens.Focal_Length
    %       - se_op.Lens.Diameter
    %
    %   - se_op.FOV (Structure)
    %       FOV Values (Double, In Degrees)
    %       - se_op.FOV.Length
    %       - se_op.FOV.Width
    %       - se_op.FOV.Circular
    %
    %
    % se_ig: (Structure)
    %   The Sensor Model Constants. MUST contain:
    %   - se_ig.Pixel_Spread            (Double)
    %       The number of pixels the Gaussian function spreads to (based on
    %       the defocus value)
    %   - se_ig.Capture_Rate            (Double, In Hz)
    %       Rate at which images are captured
    %   - se_ig.Eta                     (Double)
    %       Quantum Efficiency - Percentage of Photons converted to
    %       Photoelectrons
    %   - se_ig.Gain                    (Double, In LBS10 / Electron)
    %       Gain per photoelectron - Gives the pixel value (10 Bits)
    %   - se_ig.Gauss_Sigma             (Double)
    %       The standard deviation for Image Generation
    %   - se_ig.Exposure_Time           (Double, In Seconds)
    %       Exposure Time for the CMOS Sensor per Image
    %   - se_ig.MTF                     (Double)
    %       Modulation Transfer Function
    %   - se_ig.Full_Well               (Double)
    %       Full Well Capacity of Each Pixel, in # Electrons
    %   - se_ig.C_1                     (Double)
    %       Constant in # Photoelectrons = C_1 * C_2 ^ (-Magnitude)
    %   - se_ig.C_2                     (Double)
    %       Constant in # Photoelectrons = C_1 * C_2 ^ (-Magnitude)
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
    %   - se_in.Magnitude_Limit     (Double)
    %       Magnitude Limit for Sensor Model
    %   - se_in.No_Boresight_Inputs (Double)
    %       Number of Boresight Inputs to the Sensor Model
    %
    % --------
    % Returns:
    % --------
    % se_T_Final: (Table (n_1, m_3))
    %   The Final Table - Trimmed to hold only necessary values. 
    %   Comments:
    %   - n_1 - # stars in the catalogue
    %   - m_3 - # fields (Updated)
    %   - Variable Names -  SSP_ID, RA, Dec, Magnitude, pm_RA, pm_Dec ...
    %
    % se_Image_Mat: (Array (1024, 1280))
    %   Comments:
    %   - Each pixel value is 10 Bits, i.e. 0 to 1023
    %
    % se_Image: (Gray type Image (1024, 1280)
    %   - Generated from se_Image_Mat
    
    % =====
    % Code:
    % =====
    
    % -----------------------------------
    % Trim the Table to stars within FOV:
    % -----------------------------------
    
    se_T = se_PR_1_Trim2FOV(se_T, se_bo, se_op, se_in);
    
    % -------------------------
    % ICRS Frame to Lens Frame:
    % -------------------------
    
    % Doesn't Need Robotics Toolbox
    se_T = se_PR_2a_ICRS2Lens(se_T, se_bo, se_in);
    
    % Needs Robotics Toolbox
    % se_T = se_PR_2b_ICRS2Lens(se_T, se_bo, se_in);  
    
    % ---------------------------
    % Lens Frame to Sensor Frame:
    % ---------------------------
    
    se_T = se_PR_3_Lens2Sensor(se_T, se_op, se_in);
    
    % ---------------------
    % Trim to Sensor Frame:
    % ---------------------
    
    se_T = se_PR_4_Trim2Sensor(se_T, se_op, se_in);
    
    % -----------------
    % Image Generation:
    % -----------------
    
    se_Image_Mat = se_PR_5_Image_Generation(se_T, se_op, se_ig, se_in);
    
    % ------------
    % Noise Model:
    % ------------
    
    se_Image_Mat = se_PR_6_Noise_Model(se_Image_Mat, se_er, se_op, se_ig, se_in);
    

    
end