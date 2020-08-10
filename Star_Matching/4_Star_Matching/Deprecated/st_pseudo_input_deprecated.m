fe_n_str = 20; % Number of stars idetified by feature extraction

centroids = rand(fe_n_str,2); % Generate pseudo-centroids

idx = transpose(1:fe_n_str); % Index of identified stars

fe_output = [idx, centroids]; % Append columns

save('.\Star_Matching\4_Star_Matching\Input\st_input.mat', ...
'fe_output', 'fe_n_str');

disp('Done: Generate Pseudo-Input');