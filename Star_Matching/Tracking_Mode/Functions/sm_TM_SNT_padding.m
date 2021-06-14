function [sm_TM_SNT] = sm_TM_SNT_padding(sm_TM_SNT_vec, sm_TM_SNT)
    %% Appends the star neighbours of one star to the Star Neighbourhood Matrix with zero padding
    % Parameters:
    % ----------------
    % sm_TM_SNT_vec : (1, N) - Vector
    %    The Star Neighbours of a single star. 
    % sm_TM_SNT : (M, N) - Matrix
    %    The Star Neighbourhood Table (incomplete)

    % Returns:
    % --------------
    % sm_TM_SNT : (5060, N) - Matrix
    %    The Star Neighbourhood Table (complete)

    %% Calculate number of rows and columns of input matrices. 
    n_row = size(sm_TM_SNT_vec, 1);
    n_col = size(sm_TM_SNT_vec, 2);
    n_row_mat = size(sm_TM_SNT, 1);
    n_col_mat = size(sm_TM_SNT, 2);

    %% Add zero padding to either st_TM_SNT or st_TM_SNT_star_ID based on st_TM_SNT_c_n and st_TM_SNT_star_ID_c_n
    if n_col_mat < n_col
        sm_TM_SNT = [sm_TM_SNT , zeros(n_row_mat, n_col - n_col_mat)];
        
    elseif n_col_mat > n_col
        sm_TM_SNT_vec = [sm_TM_SNT_vec , zeros(n_row, n_col_mat - n_col)]; 
        
    end
    
    sm_TM_SNT = [sm_TM_SNT ; sm_TM_SNT_vec];
end
