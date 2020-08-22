clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Checks the expected angular distances and actual angular distances
% between pairs of stars in the image using the sensor modelling data and
% the Guide Star Catalogue

% Result -> The angular distances match!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('.\Star_Matching\4_Star_Matching\Preprocessing\Output\st_constants_4SM.mat');
GD_SC = st_catalogues.st_GD_SC;

%% Input
% Folder - Feature Extraction Input
file_base_ip = '.\Star_Matching\4_Star_Matching\MILS\Expected_Input\Simulation_3\Image_';
file_base_op = '.\Star_Matching\4_Star_Matching\MILS\ST_Testing\Angular_Distance\';

%% Check Angular Distances
data_mean = zeros(15,2);
tic
for i = 1:15
    %% Input
    file_loc_ip = strcat(file_base_ip , num2str(i) , '\se_Table_' ,  num2str(i) , '.mat');
    load(file_loc_ip);

    %% Expected Body-frame
    st_bi_exp = [se_T_Final.SSP_ID, se_T_Final.r3];
    sz = size(st_bi_exp);
    N = sz(1);
    
    %% Create matrices to store data
    data_mat = zeros(N*(N-1)*0.5, 5);
    
    %% Store Data
    kidx = 1;
    for idx = 1:N-1
        for jdx = (idx+1):N            
            c1 = st_bi_exp(idx, 1);
            c2 = st_bi_exp(jdx, 1);
            
            if (c1 <= 5060) && (c2 <= 5060)
                bi_idx_exp = GD_SC(c1, 2:4);
                bi_jdx_exp = GD_SC(c2, 2:4);
                c3 = dot(bi_idx_exp, bi_jdx_exp);
            else
                c3 = 0;
            end
            
            bi_idx_act = st_bi_exp(idx, 2:4);
            bi_jdx_act = st_bi_exp(jdx, 2:4);
            c4 = dot(bi_idx_act, bi_jdx_act);
            
            if c3 == 0
                c5 = 0;
            else
                c5 = abs(1 - c3/c4)*100;
            end
            
            data_mat(kidx, :) = [c1, c2, c3, c4, c5]; 
            kidx = kidx + 1;
        end        
    end
    data_table = array2table(data_mat, 'VariableNames', {'SSP_ID1', 'SSP_ID2', 'AngDst_Exp', 'AngDst_Act', 'ErrorPercent'});
    cond = data_table.AngDst_Exp ~= 0;
    data_table = data_table(cond, :);
    
    mean_err = mean(data_table.ErrorPercent);
    
    %% Write Output    
    file_loc_op = strcat(file_base_op , 'st_output_' , num2str(i) , '.mat');
    save(file_loc_op, 'data_table', 'mean_err');        
    
    data_mean(i,:) = [i, mean_err];
    
end
toc
file_loc_op = strcat(file_base_op , 'st_summary_Angular_Distance.mat');
save(file_loc_op, 'data_mean');  