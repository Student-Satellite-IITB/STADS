function sis_Pixel_Val_Mat = sis_nm_main(sis_photoelec_prof,sis_input)

% initializing the constant values from the constant file for ease of
% readability
    PRNU = sis_input.noise.PRNU;
    DTN = sis_input.noise.DTN;
    PLS = sis_input.noise.PLS;
    Area_1 = sis_input.noise.Area_SN;
    Area_2 = sis_input.noise.Area_MN;
    t_exposure = sis_input.lls.Exposure_Time;
    t_readout = sis_input.noise.t_readout;
    Gain = sis_input.lls.Gain;
    DS = sis_input.noise.DS;
    PSNL = sis_input.noise.PSNL;
    
    
    %step 1: adding all the means of the noises
    sis_photoelec_prof= sis_photoelec_prof + (PRNU + DTN + (DS * t_exposure) ) * ones(size(sis_photoelec_prof));
    %PSNL can be added or subtracted too
    %sis_photoelec_prof =sis_photoelec_prof + 2*randn(PSNL*t_readout)-(PSNL*t_readout);
    sis_photoelec_prof =sis_photoelec_prof - (randn(size(sis_photoelec_prof))*PSNL*t_readout);
  
    % Add the PLS
    sis_photoelec_prof =sis_photoelec_prof*(1+ 1/PLS*(Area_1/Area_2));
    %Applying a poisson distribution on the whole f the noises
    sis_photoelec_prof=poissrnd(sis_photoelec_prof,size(sis_photoelec_prof));
    %Multiplying by the Gain to get the matrix of pixel values for each
    %pixel
    sis_Pixel_Val_Mat=round(sis_photoelec_prof*Gain);
    % As the Pixel Values can't be outside the range [0, 1023]
    sis_Pixel_Val_Mat = max(sis_Pixel_Val_Mat, 0);
    sis_Pixel_Val_Mat = min(sis_Pixel_Val_Mat, 1023);
    
    
end