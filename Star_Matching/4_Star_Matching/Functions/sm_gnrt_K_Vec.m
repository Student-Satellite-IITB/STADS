function [K_Vec, sm_M, sm_Q, I_Vec] = sm_gnrt_K_Vec (c_y, M_EPS, is_sorted)
    % Generates the K-Vector for a given array 
    % Reference:
    % ---------- 
    % The original k-vector searching technique - Mortari, D. & Neta, Beny.
    % (2000). k-Vector Range Searching Technique.105. 
    % Paramaters:
    % -----------
    % c_y: column array
    %     The array for which k-vector has to be generated
    % M_EPS: double
    %     The value of machine epsilon
    % is_sorted : boolean
    %     If true - implies the array is sorted
    % Returns:
    % --------
    % K_Vec: column vector
    %     The K-vector of the given array
    % sm_M: double
    %     Slope of Z-Vector line
    % sm_Q: double
    %     Coefficient of Z-Vector line    
    % I_Vec: column vector
    %     The integer vector associated with sorting    
    %% Create S & I vectors
    N = length(c_y); % Length of given array
    if ( is_sorted == false )
        [S_VEC, I_Vec] = sort(c_y);
    elseif ( is_sorted == true )
        S_VEC = c_y;
        I_Vec = transpose( 1:N );
    end
   
    %% Calculate constants
    y_min = S_VEC(1); y_max = S_VEC(N); % Store min & max values
       
    sm_M = (y_max - y_min + 2*M_EPS)/(N-1); % Calculate slope of Z-Vector line
    sm_Q = y_min - sm_M - M_EPS; % Calculate coefficient of Z-Vector line
    
    %% Initialize K-vector
    K_Vec = zeros(N, 1); % Column vector    
    K_Vec(1) = 0; K_Vec(N) = N; % Set boundary values of K-Vector
    
    %% Generate Z-Vector
    Z_VEC = transpose( 1:N ); % Initialize Z-Vector
    Z_VEC = sm_M*Z_VEC + sm_Q; % Calculate Z-Vector
    
    %% Generate K-Vector
    start = 1; % The starting index for the nested for-loop
    for idx = 2 : N-1
        for jdx = start:N-1
            
            % Set up conditions
            cond1 = S_VEC(jdx) <= Z_VEC(idx); % Check first inequality
            cond2 = Z_VEC(idx) > S_VEC(jdx + 1); % Check second inequality
            if ( (cond1 == 1) && (cond2 == 0) )
                K_Vec(idx) = jdx; % Store K-Vector Value
                start = jdx; % Update starting index for nested for-loop
                break
            end
        end
    end
end