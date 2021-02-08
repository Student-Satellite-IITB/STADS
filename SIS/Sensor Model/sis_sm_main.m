function [sis_photoelec_prof] = sis_sm_main(sis_photon_prof,sis_input)
    %%%%%% Doubt about the BN ?
    sis_photon_prof = sis_photon_prof + sis_input.lls.BN;
    sis_photoelec_prof = sis_photon_prof .* sis_input.lls.Eta;
end

