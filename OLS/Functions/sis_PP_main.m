function sis_pp_output = sis_PP_main(SIS_const)
    % Main function that runs the Preprocessing for Star Image Simulation block

    %% Unpack constants
    se_in = SIS_const.in;
    %% Code
    % Preprocessing - Catalogue
    % This file preprocesses the SSP_Star_Catalogue.csv and stores it as se_T

    % Read the Catalogue from SSP_Star_Catalogue.csv into the Table se_T
    se_T = readtable('.\Catalogue\SKY2000\Catalogues\SSP_Star_Catalogue.csv');

    % Remove the following columns - 'SKY2000_ID'
    se_T = removevars(se_T,{'SKY2000_ID'});

    % Trim Star Catalogue According to Star Magnitude
    se_T = se_T(se_T.Vmag <= se_in.Magnitude_Limit, :);

    % Rename Column Headers / Variable Names
    se_T.Properties.VariableNames{'DE'} = 'Dec';
    se_T.Properties.VariableNames{'pmRA'} = 'pm_RA';
    se_T.Properties.VariableNames{'pmDE'} = 'pm_Dec';
    se_T.Properties.VariableNames{'Vmag'} = 'Magnitude';

    % Add unit vectors of stars
    se_T.r0 = [cosd(se_T.Dec) .* cosd(se_T.RA), cosd(se_T.Dec) .* sind(se_T.RA), sind(se_T.Dec)];
    
    sis_pp_output.sis_SKY2000 = se_T;  

end