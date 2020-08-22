function se_T = se_PR_1_Trim2FOV(se_T, se_bo, se_op, se_in) 
    % Trims the se_T to within FOV.
    % This function trims the se_SKY2000 Catalogue to the Field of View of
    % the sensor. It takes the SKY2000 Catalogue preprocessed for Sensor
    % Model, removes all stars beyond the Field of View and returns the
    % modified Catalogue.
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
    %   - Variable Name -  "se_r0".
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
    % se_T_Updated : (Table (n, m_1 + 2))
    %   The trimmed Table. 
    %   Comments:
    %   - Parameters Added - se_r0 (n, 3), Angular_Distance (n, 1)
    %   - The rows containing stars outside FOV are removed
    
    % =====
    % Code:
    % =====
    
    % Add the broadcasted boresight input to the table
    se_T = [se_T repmat(se_bo(1,4), size(se_T.RA))];

    % Add the Angular_Distance Column using the function se_ang_dist
    se_T = [se_T rowfun(@se_ang_dist, se_T, 'InputVariables', {'se_r0' 'r0'}, 'OutputVariableName', 'Angular_Distance')];
    se_T = removevars(se_T, {'se_r0'});
    if (se_in.Debug_Run == 1); disp('Trim to FOV: Angular Distances Added'); end

    % Retain only the stars with Angular Distance less than FOV
    se_T = se_T(se_T.Angular_Distance <= se_op.FOV.Circular / 2, :);
    if (se_in.Debug_Run == 1); disp('Trim to FOV: Trimmed to FOV'); end

    
    % Display Sucess
    fprintf('Trim to FOV: Success \n \n');
end

function ang_dist = se_ang_dist(se_r0, r0)
    % Calculates the Angular Distance
    % This function calculates the Angular Distance between 2 vectors.
    %
    % ----------
    % Reference:
    % ----------
    %
    % https://in.mathworks.com/matlabcentral/answers/101590-how-can-i-determine-the-angle-between-two-vectors-in-matlab
    %   This is the most stable implementation for solving for theta.
    %     The following implementation is incorrect for small angles -
    %       CosTheta = max(min(dot(u,v)/(norm(u)*norm(v)),1,-1);
    %       ThetaInDegrees = real(acosd(CosTheta));
    % https://in.mathworks.com/matlabcentral/answers/16243-angle-between-two-vectors-in-3d
    %
    % Proof -
    % || a x b || = ||a|| ||b|| sin(theta)
    %  ( a . b )  = ||a|| ||b|| cos(theta)
    % So, tan(theta) = norm(cross(a, b)) / dot(a, b)
    %
    % -----------
    % Parameters:
    % -----------
    %
    % se_r0: (Array (3,1))
    %   The reference unit vector.
    %   Comments: 
    %   - Format - (X, Y, Z)
    %   
    % r0: (Array (3,1))
    %   The other unit vector.
    %   Comments: 
    %   - Format - (X, Y, Z)
    %
    % --------
    % Returns:
    % --------
    %
    % ang_dist : (Double)
    %   The Angular Distance (In Degrees)
    
    % =====
    % Code:
    % =====
    
    ang_dist = rad2deg(atan2(norm(cross(se_r0,r0)), dot(se_r0,r0)));
end

