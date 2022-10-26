function [sis_photon_profile,sis_T] = sis_lens_main(sis_T, sis_input)

    %%%%New Code for Lens Model
    % function [sis_photon_pRofile,sis_T] = sis_lens_main(sis_T, sis_input)

coeffs = zeros(38); %Defining coefficients matRix
coeffs(1,1) = 6.54080697;
coeffs(1,4) = 3.77411473;
coeffs(1,11) = -0.00172336;
coeffs(1,22) = -0.00000190;

% In mm
%function [D, lam, pix, f, size, Rpupil] = Const
D = 20;             %diameteR of the apeRtuRe (in mm)
lam = 550*10^(-6); %wavelength of obseRvation
pix = 0.0048;        %plate scale
f = 25;            %effective focal length      
size_y = 808;        %size of detectoR in pixels
size_z = 608;
rpupil = 50; %make a pupil_size function
%end

r = 1;
x = linspace(-r, r, 2*rpupil);
y = linspace(-r, r, 2*rpupil);
[X,Y] = meshgrid(x,y);
R = sqrt(X^2+Y^2);
theta = atan2(Y, X);  
% Z = Zernike(coeffs, R, theta);     %Mentioning ZeRnike_PolaR function
% Z(R>1) = 0;  

Z1  =  coeffs(1,1)  * 1*(cos(theta)^2+ sin(theta)^2);
Z2  =  coeffs(1,2)  * 2*R*cos(theta);
Z3  =  coeffs(1,3)  * 2*R*sin(theta);
Z4  =  coeffs(1,4)  * sqrt(3)*(2*R^2-1);
Z5  =  coeffs(1,5)  * sqrt(6)*R^2*sin(2*theta);
Z6  =  coeffs(1,6)  * sqrt(6)*R^2*cos(2*theta);
Z7  =  coeffs(1,7)  * sqrt(8)*(3*R^2-2)*R*sin(theta);
Z8  =  coeffs(1,8)  * sqrt(8)*(3*R^2-2)*R*cos(theta);
Z9  =  coeffs(1,9)  * sqrt(8)*R^3*sin(3*theta);
Z10 =  coeffs(1,10) * sqrt(8)*R^3*cos(3*theta);
Z11 =  coeffs(1,11) * sqrt(5)*(1-6*R^2+6*R^4);
Z12 =  coeffs(1,12) * sqrt(10)*(4*R^2-3)*R^2*cos(2*theta);
Z13 =  coeffs(1,13) * sqrt(10)*(4*R^2-3)*R^2*sin(2*theta);
Z14 =  coeffs(1,14) * sqrt(10)*R^4*cos(4*theta);
Z15 =  coeffs(1,15) * sqrt(10)*R^4*sin(4*theta);
Z16 =  coeffs(1,16) * sqrt(12)*(10*R^4-12*R^2+3)*R*cos(theta);
Z17 =  coeffs(1,17) * sqrt(12)*(10*R^4-12*R^2+3)*R*sin(theta);
Z18 =  coeffs(1,18) * sqrt(12)*(5*R^2-4)*R^3*cos(3*theta);
Z19 =  coeffs(1,19) * sqrt(12)*(5*R^2-4)*R^3*sin(3*theta);
Z20 =  coeffs(1,20) * sqrt(12)*R^5*cos(5*theta);
Z21 =  coeffs(1,21) * sqrt(12)*R^5*sin(5*theta);
Z22 =  coeffs(1,22) * sqrt(7)*(20*R^6-30*R^4+12*R^2-1);
Z23 =  coeffs(1,23) * sqrt(14)*(15*R^4-20*R^2+6)*R^2*sin(2*theta);
Z24 =  coeffs(1,24) * sqrt(14)*(15*R^4-20*R^2+6)*R^2*cos(2*theta);
Z25 =  coeffs(1,25) * sqrt(14)*(6*R^2-5)*R^4*sin(4*theta);
Z26 =  coeffs(1,26) * sqrt(14)*(6*R^2-5)*R^4*cos(4*theta);
Z27 =  coeffs(1,27) * sqrt(14)*R^6*sin(6*theta);
Z28 =  coeffs(1,28) * sqrt(14)*R^6*cos(6*theta);
Z29 =  coeffs(1,29) * 4*(35*R^6-60*R^4+30*R^2-4)*R*sin(theta);
Z30 =  coeffs(1,30) * 4*(35*R^6-60*R^4+30*R^2-4)*R*cos(theta);
Z31 =  coeffs(1,31) * 4*(21*R^4-30*R^2+10)*R^3*sin(3*theta);
Z32 =  coeffs(1,32) * 4*(21*R^4-30*R^2+10)*R^3*cos(3*theta);
Z33 =  coeffs(1,33) * 4*(7*R^2-6)*R^5*sin(5*theta);
Z34 =  coeffs(1,34) * 4*(7*R^2-6)*R^5*cos(5*theta);
Z35 =  coeffs(1,35) * 4*R^7*sin(7*theta);
Z36 =  coeffs(1,36) * 4*R^7*cos(7*theta);
Z37 =  coeffs(1,37) * 3*(70*R^8-140*R^6+90*R^4-20*R^2+1);

ZW = Z1 + Z2 + Z3 + Z4 + Z5 + Z6 + Z7 + Z8 + Z9 + Z10 + Z11 + Z12 + Z13 + Z14 + Z15 + Z16 + Z17 + Z18 + Z19 + Z20 + Z21 + Z22 + Z23 + Z24 + Z25 + Z26 + Z27 + Z28 + Z29 + Z30 + Z31 + Z32 + Z33 + Z34 + Z35 + Z36 + Z37;

Z = ZW;
Z(R>1) = 0;

% % In mm
% %function [D, lam, pix, f, size, Rpupil] = Const
% D = 80;             %diameteR of the apeRtuRe (in mm)
% lam = 550*10^(-6); %wavelength of obseRvation
% pix = 0.005;        %plate scale
% f = 800;            %effective focal length      
% size_y = 808;        %size of detectoR in pixels
% size_z = 608;
% rpupil = 50; %make a pupil_size function
% %end

%function [coefficients] = Coeffs
%     coefficients = zeRos(1,38);   
%     coefficients(1,1) = 6.54080697;    %Assigning abeRRation values
%     coefficients(1,4) = 3.77411473;
%     coefficients(1,11) = -0.00172336;
%     coefficients(1,22) = -0.00000190;
%end

%function [Z] = phase(coeffs,Rpupil)
% r = 1;
% x = linspace(-r, r, 2*rpupil);
% y = linspace(-r, r, 2*rpupil);
% [X,Y] = meshgrid(x,y);
% R = sqrt(X^2+Y^2);
% theta = atan2(Y, X);  
% Z = Zernike(coeffs, R, theta);     %Mentioning ZeRnike_PolaR function
% Z(R>1) = 0;  


%function[sim_phase] = centeR(coeffs,size_y,size_z,Rpupil)
sim_phase = zeros(size_y,size_z);
sim_phase(fix(size_y/2)-rpupil+1:fix(size_y/2)+rpupil,fix(size_z/2)-rpupil+1:fix(size_z/2)+rpupil) = Z;
%end

%function[Mask] = mask(Rpupil, size_y, size_z)
r = 1;
x = linspace(-r, r, 2*rpupil);
y = linspace(-r, r, 2*rpupil);
[X,Y] = meshgrid(x,y); 
R = sqrt(X^2+Y^2);
theta = atan2(Y, X);
M = 1*(cos(theta)^2+sin(theta)^2);
M(R>1) = 0;
Mask =  zeros(size_y,size_z);
Mask(fix(size_y/2)-rpupil+1:fix(size_y/2)+rpupil,fix(size_z/2)-rpupil+1:fix(size_z/2)+rpupil)= M;
%end

%function[pupil_com] = complex_pupil(A,Mask)
abbe =  exp(1j*sim_phase);
pupil_com = zeros(length(abbe),length(abbe));%,'complex');
pupil_com = Mask.*abbe;
%end

%function[psf] = PSF(complex_pupil)
psf = ifftshift(fft2(fftshift(pupil_com))); 
psf = (abs(psf)).^2; %oR PSF*PSF.conjugate()
psf = normalize(psf); %noRmalizing the PSF
%disp(size(psf));
%disp(psf)
%end

%function[otf] = OTF(psf)
otf = ifftshift(psf); %move the centRal fRequency to the coRneR
otf = fft2(otf);
%otf_max = cast(otf(1,1), float); %otf_max = otf[size/2,size/2] if max is shifted to centeR
otf_max = max(otf);
otf = normalize(otf); %noRmalize by the centRal fRequency signal
%end

%function[mtf] = MTF(otf)
mtf = abs(otf);
%disp(size(mtf));
%end

% sim_phase = centeR(coeffs,size_y, size_z,Rpupil);
% Mask = mask(Rpupil, size_y, size_z);
% pupil_com = complex_pupil(sim_phase,Mask);
% psf = PSF(pupil_com);
% otf = OTF(psf);
% mtf = MTF(otf);
%disp(mtf)


    
    %%%%Old code again now
    %% Lens to Sensor Frame
    %comment on branch feature
    
    sis_T = [sis_T repmat(array2table(sis_input.lls.Lens.Focal_Length - sis_input.lls.CMOS.Defocus, 'VariableNames', {'Focal_Length'}), size(sis_T.RA))];
    sis_T = [sis_T repmat(array2table(sis_input.lls.CMOS.Pixel_Size - sis_input.lls.CMOS.Defocus, 'VariableNames', {'Pixel_Size'}), size(sis_T.RA))];
   
    sis_T = [sis_T rowfun(@Lens2Sensor_y, sis_T, 'InputVariables', {'r3' 'Focal_Length'}, 'OutputVariableName', 'Sensor_y')...
                 rowfun(@Lens2Sensor_z, sis_T, 'InputVariables', {'r3' 'Focal_Length'}, 'OutputVariableName', 'Sensor_z')];
    sis_T = [sis_T rowfun(@y2y_Pix, sis_T, 'InputVariables', {'Sensor_y' 'Pixel_Size'}, 'OutputVariableName', 'Sensor_y_Pixels')...
                 rowfun(@z2z_Pix, sis_T, 'InputVariables', {'Sensor_z' 'Pixel_Size'}, 'OutputVariableName', 'Sensor_z_Pixels')];
    if (sis_input.gen.Debug_Run == true); disp('Lens to Sensor: Transformation Completed'); end
    
    
    % Display Sucess
    if (sis_input.gen.Debug_Run == 1); fprintf('Lens to Sensor: Success \n \n'); end
    
    
    %% Trim to Sensor
    
    % Trim to Sensor Dimensions
    sis_T = sis_T(sis_T.Sensor_y <= + sis_input.lls.CMOS.Length / 2, :);
    sis_T = sis_T(sis_T.Sensor_y >= - sis_input.lls.CMOS.Length / 2, :);
    sis_T = sis_T(sis_T.Sensor_z <= + sis_input.lls.CMOS.Width / 2, :);
    sis_T = sis_T(sis_T.Sensor_z >= - sis_input.lls.CMOS.Width / 2, :);
    if (sis_input.gen.Debug_Run == 1); disp('Trim to Sensor: Table Modified'); end
    
    % Display Sucess
    if (sis_input.gen.Debug_Run == 1); fprintf('Trim to Sensor: Success \n \n'); end
    
    
    %% Gaussian Modelling
    % Define arrays x_c and y_c containing centroids and m_c containing
    % magnitudes
    y_c = (table2array(sis_T(:, find(string(sis_T.Properties.VariableNames) =='Sensor_y_Pixels'))))';     %#ok<FNDSB>
    z_c = (table2array(sis_T(:, find(string(sis_T.Properties.VariableNames) =='Sensor_z_Pixels'))))';     %#ok<FNDSB>
    m_c = (table2array(sis_T(:, find(string(sis_T.Properties.VariableNames) =='Magnitude'))))';           %#ok<FNDSB>
    if (sis_input.gen.Debug_Run == 1); disp('Image Generation: Centroids with Magnitude Loaded'); end
    
    % Change frames from the centre of the Frame to the first pixel and
    % flip along Y for calculations
    y_c = y_c + sis_input.lls.CMOS.Length_Pix / 2 + 0.5;
    z_c = -z_c + sis_input.lls.CMOS.Width_Pix / 2 + 0.5;
    if (sis_input.gen.Debug_Run == 1); disp('Image Generation: Centroids shifted from the Centre Frame to (0, 0) Frame (Flipped)'); end
    
    % Define n to hold the number of stars
    n = size(y_c);
    
    % Broadcasting the centroids
    y_c = repmat(reshape(y_c, 1, 1, []), sis_input.lls.CMOS.Width_Pix, sis_input.lls.CMOS.Length_Pix);
    z_c = repmat(reshape(z_c, 1, 1, []), sis_input.lls.CMOS.Width_Pix, sis_input.lls.CMOS.Length_Pix);
    m_c = repmat(reshape(m_c, 1, 1, []), sis_input.lls.CMOS.Width_Pix, sis_input.lls.CMOS.Length_Pix);
    
    % Initialising Grid
    [Y, Z] = meshgrid(1:sis_input.lls.CMOS.Length_Pix, 1:sis_input.lls.CMOS.Width_Pix);
    if (sis_input.gen.Debug_Run == 1); disp('Image Generation: Grid Initialised'); end
    
    % Broadcasting the Grid
    Y = repmat(Y, [1, n]);
    Z = repmat(Z, [1, n]);
    
    % Calculating the Pixel Values
    %%%% Want to discuss the formula
    %photon_values = sis_input.lls.Gain * sis_input.lls.C_1 * sis_input.lls.C_2 .^ (-m_c) / (sis_input.lls.Gauss_Sigma * sqrt(2 * pi)) .* exp(-((Y - y_c) .^2 + (Z - z_c) .^ 2) / (2 * sis_input.lls.Gauss_Sigma ^ 2));
    sigma  = sqrt(2) * sis_input.lls.Pixel_Spread / 3 ;
    photon_values = sis_input.lls.C_1 * sis_input.lls.C_2 .^ (-m_c) / (pi * sigma^2 ) .* exp(-((Y - y_c) .^2 + (Z - z_c) .^ 2)/(sigma^2));
    if (sis_input.gen.Debug_Run == 1); disp('Image Generation: Pixel Values Calculated'); end
    
    % Generate Image Matrix
    sis_photon_profile =  sum(photon_values, 3);
%     disp(size(sis_photon_profile));
%     disp(size(mtf))
    mtf = mtf';
    sis_photon_profile = mtf.*sis_photon_profile;
    
    if (sis_input.gen.Debug_Run == 1); disp('Image Generation: Image Matrix Generated'); end
    
    % Display Sucess
    if (sis_input.gen.Debug_Run == 1); fprintf('Image Generation: Success \n \n'); end
end



%% Functions for Lens to Sensor Frame

function y = Lens2Sensor_y(r3, Adjusted_Focal_Length)
    % Calculates the y Value on the Sensor
    % This function calculates the y Value on the Sensor
    %
    % -----------
    % Parameters:
    % -----------
    %
    % r3: (Array (3,1))
    %   The reference unit vector in the Lens Frame
    %   Comments: 
    %   - Format - (X, Y, Z)
    %   
    % Adjusted Focal Length: (Double)
    %   Equals to Focal Length - Defocus
    %
    % --------
    % Returns:
    % --------
    %
    % y: (Double)
    %   The y - Value on Sensor (In Metres)
    
    % =====
    % Code:
    % =====
    
    y = r3(2) * Adjusted_Focal_Length / r3(1);
end

function z = Lens2Sensor_z(r3, Adjusted_Focal_Length)
    % Calculates the z Value on the Sensor
    % This function calculates the z Value on the Sensor
    %
    % -----------
    % Parameters:
    % -----------
    %
    % r3: (Array (3,1))
    %   The reference unit vector in the Lens Frame
    %   Comments: 
    %   - Format - (X, Y, Z)
    %   
    % Adjusted Focal Length: (Double)
    %   Equals to Focal Length - Defocus
    %
    % --------
    % Returns:
    % --------
    %
    % z: (Double)
    %   The z - Value on Sensor (In Metres)
    
    % =====
    % Code:
    % =====
    
    z = r3(3) * Adjusted_Focal_Length / r3(1);
end

function y_Pix = y2y_Pix(y, Pixel_Size)
    % Calculates the y Value on the Sensor in Pixels
    % This function calculates the y Value on the Sensor in Pixels
    %
    % -----------
    % Parameters:
    % -----------
    %
    % y: (Double, In Metres)
    %   The y coordinate in Metres
    %   
    % Pixel_Size: (Double, In Metres)
    %   Pixel Size in Metres
    %
    % --------
    % Returns:
    % --------
    %
    % y_Pix: (Double)
    %   The y - Value on Sensor (In Pixels)
    
    % =====
    % Code:
    % =====
    
    y_Pix = y / Pixel_Size;
end

function z_Pix = z2z_Pix(z, Pixel_Size)
    % Calculates the z Value on the Sensor in Pixels
    % This function calculates the z Value on the Sensor in Pixels
    %
    % -----------
    % Parameters:
    % -----------
    %
    % z: (Double, In Metres)
    %   The z coordinate in Metres
    %   
    % Pixel_Size: (Double, In Metres)
    %   Pixel Size in Metres
    %
    % --------
    % Returns:
    % --------
    %
    % z_Pix: (Double)
    %   The z - Value on Sensor (In Pixels)
    
    % =====
    % Code:
    % =====
    
    z_Pix = z / Pixel_Size;
end

