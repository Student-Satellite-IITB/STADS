function [X, Y, Z] = ca_RA_DE_2_CartVect(RA, DE)
    % Converts a given Right-Ascension and Declination coordinate to a unit
    % vector in a rectilinear coordinate system - (X, Y, Z).
    % The (X, Y, Z) coordinate system definition corresponds to the
    % projection of the Earth’ North Pole onto the celestial sphere as the
    % Z-axis, and the vernal equinox as the X-axis,at epoch ICRS2000, with
    % the Y-axis completing the right-handed orthonormal coordinate system: 
    % Z = X \times Y
    % Reference:
    % ----------
    % Refer 4.1.1 - Computer Science Corporation, "SKYMAP Requirements, 
    % Functional, and Mathematical Specifications, Volume 3, Revision 3". 
    % (1999). 
    % Parameters:
    % -----------
    % RA: Float
    %   Right-Ascension component - in degrees
    % DE: Float
    %   Declination component - in degrees

    %% Code
    X = cosd(RA) * cosd(DE);
    Y = sind(RA) * cosd(DE);
    Z = sind(DE);
end