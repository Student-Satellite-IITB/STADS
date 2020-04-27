%% Generate Constants

st_DELTA = 0.0001; % Value of Delta Constant
st_M_EPS = 2.22*10e-16; % Machine epsilon
Focal_Length = 28; % Focal Length of optics system - in mm

write_csv = 0; % Writes Reference Star Catalogue if 1

%% Run Preprocessing
st_RF_SC_4_str_mtch;
%% Constants
% Save constants
save ('.\Star_Matching\4_Star_Matching\Preprocessing\st_constants_4_str_mtch.mat',...
'Focal_Length', 'st_M_EPS', 'n_rw_GC', 'n_rw_RC', 'st_DELTA', 'st_M', 'st_Q'); 

disp('Done: Write Constants');