function sm_PP_LIS_output = sm_gnrt_LIS_catalogues(SM_const, write_path)

    %% Check for correct path

    if isstring(write_path) == 0 && ischar(write_path) == 0
        error('DatatypeError: write_path should be a string/character array');    
    elseif isfolder(write_path) == 0
        error('FolderNotFoundError: Invalid directory entered');
    end
    
    %% Read Preprocessed Star Catalogue
    % Read Guide Star Catalogue
    sm_GD_SC = readmatrix(write_path + '\sm_Guide_Star_Catalogue.csv');

    % Read - Preprocessed Star Catalogue (which contains the star pairs)
    sm_PP_SC = readmatrix(write_path + '\sm_Preprocessed_Star_Catalogue.csv');

    % Extract 'Angular distance - in cos(thetha)' from Preprocessed catalogue
    c_AngDst_cos = sm_PP_SC(:,3); 
    
    %% Create Reference Star Catalogue
    % Construct the K-Vector

    sm_M_EPS = SM_const.LIS.CONST_4SM.M_EPS;

    [K_Vec, sm_M, sm_Q, ~] = sm_gnrt_K_Vec(c_AngDst_cos, sm_M_EPS, true); 

    sm_RF_SC = [sm_PP_SC(:, 1:2) , K_Vec]; % Append columns to Reference Star Catalogue

    % Create Table
    sm_RF_SC_table = array2table(sm_RF_SC, 'VariableNames',...
                            {'SSP_ID_1', 'SSP_ID_2', 'K_Vec'});

    % Number of star pairs (Number of rows - Reference catalogue)
    sz = size(sm_RF_SC); % Size of REF_CAT, ~ 4.53 MB
    sm_n_RC = sz(1); 

    % Number of guide stars (Number of rows - Guide catalogue)
    sz = size(sm_GD_SC); % Size of GD_CAT
    sm_n_GC = sz(1); 
    
    % Write Reference Star Catalogue
    writetable(sm_RF_SC_table, write_path + ...
        '\sm_Reference_Star_Catalogue_4SM.csv');
    
    % Store additonal constants
    sm_PP_LIS_output.CONST_4SM.sm_n_GC = sm_n_GC;
    sm_PP_LIS_output.CONST_4SM.sm_n_RC = sm_n_RC;
    sm_PP_LIS_output.CONST_4SM.sm_M = sm_M;
    sm_PP_LIS_output.CONST_4SM.sm_Q = sm_Q;

    % Save star catalogues
    sm_PP_LIS_output.CONST_4SM.sm_GD_SC = readtable(write_path + '\sm_Guide_Star_Catalogue.csv');
    sm_PP_LIS_output.CONST_4SM.sm_RF_SC = sm_RF_SC_table;
end