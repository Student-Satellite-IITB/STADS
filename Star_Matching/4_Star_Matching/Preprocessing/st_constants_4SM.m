%% Generate Constants

%st_DELTA = 0.0001; % Value of Delta Constant
st_M_EPS = 2.22*10e-16; % Machine epsilon
Focal_Length = 28; % Focal Length of optics system - in mm

% Number of body and inertial frame vectors required by Estimation block to
% provide attitude with the required accuracy
es_N_EST = 10;

% Total number of iterations allowed for Star-Matching
st_ITER_MAX_4SM = 200;

write_csv = 0; % Writes Reference Star Catalogue if 1

%% Run Preprocessing
st_RF_SC_4SM;
%% Constants
% Save constants
%save ('.\Star_Matching\4_Star_Matching\Preprocessing\st_constants_4SM.mat',...
%'Focal_Length', 'st_M_EPS', 'st_n_GC', 'st_n_RC', 'st_DELTA', 'st_M', 'st_Q',...
%'es_N_EST', 'st_ITER_MAX_4SM'); 

save ('.\Star_Matching\4_Star_Matching\Preprocessing\st_constants_4SM.mat',...
'Focal_Length', 'st_M_EPS', 'st_n_GC', 'st_n_RC', 'st_M', 'st_Q',...
'es_N_EST', 'st_ITER_MAX_4SM'); 

disp('Done: Write Constants');