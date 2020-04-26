function [c_img_AngDst, c_fe_IDs] = sm_gnrt_ip_4_str_mtch(sm_bi, n_fe_strs)
    % Generates the input for 4-Star Matching Algorithm, using the 
    % body-frame vectors of the idetified stars from the image
    % Parameters:
    % -----------
    % sm_bi: (N,4) - Matrix
    %   The body frame vectors of the identified stars
    % n_fe_strs: (Integer)
    %   The number of stars identified by feature extraction
    %   <<< NOTE: (n_fe_strs) >= 4 !! >>>
    % Returns:
    % --------
    % c_img_AngDst: (6,1) - Matrix
    %   Has the angular distances ( in cos(theta) ) between those of four
    %   stars in the following order:
    %   (S1, S2) ; (S1, S3) ; (S1, S4); (S2, S3); (S2, S4); (S3, S4);
    %   <<< NOTE: THE ABOVE ORDER IS IMPORTANT, AND SHOULD BE FOLLOWED! >>>
    % c_fe_IDs: (4,1) - Matrix
    %   Has the Feature Extraction IDs of stars that are used to generate
    %   c_img_AngDst, in the following order:
    %   [S1 ; S2 ; S3 ; S4]
    
    %% Code

    if n_fe_strs < 4
        %% Check length of sm_BF_vec
        error('Minimum four stars required: %s', n_fe_strs);
    end

    c_img_AngDst = zeros(6,1); % Initialize variable
    k_idx = 1; % Initialize (k - index)

    for i_idx = 1:4    
        for j_idx = i_idx:4

            if i_idx ~= j_idx
                %% Calculate Angular Distance
                
                % Extract unit vectors
                si = sm_bi(i_idx, 2:4); 
                sj = sm_bi(j_idx, 2:4);
                
                % Dot product of the two body-frame vectors
                str_AngDst = dot(si, sj); 
                
                % Append angular distance value
                c_img_AngDst(k_idx) = str_AngDst; 
                k_idx = k_idx + 1; % Update (k - index)
            end
        end
    end
    
    c_fe_IDs = sm_bi(1:4, 1); % Store Feature Extraction IDs

end