function [sm_c_img_AngDst, sm_c_fe_ID] = sm_gnrt_ip_4SM(sm_4SM_input)
    % Generates the input for 4-Star Matching Algorithm, using the 
    % body-frame vectors of 4 identified stars from the image
    % Parameters:
    % -----------
    % sm_4SM_input: ( (4, 4) - Table)
    % Returns:
    % --------
    % sm_c_img_AngDst: Table
    %   Has the angular distances ( in $\cos(\theta)$ ) between those of 
    %   four stars in the following order:
    %   $(S_1, S_2) ; (S_1, S_3) ; (S_1, S_4); (S_2, S_3); (S_2, S_4); 
    %   (S_3, S_4);$
    %   <<< NOTE: THE ABOVE ORDER IS IMPORTANT, AND SHOULD BE FOLLOWED! >>>
    % sm_c_fe_ID: ( (4,1) - Table )
    %   Has the Feature Extraction IDs of stars that are used to generate
    %   st_c_img_AngDst, in the following order:
    %   $[S_1 ; S_2 ; S_3 ; S_4]$
    
    %% Code

    sm_c_img_AngDst = zeros(6,1); % Initialize variable
    k_idx = 1; % Initialize (k - index)
    for i_idx = 1:4    
        for j_idx = i_idx:4

            if i_idx ~= j_idx
                %% Calculate Angular Distance
                
                % Extract unit vectors
                si = [sm_4SM_input.X(i_idx), sm_4SM_input.Y(i_idx), sm_4SM_input.Z(i_idx)];
                sj = [sm_4SM_input.X(j_idx), sm_4SM_input.Y(j_idx), sm_4SM_input.Z(j_idx)];
                
                % Dot product of the two body-frame vectors
                str_AngDst = abs(dot(si, sj))/(norm(si)*norm(sj)); 
                
                % Append angular distance value
                sm_c_img_AngDst(k_idx) = str_AngDst; 
                k_idx = k_idx + 1; % Update (k - index)
            end
        end
    end
    sm_c_img_AngDst = array2table(sm_c_img_AngDst, 'VariableNames', {'cos_theta'});    
    sm_c_fe_ID = sm_4SM_input(1:4, 1); % Store Feature Extraction IDs

end