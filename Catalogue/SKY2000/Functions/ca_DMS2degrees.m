function deg = ca_DMS2degrees(D, M, S)
    % Converts the angle from D:M:S to degrees format 
    % Parameters:
    % -----------
    % D: (Double)
    %   Degree component 
    % M: (Double)
    %   Minute component 
    % S: (Double)
    %   Second component 
    % Returns:
    % --------
    % deg: (Double)
    %   Angle in degrees

    %% Code
    if D < 0
        SGN = -1;
    else
        SGN = 1;
    end
    
    % Assert values of M and S
    assert(M <= 60, 'Invalid Value: ' + string(M));
    assert(S <= 60, 'Invalid Value: ' + string(S));
    
    % Convert to degrees
    deg = SGN * ( abs(D) + abs(M)/60 + abs(S)/3600 ); % Conversion Formula
end
