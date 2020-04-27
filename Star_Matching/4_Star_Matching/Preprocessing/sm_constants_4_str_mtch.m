%% Generate Constants

sm_DELTA = 0.0001; % Value of Delta Constant
sm_M_EPS = 2.22*10e-16; % Machine epsilon
Focal_Length = 28; % Focal Length of optics system - in mm

write_csv = 0; % Writes Reference Star Catalogue if 1

%% Run Preprocessing
sm_RF_SC_4_str_mtch;
%% Constants
% Save constants
save ('.\Star_Matching\4_Star_Matching\Preprocessing\sm_constants_4_str_mtch.mat',...
'Focal_Length', 'M_EPS', 'n_rw_GC', 'n_rw_RC', 'sm_DELTA', 'sm_M', 'sm_Q'); 

disp('Done: Write Constants');