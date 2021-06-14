function sm_gnrt_catalogues(SM_const, write_path)

    %% Check for correct path

    if isstring(write_path) == 0 && ischar(write_path) == 0
        error('DatatypeError: write_path should be a string/character array');    
    elseif isfolder(write_path) == 0
        error('FolderNotFoundError: Invalid directory entered');
    end
    
    %% Read SSP Star Catalogue
    SSP_SC = readtable('./Catalogue/SKY2000/Catalogues/SSP_Star_Catalogue.csv');

    %% Create Guide Star Catalogue
    % Extract stars brighter than Limiting Magnitude
    MAG_LIMIT = SM_const.MAG_LIMIT;
    cond = SSP_SC.Vmag <= MAG_LIMIT; % Set up condition
    tmp = SSP_SC(cond , :); 

    % Generate cartesian unit vectors
    unit_vect = rowfun(@ca_RA_DE_2_CartVect, tmp, 'InputVariables', ...
        {'RA', 'DE'}, 'OutputVariableNames', {'X', 'Y', 'Z'});
    sm_GD_SC = [tmp(:, 1), unit_vect]; % Append Columns
    sm_SSP = [tmp, unit_vect]; % Append Columns
   
    % Write Table
    writetable(sm_GD_SC, write_path + '\sm_Guide_Star_Catalogue.csv');
    writetable(sm_SSP, write_path + '\sm_SSP_Star_Catalogue.csv');
    
    %% Create Preprocessed Star Catalogue
    sm_GD_SC = readmatrix(write_path + '\sm_Guide_Star_Catalogue.csv');
    sz = size(sm_GD_SC); % ~ 0.12 MB - Guide Catalogue
    N = sz(1); % Number of stars in Guide Catalogue

    len = (N * (N-1))/2; % N C 2 - number of possible combinations
    sm_PP_SC = zeros(len,4);

    k_idx = 1; % Counter Variable
    % Outer for-loop iterates from i = 1:(N-1), while inner for-loop iterates
    % over j = (i+1):N
    % This ensures that for each star in the catalogue, the angular distance
    % w.r.t every other star is accounted for, and ignoring the reduntant case
    % of (i = j)
    for i_idx = 1 : (N-1)
        v_i = sm_GD_SC(i_idx, 2:4); % (i-th) unit vector

        for j_idx = (i_idx + 1) : N
            v_j = sm_GD_SC(j_idx, 2:4); %$ (j-th) unit vector

            res1 = dot(v_i, v_j); % Dot Product
            %res2 = acosd(res1); % Cos inverse of dot product - in degrees
            res2 = atan2d( norm(cross(v_i, v_j)), res1); % Angle between the two vectors
            
            k_rw = [i_idx, j_idx, res1, res2]; % (k-th) row of Preprocessed Star Catalogue        
            sm_PP_SC(k_idx, :) = k_rw; % Update (k-th) row of Preprocessed Star Catalogue

            k_idx = k_idx + 1; % Update k-index variable
        end 
    end
    
    % Ignore Star-Pairs that lie outside the Field-of-View
    FOV_CIRCULAR = SM_const.FOV_CIRCULAR; % Circular FOV - in degrees
    FOV_CIRCULAR = FOV_CIRCULAR * (1 + 0.05); % Account for 5% safety factor

    tmp = sm_PP_SC( sm_PP_SC(:, 4) <= FOV_CIRCULAR , : ); % Ignore star-pairs with ang_dst greater than FOV_CIRCULAR

    % Create Table
    sm_PP_SC_table = array2table(tmp, 'VariableNames', {'SSP_ID_1', 'SSP_ID_2', 'AngDst_cos', 'AngDst_deg'});

    sm_PP_SC_table = sortrows(sm_PP_SC_table,'AngDst_cos','ascend'); % Sort based on AngDst_cos column
  
    % Write Table
    writetable(sm_PP_SC_table, write_path + '\sm_Preprocessed_Star_Catalogue.csv');
end
