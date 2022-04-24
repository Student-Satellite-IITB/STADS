function sm_bi = sm_gnrt_bi(fe_output, SM_const)
    % Generates the body-frame vectors of the stars from the centroids
    % identified through means of Feature Extraction
    % Reference:
    % --------
    % Appendix B -  Erlank, Alexander O.. “Development of CubeStar : a
    % CubeSat-compatible star tracker.” (2013).
    % Parameters:
    % -----------
    % fe_output: -----
    % SIS_const: -----
    % Returns:
    % --------
    % sm_bi: ( (N, 4) - Matrix ) -----------------
    %   Generates the body-frame vectors for all the stars identified by
    %   Feature Extraction using the centroids. The body-frame vectors are
    %   unit-vectors represented in $(X,Y,Z)$ format, with the origin at the 
    %   center of the sensor and positive z-axis pointing out of the lens.
    %   The columns of matrix are as follows:
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}, 3^{rd}, 4^{th}$ columns - $(X,Y,Z)$ unit vector

    %% Code

    sm_bi = zeros(fe_output.N, 4); % Initialize input variable    
    for i_idx = 1:fe_output.N
        %% Calculate Body-Frame Vectors

        id = fe_output.centroids.FE_ID(i_idx); % ID of identified star in fe_output
        
        % Extract (x,y) coordinates
        x = fe_output.centroids.X(i_idx); 

        y = fe_output.centroids.Y(i_idx);

        
        bi = [x, y, SM_const.FOCAL_LENGTH]; % Initialize Body-frame vector

        bi = bi / norm(bi); % Normalize Body-frame vector


        tmp = [id, bi]; % Initialize (i-th) row of st_bi

        sm_bi(i_idx, :) = tmp; % Append row

    end
    
    % Cycliclically shift body-frame vectors to get proper axes
    sm_bi(:, 2:4) = circshift(sm_bi(:, 2:4), [0, 1]);
    sm_bi = array2table(sm_bi, 'VariableNames', {'FE_ID', 'X', 'Y', 'Z'});
    sm_bi.Properties.VariableUnits = {'', 'mm', 'mm', 'mm'};
    sm_bi.Properties.VariableDescriptions = {
        'Feature Extraction - Star ID', 'Body-frame vector: X component',
        'Body-frame vector: Y component', 'Body-frame vector: Z component'
    };
end