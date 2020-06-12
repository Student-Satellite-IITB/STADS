%% Generate Constants

st_consts_opt.FOV_Circular = 17.89; % Circular Filed-of-View - in degrees
st_consts_opt.Magnitude_Limit = 6; % Limiting Magnitue
st_consts_opt.Focal_Length = 25;  % Focal Length of optics system - in mm


st_consts_4SM.st_DELTA = 5e-4; % Value of Delta Constant
st_consts_4SM.st_M_EPS = 2.22*10e-16; % Machine epsilon
st_consts_4SM.st_verify_tol = 2; % Verification Step - Tolerance Value

% Number of body and inertial frame vectors required by Estimation block to
% provide attitude with the required accuracy
st_consts_4SM.es_N_EST = 10;

% Total number of iterations allowed for Star-Matching
st_consts_4SM.st_ITER_MAX_4SM = 200;

write_csv = 1; % Writes Reference Star Catalogue if 1

%% Run Preprocessing
st_RF_SC_4SM;

%% Save additional constants and catalogues
% Save constants
st_consts_4SM.st_n_GC = st_n_GC;
st_consts_4SM.st_n_RC = st_n_RC;
st_consts_4SM.st_M = st_M;
st_consts_4SM.st_Q = st_Q;

% Save star catalogues
st_catalogues.st_GD_SC = st_GD_SC;
st_catalogues.st_RF_SC = st_RF_SC;

%% Constants

% Save constants
save ('.\Star_Matching\4_Star_Matching\Preprocessing\Output\st_constants_4SM.mat',...
'st_consts_4SM', 'st_consts_opt', 'st_catalogues');

disp('Done: Write Constants');