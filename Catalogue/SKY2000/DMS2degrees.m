function deg = DMS2degrees(D, M, S)
    % Converts the angle from D:M:S to degrees format 
    % Parameters:
    % -----------
    % D: Float
    %   Degree component 
    % M: Float
    %   Minute component 
    % S: Float
    %   Second component 
    % Returns:
    % --------
    % deg: Float
    %   Angle in degrees

    %% Code
    if D < 0
        SGN = -1;
    else
        SGN = 1;
    end
    
    deg = SGN * ( abs(D) + abs(M)/60 + abs(S)/3600 ); % Conversion Formula
end