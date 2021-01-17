function [RA, DE] = ca_CartVect_2_RA_DE(X, Y, Z)
    % This function converts a given unit vector in a rectilinear 
    % coordinate system - $(X, Y, Z)$ to Right-Ascension and Declination 
    % components.
    % The $(X, Y, Z)$ coordinate system definition corresponds to the 
    % projection of the Earth’ North Pole onto the celestial sphere as the 
    % $Z$-axis, and the vernal equinox as the $X$-axis,at epoch ICRS2000, 
    % with the $Y$-axis completing the right-handed orthonormal coordinate 
    % system:
    % \[Z = X \times Y\]
    %
    % Parameters:
    % -----------
    % X: (Float)
    %   X - component of the unit vector
    % Y: (Float)
    %   Y - component of the unit vector
    % Z: (Float)
    %   Z - component of the unit vector
    %% Code
    RA = atan2d(Y,X);
    DE = asind(Z);
end