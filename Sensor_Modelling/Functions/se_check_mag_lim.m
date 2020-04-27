function [bool] = se_check_mag_lim(se_magnitude_limit)
% Returns 1 if se_magnitude_limit has changed, 0 o/w
%   ...
persistent se_mag_lim;

% Set bool depending upon whether se_mag_lim has changed or not while
% accounting for the 1st run / cleared variable
if isempty(se_mag_lim)
    se_mag_lim = se_magnitude_limit;
    bool = 1;
elseif (se_magnitude_limit == se_mag_lim)
    bool = 0;
elseif (se_magnitude_limit ~= se_mag_lim)
    bool = 1;
end
se_mag_lim = se_magnitude_limit;
end

