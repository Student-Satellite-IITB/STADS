%% Read Guide Star Catalogue
GD_SC = readmatrix('.\Catalogue\SKY2000\Catalogues\Star_Matching\Guide_Star_Catalogue.csv');
sz = size(GD_SC);
N = sz(1); % Number of stars in Guide Catalogue

%% Create Preprocessed Star Catalogue
len = (N * (N-1) )/2; % N C 2 - number of possible combinations
PP_SC = zeros(len,4);

k_idx = 1; % Counter Variable
tic
% Outer for-loop iterates from i = 1:(N-1), while inner for-loop iterates
% over j = (i+1):N
% This ensures that for each star in the catalogue, the angular distance
% w.r.t every other star is accounted for, and ignoring the reduntant case
% of (i = j)
for i_idx = 1 : (N-1)
    v_i = GD_SC(i_idx, 2:4); % (i-th) unit vector
    
    for j_idx = (i_idx+1) : N
        v_j = GD_SC(j_idx, 2:4); %$ (j-th) unit vector
        
        res1 = dot(v_i, v_j); % Dot Product
        res2 = rad2deg( atan2( norm( cross(v_i, v_j) ), res1) ); % Angluar Distance in degrees      
                
        k_rw = [i_idx, j_idx, res1, res2]; % (k-th) row of Preprocessed Star Catalogue        
        PP_SC(k_idx, :) = k_rw; % Update (k-th) row of Preprocessed Star Catalogue
        
        k_idx = k_idx + 1; % Update k-index variable
    end 
end
toc
%% Ignore Star-Pairs that lie outside the Field-of-View

FOV_Circular = 16; % Circular FOV - in degrees

tmp = PP_SC( PP_SC(:, 4) <= FOV_Circular , : ); % Ignore star-pairs with ang_dst greater than FOV_Circular

% Create Table
PP_SC_table = array2table(tmp, 'VariableNames', {'SSP_ID_1', 'SSP_ID_2', 'AngDst_cos', 'AngDst_deg'});

PP_SC_table = sortrows(PP_SC_table,'AngDst_cos','ascend'); % Sort based on AngDst_cos column

% Write Table
writetable(PP_SC_table, '.\Catalogue\SKY2000\Catalogues\Star_Matching\Preprocessed_Star_Catalogue.csv');