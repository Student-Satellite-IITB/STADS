function [st_c_img_AngDst, st_c_fe_ID] = st_gnrt_ip_4SM(st_4SM_input)
    % Generates the input for 4-Star Matching Algorithm, using the 
    % body-frame vectors of 4 identified stars from the image
    % Parameters:
    % -----------
    % st_4SM_input: ( (4, 4) - Matrix )
    %   The input to 4-Star Matching Algorithm - four stars identified by
    %   Feature Extraction, along with their body-frame vectors (a
    %   unit-vector represented in $(X,Y,Z)$ format, with the origin at the 
    %   center of the sensor and positive z-axis pointing out of the lens).
    %   The columns of the matrix are as follows:
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}, 3^{rd}, 4^{th}$ columns - $(X,Y,Z)$ unit vector
    % Returns:
    % --------
    % st_c_img_AngDst: ( (6,1) - Matrix )
    %   Has the angular distances ( in $\cos(\theta)$ ) between those of 
    %   four stars in the following order:
    %   $(S_1, S_2) ; (S_1, S_3) ; (S_1, S_4); (S_2, S_3); (S_2, S_4); 
    %   (S_3, S_4);$
    %   <<< NOTE: THE ABOVE ORDER IS IMPORTANT, AND SHOULD BE FOLLOWED! >>>
    % st_c_fe_ID: ( (4,1) - Matrix )
    %   Has the Feature Extraction IDs of stars that are used to generate
    %   st_c_img_AngDst, in the following order:
    %   $[S_1 ; S_2 ; S_3 ; S_4]$
    
    %% Code

    st_c_img_AngDst = zeros(6,1); % Initialize variable
    k_idx = 1; % Initialize (k - index)

    for i_idx = 1:4    
        for j_idx = i_idx:4

            if i_idx ~= j_idx
                %% Calculate Angular Distance
                
                % Extract unit vectors
                si = st_4SM_input(i_idx, 2:4); 
                sj = st_4SM_input(j_idx, 2:4);
                
                % Dot product of the two body-frame vectors
                str_AngDst = abs(dot(si, sj)); 
                
                % Append angular distance value
                st_c_img_AngDst(k_idx) = str_AngDst; 
                k_idx = k_idx + 1; % Update (k - index)
            end
        end
    end
    
    st_c_fe_ID = st_4SM_input(1:4, 1); % Store Feature Extraction IDs

end