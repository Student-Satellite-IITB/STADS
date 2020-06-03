function [K_Vec, st_M, st_Q, I_Vec] = st_gnrt_K_Vec (c_y, st_M_EPS, is_sorted)
    % Generates the K-Vector for a given array 
    % Reference:
    % ---------- 
    % The original k-vector searching technique - Mortari, D. & Neta, Beny.
    % (2000). k-Vector Range Searching Technique.105. 
    % Paramaters:
    % -----------
    % c_y: (N, 1) - Matrix
    %     The array for which k-vector has to be generated
    % st_M_EPS: Float
    %     The machine epsilon of the platform where the algorithm will be executed
    % is_sorted : boolean
    %     If true - implies the array is sorted
    % Returns:
    % --------
    % K_Vec: (N, 1) - Matrix
    %     The K-vector of the given array
    % st_M: double
    %     The slope of the Z-vector line
    % st_Q: double
    %     The y-intercept of the Z-vector line  
    % I_Vec: (N, 1) - Matrix
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
       
    st_M = (y_max - y_min + 2*st_M_EPS)/(N-1); % Calculate slope of Z-Vector line
    st_Q = y_min - st_M - st_M_EPS; % Calculate coefficient of Z-Vector line
    
    %% Initialize K-vector
    K_Vec = zeros(N, 1); % Column vector    
    K_Vec(1) = 0; K_Vec(N) = N; % Set boundary values of K-Vector
    
    %% Generate Z-Vector
    Z_VEC = transpose( 1:N ); % Initialize Z-Vector
    Z_VEC = st_M*Z_VEC + st_Q; % Calculate Z-Vector
    
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