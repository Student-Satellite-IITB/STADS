function se_T = se_PR_2b_ICRS2Lens(se_T, se_bo, se_in)
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
    %   - Variable Name Added - r [(n, 3)]
    
    % =====
    % Code:
    % =====
    
    % Define The Rotation Matrix
    se_euler_rotation = angle2dcm(deg2rad(se_bo.RA), deg2rad(-se_bo.Dec), deg2rad(-se_bo.Roll), 'ZYX')';

    % Perform the Rotation
    se_T.r = se_T.r0 * se_euler_rotation;
    if (se_in.Debug_Run == 1); disp('Celestial to Lens: Euler Rotation Performed'); end

    % Display Sucess
    fprintf('Celestial to Lens: Success \n \n');
end



    
