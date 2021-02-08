% This is the main script to run Star Image Simulation
%% Load Constants and Preprocessing

% Creating input file
sis_input_file;
% This also loads sis_input object

%Preprocessing
sis_PP_main;
% This also loads sis_T(<num of stars>,[SSP_ID,RA,Dec,Magnitude,pm_RA,pm_Dec,r0_1,r0_2,r0_3]) object

%% Dynamics Model
sis_input = sis_dm_main(sis_input);

for i = 1:sis_input.gen.N_bo
    %% Light, Lens and Sensor Model
    sis_photoelec_prof = zeros(sis_input.lls.CMOS.Width_Pix,sis_input.lls.CMOS.Length_Pix,sis_input.gen.N_sub_im); %%%%%%%%

    for j = 1:sis_input.gen.N_sub_im
        % Light Model
        sis_trim_T = sis_light_main(sis_T,sis_input.bo(j,:,i),sis_input);
        % Lens Model
        % Take case of the output
        sis_photon_prof = sis_lens_main(sis_trim_T, sis_input);
        % Sensor Model
        sis_photoelec_prof( :, :, j) = sis_sm_main(sis_photon_profile,sis_input);
    end
    
    % Adding the sub-images
    sis_photoelec_prof = sum(sis_photoelec_prof,3);

    %% Noice Model
    sis_noise(sis_photoelec_prof,sis_input);

    %% Ephemeris Model

    
    
end
