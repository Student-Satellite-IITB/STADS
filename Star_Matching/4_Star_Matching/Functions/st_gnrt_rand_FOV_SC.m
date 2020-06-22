function [st_N_FOV_str, st_FOV_SC] = st_gnrt_rand_FOV_SC(st_SSP_SC, st_consts_opt)
    % Generates the FOV Star Catalogue, which consists of the stars
    % present in a random FOV, with a specified circular FOV and limiting
    % magnitude
    % Parameters:
    % -----------
    % st_SSP_SC
    % st_consts_opt
    % Returns:
    % --------
    % st_N_FOV_str
    % st_FOV_SC
    %% Celestial Coordinates - Boresight Vector
    RA = rand(1) * 360;
    DE = (rand(1)*180) - 90;
    st_v_boresight = [RA, DE];
    %%
    [st_N_FOV_str, st_FOV_SC] = st_gnrt_FOV_SC(st_SSP_SC, st_v_boresight, st_consts_opt);
end