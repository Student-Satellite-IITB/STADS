function [st_TM_SNT] = st_TM_SNT_padding(st_TM_SNT_star_ID, st_TM_SNT)
%% s
% Parameters:
% ----------------
% st_TM_SNT_star_ID : (1, N) - Vector
%    The Star Neighbours of a single star. 
% st_TM_SNT : (M, N) - Matrix
%    The Star Neighbourhood Table (incomplete)

% Returns:
% --------------
% st_TM_SNT : (5060, N) - Matrix
%    The Star Neighbourhood Table (complete)

%% Calculate number of rows and columns of input matrices. 
st_TM_SNT_star_ID_r_n = size(st_TM_SNT_star_ID, 1);
st_TM_SNT_star_ID_c_n = size(st_TM_SNT_star_ID, 2);
st_TM_SNT_r_n = size(st_TM_SNT, 1);
st_TM_SNT_c_n = size(st_TM_SNT, 2);

%% Add zero padding to either st_TM_SNT or st_TM_SNT_star_ID based on st_TM_SNT_c_n and st_TM_SNT_star_ID_c_n
if st_TM_SNT_c_n < st_TM_SNT_star_ID_c_n
    st_TM_SNT = [st_TM_SNT zeros(st_TM_SNT_r_n, st_TM_SNT_star_ID_c_n-st_TM_SNT_c_n)];
elseif st_TM_SNT_c_n > st_TM_SNT_star_ID_c_n
    st_TM_SNT_star_ID = [st_TM_SNT_star_ID zeros(st_TM_SNT_star_ID_r_n, st_TM_SNT_c_n-st_TM_SNT_star_ID_c_n)]; 
end
st_TM_SNT = [st_TM_SNT;st_TM_SNT_star_ID];
end