function [sm_TM_SNT] = sm_TM_SNT_padding(sm_TM_SNT_star_ID, sm_TM_SNT)
%% Appends the star neighbours of one star to the Star Neighbourhood Matrix with zero padding
% Parameters:
% ----------------
% sm_TM_SNT_star_ID : (1, N) - Vector
%    The Star Neighbours of a single star. 
% sm_TM_SNT : (M, N) - Matrix
%    The Star Neighbourhood Table (incomplete)

% Returns:
% --------------
% sm_TM_SNT : (5060, N) - Matrix
%    The Star Neighbourhood Table (complete)

%% Calculate number of rows and columns of input matrices. 
sm_TM_SNT_star_ID_r_n = size(sm_TM_SNT_star_ID, 1);
sm_TM_SNT_star_ID_c_n = size(sm_TM_SNT_star_ID, 2);
sm_TM_SNT_r_n = size(sm_TM_SNT, 1);
sm_TM_SNT_c_n = size(sm_TM_SNT, 2);

%% Add zero padding to either st_TM_SNT or st_TM_SNT_star_ID based on st_TM_SNT_c_n and st_TM_SNT_star_ID_c_n
if sm_TM_SNT_c_n < sm_TM_SNT_star_ID_c_n
    sm_TM_SNT = [sm_TM_SNT zeros(sm_TM_SNT_r_n, sm_TM_SNT_star_ID_c_n-sm_TM_SNT_c_n)];
elseif sm_TM_SNT_c_n > sm_TM_SNT_star_ID_c_n
    sm_TM_SNT_star_ID = [sm_TM_SNT_star_ID zeros(sm_TM_SNT_star_ID_r_n, sm_TM_SNT_c_n-sm_TM_SNT_star_ID_c_n)]; 
end
sm_TM_SNT = [sm_TM_SNT;sm_TM_SNT_star_ID];
end