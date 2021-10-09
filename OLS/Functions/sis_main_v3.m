function sis_output = sis_main_v3(sis_input, sis_T,i)
% Main function that runs the Star Image Simulation block
% Here i represent the value of iteration, i.e. the number of image being
% generated

%% Code
    %% Light, Lens and Sensor Model
    sis_photoelec_prof = zeros(sis_input.lls.CMOS.Width_Pix,sis_input.lls.CMOS.Length_Pix,sis_input.gen.N_sub_im); %%%%%%%%
    %disp(strcat('Simulating the--',num2str(i),'--th image..'))
    for j = 1:sis_input.gen.N_sub_im
        %disp(strcat('Simulating the--',num2str(j),'--th sub-image..'))
        
        % Light Model
        sis_trim_T = sis_light_main(sis_T,sis_input.bo(j,:,i),sis_input);
        
        % Lens Model
        % Take care of the output
        [sis_photon_prof,sis_trim_T] = sis_lens_main(sis_trim_T, sis_input);
        
        % Sensor Model
        sis_photoelec_prof( :, :, j) = sis_sm_main(sis_photon_prof,sis_input);
        %disp(strcat('Simulation of--',num2str(j),'--th sub-image Completed'))
    end
    
    % Adding the sub-images
    sis_photoelec_prof = sum(sis_photoelec_prof,3);

    %% Noice Model
    sis_Pixel_Val_Mat = sis_nm_main(sis_photoelec_prof,sis_input);
    %disp(strcat('Simulation of--',num2str(i),'--th image Completed'))

    %% Ephemeris Model

   

    %% Save Output
    sis_output.attitude = sis_input.bo(1,:,i);
    sis_output.image = sis_Pixel_Val_Mat;
    sis_output.data_table = sis_trim_T;    
    sis_output.status = "Done";        
        
 
end
