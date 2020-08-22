function [st_N_FOV_str, st_FOV_SC] = st_gnrt_FOV_SC (st_SSP_SC, st_v_boresight, st_consts_opt)
    % Returns the truncated SPP Star Catalogue that consists of only
    % those stars that lie within the circular Field-Of-View from the 
    % boresight vector, and have an apparent magnitude less than that of
    % the Magnitude Limit constant
    % Parameters:
    % -----------
    % st_SSP_SC: ( (:, 10) - Table )
    %   The SSP Star Catalogue which contains the following columns:
    %   [SSP_ID, SKY2000_ID, RA, DE, Vmag, pmRA, pmDE, X, Y, Z]
    % st_v_boresight: ( (2, 1) - Matrix )
    %   The boresight vector which contains the following:
    %   [RA, DE] - in degrees
    % st_consts_opt
    % Returns:
    % --------
    % st_N_FOV_str: (Integer)
    %   Number of stars present within the given Field-Of-View
    % st_FOV_SC: ( (N_FOV_str, 8) - Table )
    %   The truncated SPP Star Catalogue that consists of only those stars 
    %   that lie within the circular Field-Of-View. The columns of the
    %   table are as follows:
    %   [SSP_ID, RA, DE, Vmag, X, Y, Z, AngDst_deg]
    %   where AngDst_deg corresponds to the angular distance between the
    %   boresight vector and the star in terms of dergrees
    %% Code
    
    % Extract stars brighter than Limiting Magnitude
    cond = st_SSP_SC.Vmag <= st_consts_opt.Magnitude_Limit; % Set up condition
    tmp_SSP_SC = st_SSP_SC(cond , :);
    
    % Number of stars in tmp_SSP_SC (= Number of rows)
    sz = size(tmp_SSP_SC);
    N = sz(1);
    
    % Convert Boresight vector into a Cartesian Unit Vector
    [X, Y, Z] = ca_RA_DE_2_CartVect(st_v_boresight(1), st_v_boresight(2));

    % Append Cartesian Unit Vector to tmp_SSP_SSC
    boresight_X = array2table(ones(N, 1)*X, 'VariableNames', {'Boresight_X'});
    boresight_Y = array2table(ones(N, 1)*Y, 'VariableNames', {'Boresight_Y'});
    boresight_Z = array2table(ones(N, 1)*Z, 'VariableNames', {'Boresight_Z'});
    tmp_SSP_SC = [tmp_SSP_SC, boresight_X, boresight_Y, boresight_Z];
  
    % Calculate the Angular distance between the boresight vector and all
    % the stars
    AngDst_deg = rowfun(@st_calc_AngDst_deg, tmp_SSP_SC, 'InputVariables', ...
        {'X', 'Y', 'Z', 'Boresight_X', 'Boresight_Y', 'Boresight_Z'}, ...
        'OutputVariableNames', {'AngDst_deg'});
    tmp_SSP_SC = [tmp_SSP_SC, AngDst_deg];

    % Extract stars which subtend an angular distance which is less than
    % the circular Field-Of-View
    cond = tmp_SSP_SC.AngDst_deg <= st_consts_opt.FOV_Circular / 2; % Set up condition
    
    % Generate FOV_SC
    st_FOV_SC = tmp_SSP_SC(cond, [1, 3:5, 8:10, 14]);
    st_FOV_SC = sortrows(st_FOV_SC,'AngDst_deg','ascend');
    
    % Calculate nuumber of stars within the Field-Of-View
    sz = size(st_FOV_SC);
    st_N_FOV_str = sz(1);
end