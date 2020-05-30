% Preprocessing - Load Inputs
% This file loads all the inputs from *.xls files in the Inputs folder

% -----------------------------------------
% Part 1 - Loading the Sensor Model Inputs:
% -----------------------------------------

% The inputs are stored in the structure se_inputs_struct

se_inputs_mat = readmatrix('se_inputs.xlsx','Range','B2:B10');
se_in.Debug_Run =             se_inputs_mat(1); % Debug Run or Silent Run
se_in.Magnitude_Limit =       se_inputs_mat(2); % Sensor Model Star Magnitude Limit
se_in.No_Boresight_Inputs =   se_inputs_mat(3); % Number of Boresight Inputs in se_boresight_inputs.xlsx
if (se_in.Debug_Run == 1); disp('Preprocessing: Sensor Model Inputs Read'); end

% --------------------------------------
% %% Part 2 - Loading the Optics Inputs:
% --------------------------------------

% The inputs are stored in the structure se_op_inputs_struct

se_op_inputs_mat = readmatrix('se_op_inputs.xlsx','Range','B2:B10');
se_op.CMOS.Length_Pix =   se_op_inputs_mat(1);        % Pixels
se_op.CMOS.Width_Pix =    se_op_inputs_mat(2);        % Pixels
se_op.CMOS.Pixel_Size =   se_op_inputs_mat(4) * 1e-3; % mm -> m
se_op.CMOS.Defocus =      se_op_inputs_mat(6) * 1e-3; % mm -> m
se_op.Lens.Focal_Length = se_op_inputs_mat(3) * 1e-3; % mm -> m
se_op.Lens.Diameter =     se_op_inputs_mat(5) * 1e-3; % mm -> m

% Intermediate Values
% Field of Views
% $$L (m) = \#Pixels \cdot L_{Pixel} (m)$$
% 
% $$D^2 = L^2 + W^2$$

se_op.CMOS.Length =     se_op.CMOS.Length_Pix * se_op.CMOS.Pixel_Size;      % m
se_op.CMOS.Width =      se_op.CMOS.Width_Pix * se_op.CMOS.Pixel_Size;       % m
se_op.CMOS.Diagonal =   sqrt(se_op.CMOS.Length ^ 2 + se_op.CMOS.Width ^ 2); % m

% $$FOV_i = 2 \cdot tan^{-1} \left( \frac{L_i}{2 f} \right)$$
% where i = 1, 2, 3 for Length, Width and Diagonal.
% Note: FOV_Circular is NOT given by $FOV_C^2 = FOV_L^2 + FOV_W^2$

se_op.FOV.Length =      2 * atand(se_op.CMOS.Length / (2 * se_op.Lens.Focal_Length));   % Degrees
se_op.FOV.Width =       2 * atand(se_op.CMOS.Width / (2 * se_op.Lens.Focal_Length));    % Degrees
se_op.FOV.Circular =    2 * atand(se_op.CMOS.Diagonal / (2 * se_op.Lens.Focal_Length)); % Degrees
if (se_in.Debug_Run == 1); disp('Preprocessing: Optics Inputs Read'); end

% ---------------------------------------------
% Part 3 - Loading the Image Generation Inputs:
% ---------------------------------------------

% The inputs are stored in the structure se_ig_inputs_struct

se_ig_inputs_mat = readmatrix('se_ig_inputs.xlsx','Range','B2:B10');
% To be redefined to be a function of Defocus
se_ig.Pixel_Spread =    se_ig_inputs_mat(1);        % Pixels
se_ig.Capture_Rate =    se_ig_inputs_mat(2);        % Hz
se_ig.Eta =             se_ig_inputs_mat(3) / 100;  % In Decimals
se_ig.Gain =            se_ig_inputs_mat(4);        % In LSB10 / electron
se_ig.Exposure_Time =   se_ig_inputs_mat(5);        % Seconds
se_ig.MTF =             se_ig_inputs_mat(6) / 100;  % In Decimals
se_ig.Full_Well =       se_ig_inputs_mat(7);        % Electrons - May be used later

% Intermediate Values
% Gaussian Function - Standard Deviation
% Sigma for the Gaussian Function
% 
% For a 2-D Normal Distribution, f(x,y), assuming no correlation between x and 
% y.
% 
% $$f(x,y)=\frac{1}{2 \pi \sigma_x \sigma_y }\exp \left(-\left({\frac {(x-\mu_x)^{2}}{2\sigma 
% _{X}^{2}}}+{\frac {(y-\mu_y)^{2}}{2\sigma _{Y}^{2}}}\right)\right)$$
% 
% Now, taking $\sigma_x =\sigma_y =\frac{\sigma }{\sqrt{2}}$, we get
% 
% $$f(x,y)=\frac{1}{\pi \sigma^2 }\exp \left(-\left({\frac {(x-\mu_x)^{2} + 
% (y-\mu_y)^{2}}{\sigma^{2}}}\right)\right)$$
% 
% Now, taking the $3\sigma \;$bound to be the Pixel Spread, with a confidence 
% of 99.87%
% 
% $$\frac{3 \sigma}{\sqrt{2}} = 3 \sigma_x = 3 \sigma_y = \frac{\text{Pixel 
% Spread}}{2}$$
% 
% (In 1 Direction as oppoed to both directions simulataneously)
% 
% This gives 
% 
% $$\sigma = \frac{\text{Pixel Spread} \sqrt{2}}{3}$$
% 
% Source: <https://en.wikipedia.org/wiki/Multivariate_normal_distribution#Bivariate_case 
% https://en.wikipedia.org/wiki/Multivariate_normal_distribution#Bivariate_case>

se_ig.Gauss_Sigma =   (se_ig.Pixel_Spread * sqrt(2)) / 3; 

% Reference Calculations
% Reference - <https://www.cfa.harvard.edu/~dfabricant/huchra/ay145/mags.html https://www.cfa.harvard.edu/~dfabricant/huchra/ay145/mags.html>
% The dimmer an object appears, the higher the numerical value given to its 
% magnitude, with a difference of 5 magnitudes corresponding to a brightness factor 
% of exactly 100. Therefore, the magnitude _m_, in the spectral band _x_, would 
% be given by
% $$m_{x}=-5\log _{100}\left({\frac {F_{x}}{F_{x,0}}}\right)$$
% 
% This gives -
% $$m_{x}=-2.5\log _{10}\left({\frac {F_{x}}{F_{x,0}}}\right)$$
% 
% where $F_X$ is the observed flux density using spectral filter _x_, and $F_{x,0}$ 
% is the reference flux (zero-point)
% 
% Now, we can calculate $F_X$ -
% $$F_x = F_{x,0} (^5\sqrt{100})^{m_x}$$
% 
% Where, $F_{x,0} = 3640 \,\, Jy \,\, \& \,\, \frac{\Delta \lambda}{\lambda} 
% = 0.16$ for V-Band
% $$1 \text{ Jy} = 1.51 \times 10^7 \frac{photons}{s \cdot m^2 \cdot \frac{\Delta 
% \lambda}{\lambda}$$
% 
% So, Intensity - 
% $$I = F_x \frac{\Delta\lambda}{\lambda}$$
% 
% So, 
% $$\# Photons = I \cdot t_{Capture} \cdot Area$$
% $$\# Electrons = \# Photons \cdot MTF \cdot \eta$$
% $$\# Electrons = I \cdot t_{Capture} \cdot Area \cdot MTF \cdot \eta$$
%
% This means
% $$\# Electrons = F_{x,0} \cdot 1.51e7 \cdot \frac{\Delta\lambda}{\lambda} 
% \cdot t_{Capture} \cdot Area \cdot \cdot MTF \eta \cdot  (^5\sqrt{100})^{-m_x}$$
% 
% $$\# Electrons = C_1 \cdot  C_2^{-m_x}$$
% 
% where,
% $$C_1 =  F_{x,0} \cdot 1.51 \times 10^7 \cdot \frac{\Delta\lambda}{\lambda} 
% \cdot t_{Capture} \cdot Area \cdot MTF \cdot \eta$$
% 
% $$C_2 = ^5\sqrt{100}$$

se_ig.C_1 = 3640 * 1.51e7 * 0.16 * se_ig.Exposure_Time * (pi * se_op.Lens.Diameter ^ 2 / 4) * se_ig.MTF * se_ig.Eta;
se_ig.C_2 = 100 ^ 0.2;
if (se_in.Debug_Run == 1); disp('Preprocessing: Image Generation Inputs Read'); end

% --------------------------------------
% Part 4 - Loading the Boresight Inputs:
% --------------------------------------

% This section loads n boresight inputs from se_boresight_inputs.xlsx, where 
% 'n' is the Number of Boreisght Inputs defined in se_inputs.xlsx into a matrix 
% 'se_bo'

se_boresight_inputs_mat = readmatrix('se_boresight_inputs.xlsx','Range', strcat('B2:D', num2str(se_in.No_Boresight_Inputs + 1)));
se_bo = array2table(se_boresight_inputs_mat, "VariableNames", ["RA", "Dec", "Roll"]);
se_bo.se_r0 = [cosd(se_bo.Dec) .* cosd(se_bo.RA), cosd(se_bo.Dec) .* sind(se_bo.RA), sind(se_bo.Dec)];
if (se_in.Debug_Run == 1); disp('Preprocessing: Boresight Inputs Read'); end

% ----------------------------------
% Part 5 - Loading the Error Inputs:
% ----------------------------------

% This section load the error inputs from (yet to be made) se_er_inputs.xlsx 
% to the structure se_er
% The error variables include -
% DTN - Dark Temporan Noise
% FPN - Fixed Pattern Noise
% PLS - Parasitic Light Sensitivity
% PRNU - Photo Response Non Uniformity
% PSNL - Pixel Storage Node Leakage
% DS - Dark Signal
% SNR - Signal to Noise Ratio
% DR - Dynamic Range

se_er_inputs_mat = readmatrix('se_er_inputs.xlsx','Range', 'B2:B15');
se_er.DTN =         se_er_inputs_mat(1);        % # Electrons
se_er.FPN =         se_er_inputs_mat(2);        % LSB10
se_er.PLS =         se_er_inputs_mat(3);        % No Units
se_er.PRNU =        se_er_inputs_mat(4) / 100;  % Percentage -> Decimal
se_er.PSNL =        se_er_inputs_mat(5);        % LSB10
se_er.DS =          se_er_inputs_mat(6);        % # Electrons / s
se_er.SNR =         se_er_inputs_mat(7);        % dB
se_er.DR =          se_er_inputs_mat(8);        % dB
se_er.rng_Seed =    se_er_inputs_mat(9);        % NA
se_er.Read_Rate =   se_er_inputs_mat(10) * 1e6; % Mbps -> bps
if (se_in.Debug_Run == 1); disp('Preprocessing: Error Inputs Read'); end

% Save the Inputs to a mat file
% This section saves all the concerned structures to Sensor_Modelling/Inputs/se_Inputs.mat

save('./Sensor_Model/Inputs/se_inputs.mat', "se_in", "se_op", "se_ig", "se_bo", "se_er");
clearvars("se_boresight_inputs_mat","se_ig_inputs_mat", "se_inputs_mat", "se_op_inputs_mat", "se_er_inputs_mat");
if (se_in.Debug_Run == 1); disp('Preprocessing: Inputs Saved'); end
fprintf('\n');