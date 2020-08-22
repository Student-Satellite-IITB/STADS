function [fe_n_str, fe_output] = st_gnrt_centroids(st_N_FOV_str,...
    st_FOV_Catalogue, Focal_Length, st_add_noise)
    % Generates the centroids of stars in the image frame using the
    % celestial coordinates
    % Parameters:
    % -----------
    % st_N_FOV_str
    % st_FOV_Catalogue
    % Focal_Length
    % st_add_noise
    % Returns:
    % --------
    % fe_n_str
    % fe_output
    %% Code
    fe_n_str = st_N_FOV_str;
    fe_output = zeros(fe_n_str, 3);

    fe_output(:,1) = table2array(st_FOV_Catalogue(:, 1));
    %%
    for idx = 1:fe_n_str
        unit_vector = table2array(st_FOV_Catalogue(idx, [5, 6, 7]));
        X = unit_vector(1); Y = unit_vector(2); Z = unit_vector(3);

        %%
        r = Focal_Length/Z;
        x = X * r;
        y = Y * r;
        
        noise = (rand(1,2)*2 - 1)*st_add_noise;
        
        fe_output(idx, [2,3]) = [x,y] + noise;   
    end
end
