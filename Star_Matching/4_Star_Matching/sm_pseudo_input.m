n_fe_strs = 20; % Number of stars idetified by feature extraction
centroids = rand(n_fe_strs,2); % Generate pseudo-centroids

idx = transpose(1:n_fe_strs); % Index of identified stars

fe_output = [idx, centroids]; % Append columns

save('.\Star_Matching\4_Star_Matching\Input\sm_input.mat', ...
'fe_output', 'n_fe_strs');

disp('Done: Generate Pseudo-Input');