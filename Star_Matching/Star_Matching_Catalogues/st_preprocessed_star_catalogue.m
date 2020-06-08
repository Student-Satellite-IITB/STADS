%% Read Guide Star Catalogue
st_GD_SC = readmatrix('.\Star_Matching\Star_Matching_Catalogues\Catalogues\st_Guide_Star_Catalogue.csv');
sz = size(st_GD_SC);
N = sz(1); % Number of stars in Guide Catalogue

%% Create Preprocessed Star Catalogue
len = (N * (N-1) )/2; % N C 2 - number of possible combinations
st_PP_SC = zeros(len,4);

k_idx = 1; % Counter Variable
tic
% Outer for-loop iterates from i = 1:(N-1), while inner for-loop iterates
% over j = (i+1):N
% This ensures that for each star in the catalogue, the angular distance
% w.r.t every other star is accounted for, and ignoring the reduntant case
% of (i = j)
for i_idx = 1 : (N-1)
    v_i = st_GD_SC(i_idx, 2:4); % (i-th) unit vector
    
    for j_idx = (i_idx+1) : N
        v_j = st_GD_SC(j_idx, 2:4); %$ (j-th) unit vector
        
        res1 = dot(v_i, v_j); % Dot Product
        res2 = acosd(res1); % Cos inverse of dot product - in degrees
        
        
        k_rw = [i_idx, j_idx, res1, res2]; % (k-th) row of Preprocessed Star Catalogue        
        st_PP_SC(k_idx, :) = k_rw; % Update (k-th) row of Preprocessed Star Catalogue
        
        k_idx = k_idx + 1; % Update k-index variable
    end 
end
toc
%% Ignore Star-Pairs that lie outside the Field-of-View

FOV_Circular = 17.89; % Circular FOV - in degrees

tmp = st_PP_SC( st_PP_SC(:, 4) <= FOV_Circular*2 , : ); % Ignore star-pairs with ang_dst greater than FOV_Circular

% Create Table
st_PP_SC_table = array2table(tmp, 'VariableNames', {'SSP_ID_1', 'SSP_ID_2', 'AngDst_cos', 'AngDst_deg'});

st_PP_SC_table = sortrows(st_PP_SC_table,'AngDst_cos','ascend'); % Sort based on AngDst_cos column
%%
% Write Table
writetable(st_PP_SC_table, '.\Star_Matching\Star_Matching_Catalogues\Catalogues\st_Preprocessed_Star_Catalogue.csv');