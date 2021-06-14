% This is the main script to run Star Image Simulation
%% Load Constants and Preprocessing

% Creating input file
sis_gnrt_input_file;
load('./SIS/Input and Constants/sis_input', "sis_input");
% This also loads sis_input object

%Preprocessing
sis_PreProc_main;
load('./SIS/Preprocessing/sis_SKY2000.mat', 'sis_T');
% This also loads sis_T(<num of stars>,[SSP_ID,RA,Dec,Magnitude,pm_RA,pm_Dec,r0_1,r0_2,r0_3]) object

%% Dynamics Model
sis_input = sis_dm_main(sis_input);


for i = 1:3 %sis_input.gen.N_bo %%%%%%
    %% Light, Lens and Sensor Model
    sis_photoelec_prof = zeros(sis_input.lls.CMOS.Width_Pix,sis_input.lls.CMOS.Length_Pix,sis_input.gen.N_sub_im); %%%%%%%%
    disp(strcat('Simulating the--',num2str(i),'--th image..'))
    for j = 1:sis_input.gen.N_sub_im
        disp(strcat('Simulating the--',num2str(j),'--th sub-image..'))
        % Light Model
        sis_trim_T = sis_light_main(sis_T,sis_input.bo(j,:,i),sis_input);
        % Lens Model
        % Take case of the output
        [sis_photon_prof,sis_trim_T] = sis_lens_main(sis_trim_T, sis_input);
        % Sensor Model
        sis_photoelec_prof( :, :, j) = sis_sm_main(sis_photon_prof,sis_input);
        disp(strcat('Simulation of--',num2str(j),'--th sub-image Completed'))
    end
    
    % Adding the sub-images
    sis_photoelec_prof = sum(sis_photoelec_prof,3);

    %% Noice Model
    sis_Pixel_Val_Mat = sis_nm_main(sis_photoelec_prof,sis_input);
    disp(strcat('Simulation of--',num2str(i),'--th image Completed'))

    %% Ephemeris Model

    %% Saving
    mkdir(sprintf('./SIS/Output/Simulation_%s/Image_%s', string(sis_input.gen.sim_N), string(i)));
    save(sprintf('./SIS/Output/Simulation_%s/Image_%s/sis_Image_%s.mat', string(sis_input.gen.sim_N), string(i), string(i)), "sis_Pixel_Val_Mat");
    save(sprintf('./SIS/Output/Simulation_%s/Image_%s/sis_Table_%s.mat', string(sis_input.gen.sim_N), string(i), string(i)), "sis_trim_T");
    imwrite(sis_Pixel_Val_Mat/20, sprintf('./SIS/Output/Simulation_%s/Image_%s/Image_%s.png', string(sis_input.gen.sim_N), string(i), string(i)));
    
end
