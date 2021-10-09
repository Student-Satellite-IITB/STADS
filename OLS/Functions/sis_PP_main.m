function sis_pp_output = sis_PP_main(SIS_const,version)
    % Main function that runs the Preprocessing for Star Image Simulation block
    
    if version == "Default Block" 
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
    elseif version == "Version - 3"
        sis_input = SIS_const;
        
        sis_T = readtable('.\Catalogue\SKY2000\Catalogues\SSP_Star_Catalogue.csv');
        if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: Catalogue Successfully Read'); end
        
        % Remove the following columns - 'SKY2000_ID'
        sis_T = removevars(sis_T,{'SKY2000_ID'});
        if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: Catalogue Trimmed'); end
        
        % Trim Star Catalogue According to Star Magnitude
        sis_T = sis_T(sis_T.Vmag <= sis_input.gen.Magnitude_Limit, :);
        if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: Catalogue Modified'); end
        
        % Rename Column Headers / Variable Names
        sis_T.Properties.VariableNames{'DE'} = 'Dec';
        sis_T.Properties.VariableNames{'pmRA'} = 'pm_RA';
        sis_T.Properties.VariableNames{'pmDE'} = 'pm_Dec';
        sis_T.Properties.VariableNames{'Vmag'} = 'Magnitude';
        if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: Variables Renamed'); end
    
        % Add unit vectors of stars
        sis_T.r0 = [cosd(sis_T.Dec) .* cosd(sis_T.RA), cosd(sis_T.Dec) .* sind(sis_T.RA), sind(sis_T.Dec)];
        if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: Converted to Cartesian Coordinates'); end
        
        
        
        sis_pp_output.sis_SKY2000 = sis_T; 
    end

end