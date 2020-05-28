function [N_FOV_str, FOV_SC] = st_gnrt_rand_FOV_SC(st_SSP_SC, FOV_Circular, Magnitude_Limit)
    % Generates the FOV Star Catalogue, which consists of the stars
    % present in a random FOV, with a specified circular FOV and limiting
    % magnitude
    % Parameters:
    % -----------
    % st_SSP_SC
    % FOV_Circular
    % Magnitude_Limit
    % Returns:
    % --------
    % N_FOV_str
    % FOV_SC
    %% Celestial Coordinates - Boresight Vector
    RA = rand(1) * 360;
    DE = (rand(1)*180) - 90;
    v_boresight = [RA, DE];

    [N_FOV_str, FOV_SC] = st_gnrt_FOV_SC(st_SSP_SC, v_boresight, FOV_Circular, Magnitude_Limit);
end