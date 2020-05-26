function [st_op_bi, st_op_ri] = st_gnrt_op_4SM_v2(st_Match, st_GD_SC)
    % Evaluates the Match Matrix, to generate the output in the 
    % format required by Estimation - Body-frame vectors, and 
    % Inertial-frame vectors of the matched stars
    % Parameters:
    % -----------
    % st_Match : ( (st_N_Match, 5) - Matrix )
    %   This matrix contains the entries of the stars that have been 
    %   matched so far. The columns are as follows:
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}, 3^{rd}, 4^{th}$ columns - $(X, Y, Z)$ unit body-frame 
    %   vector
    %   $5^{th}$ column - The matched SSP-ID    
    % st_GD_SC: ( (st_n_GC, 4) - Matrix )
    %   The Guide catalogue, which has the following columns:
    %   SSP_ID , X , Y , Z
    % Returns:
    % --------
    % st_op_bi: ( (st_N_Match, 4) - Matrix )
    %   The body-frame vectors $b_i$ of the image stars that have been 
    %   matched through Star-Matching. The columns include:
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}, 3^{rd}, 4^{th}$ columns - $(X, Y, Z)$ unit body-frame 
    %   vector 
    % st_op_ri: ( (st_N_Match, 4) - Matrix )
    %   The corresponding inertial-frame vectors $r_i$ of the matched stars 
    %   obtained from the Guide Star Catalogue. The columns include:
    %   $1^{st}$ column - Corresponding SSP-ID of the matched star
    %   $2^{nd}, 3^{rd}, 4^{th}$ columns - $(X, Y, Z)$ unit inertial-frame 
    %   vector
    %   <<< NOTE: $(N)$ in both cases should be equal! The $i^{th}$ body-frame
    %   and the $i^{th}$ inertial-frame vector should correspond to the same
    %   star >>
    %% Code
    st_op_bi = st_Match(:, 1:4); % Body-frame vectors
    
    st_SSP_ID = st_Match(:, 5); % SSP-IDs of matched stars
    
    st_op_ri = st_GD_SC(st_SSP_ID, :); % Inertial-frame vectors
end