% Mainfile for Sensor Model Block
%   The Sensor Model Generates the Image as seen by the Star Tracker in 
%   space. This is input to the Feature Extraction Block.

% -----------------------
% Part 0 - Preprocessing:
% -----------------------

se_pp = true;
if (se_pp == true)
    se_PP_1_Load_Constants; 
    se_PP_2_Catalogue; 
end

% Load Simulation Number
load('./Sensor_Model/Inputs/Sim_No.mat');

% -----------------------
% Part 1 - Main Function:
% -----------------------

for i = 1:se_in.No_Boresight_Inputs
    % Calling the se_image function which generates the image.
    [se_Image_Mat, se_T_Final] = se_PR_Main(se_T, se_bo(i, :), se_op, se_ig, se_er, se_in);
    se_T_fe = [se_T_Final.SSP_ID, se_T_Final.Sensor_y_Pixels, se_T_Final.Sensor_z_Pixels];
    mkdir(sprintf('./Sensor_Model/Outputs/Simulation_%s/Image_%s', string(Simulation_Number), string(i)));
    save(sprintf('./Sensor_Model/Outputs/Simulation_%s/Image_%s/se_Image_%s.mat', string(Simulation_Number), string(i), string(i)), "se_Image_Mat");
    save(sprintf('./Sensor_Model/Outputs/Simulation_%s/Image_%s/se_Table_%s.mat', string(Simulation_Number), string(i), string(i)), "se_T_Final");
    save(sprintf('./Sensor_Model/Outputs/Simulation_%s/Image_%s/se_Centroids_%s.mat', string(Simulation_Number), string(i), string(i)), "se_T_fe");
    imwrite(se_Image_Mat/20, sprintf('./Sensor_Model/Outputs/Simulation_%s/Image_%s/Image_%s.png', string(Simulation_Number), string(i), string(i)));
end

% Increasing the Simulation Number and saving it for next simulation
Simulation_Number  = Simulation_Number + 1;
save('./Sensor_Model/Inputs/Sim_No.mat', 'Simulation_Number');