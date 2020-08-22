function se_T = se_PR_2a_ICRS2Lens(se_T, se_bo, se_in)
    % Transforms the Star Coordinates from ICRS Frame to Lens Frame
    %   This script transforms all star coordinates from the celestial sphere 
    %   into the boresight coordinates or lens coordinates.
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
    %   - Variable Name -  "r0" - Unit Vector
    %   - Format - (X, Y, Z)
    %   
    % se_bo: (Table (1, m_2))
    %   Boresight Inputs. 
    %   Comments: 
    %   - m_1 - # fields
    %   - Only 1 boresight input should be passed. 
    %   - Variable Names -  RA, Dec, Roll
    %   - Format - (X, Y, Z)
    %
    % se_op: (Structure)
    %   The Constants from Optics. It MUST contain:
    %   - se_op.FOV.Circular (double, In Degrees)
    %       The Circular FOV for the System.
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
    %   - Variable Names Added - r1, r2, r3 [(n, 3) each]
    
    % =====
    % Code:
    % =====
    
    % Define Rotation Matrices
    se_Rx = [1 0 0; 0 cosd(se_bo.Roll) -sind(se_bo.Roll); 0 sind(se_bo.Roll) cosd(se_bo.Roll)];
    se_Ry = [cosd(se_bo.Dec) 0 sind(se_bo.Dec); 0 1 0; -sind(se_bo.Dec) 0 cosd(se_bo.Dec)];
    se_Rz = [cosd(se_bo.RA) -sind(se_bo.RA) 0; sind(se_bo.RA) cosd(se_bo.RA) 0; 0 0 1];

    % Perform 1st rotation
    se_T.r1 = se_T.r0 * se_Rz;
    if (se_in.Debug_Run == 1); disp('ICRS to Lens: 1st Euler Rotation Performed'); end

    % Perform 2nd rotation
    se_T.r2 = se_T.r1 * se_Ry';
    if (se_in.Debug_Run == 1); disp('ICRS to Lens: 2nd Euler Rotation Performed'); end

    % Perform 3rd rotation
    se_T.r3 = se_T.r2 * se_Rx';
    if (se_in.Debug_Run == 1); disp('ICRS to Lens: 3rd Euler Rotation Performed'); end

    % Display Sucess
    fprintf('ICRS to Lens: Success \n \n');
end

    
