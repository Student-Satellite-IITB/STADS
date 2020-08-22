function AngDst_deg = st_calc_AngDst_deg(X1, Y1, Z1, X2, Y2, Z2)
    % Calculates the angular distance (in degrees) between two unit vectors
    % Parameters:
    % -----------
    % X1: (Float)
    %   X-Component of unit-vector - 1
    % Y1: (Float)
    %   Y-Component of unit-vector - 1
    % Z1: (Float)
    %   Z-Component of unit-vector - 1
    % X2: (Float)
    %   X-Component of unit-vector - 2
    % Y2: (Float)
    %   Y-Component of unit-vector - 2
    % Z2: (Float)
    %   Z-Component of unit-vector - 2
    % Returns:
    % --------
    % AngDst_deg: (Float)
    %   Angular distance between the two vectors in degrees

    %% Code
    v_1 = [X1; Y1; Z1];
    v_2 = [X2; Y2; Z2];

    AngDst_deg = rad2deg(  atan2( norm(cross(v_1, v_2)), dot(v_1, v_2) )  );
end