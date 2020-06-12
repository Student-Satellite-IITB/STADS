function deg = ca_HMS2degrees(H, M, S)
    % Converts the angle from H:M:S to degrees format 
    % Parameters:
    % -----------
    % H: (Double)
    %   Hour component 
    % M: (Double)
    %   Minute component 
    % S: (Double)
    %   Second component 
    % Returns:
    % --------
    % deg: (Double)
    %   Angle in degrees

    %% Code
    
    % Assert values of M and S
    assert(M <= 60, 'Invalid Value: ' + string(M));
    assert(S <= 60, 'Invalid Value: ' + string(S));
    
    total_sec = H*3600 + M*60 + S;
    deg = (total_sec*360)/86400; % Conversion Formula
end
