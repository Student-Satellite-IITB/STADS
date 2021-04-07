function [sis_photoelec_prof] = sis_sm_main(sis_photon_prof,sis_input)
    %%%%%% Doubt about the BN ?
    sis_photon_prof = sis_photon_prof + sis_input.lls.BN;
    sis_photoelec_prof = sis_photon_prof .* sis_input.lls.Eta;
    if (sis_input.gen.Debug_Run == 1); fprintf('Sensor Model: Success \n \n'); end
end

