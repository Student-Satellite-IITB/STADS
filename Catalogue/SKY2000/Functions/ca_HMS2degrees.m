function deg = ca_HMS2degrees(H, M, S)
    % Converts the angle from H:M:S to degrees format 
    % Parameters:
    % -----------
    % H: Float
    %   Hour component 
    % M: Float
    %   Minute component 
    % S: Float
    %   Second component 
    % Returns:
    % --------
    % deg: Float
    %   Angle in degrees

    %% Code
    total_sec = H*3600 + M*60 + S;
    deg = (total_sec*360)/86400; % Conversion Formula
end