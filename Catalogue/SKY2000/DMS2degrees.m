function deg = DMS2degrees(D, M, S)
    % Converts the angle from D:M:S to degrees format 
    % Parameters:
    % -----------
    % Dec_d: Float
    %   Degree component 
    % Dec_m: Float
    %   Minute component 
    % Dec_s: Float
    %   Second component 
    % Returns:
    % --------
    % Dec: Float
    %   Angle in degrees

    %% Code
    if D < 0
        SGN = -1;
    else
        SGN = 1;
    end
    
    deg = SGN * ( abs(D) + abs(M)/60 + abs(S)/3600 ); % Conversion Formula
end