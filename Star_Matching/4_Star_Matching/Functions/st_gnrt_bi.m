function st_bi = st_gnrt_bi(fe_output, n_fe_strs, Focal_Length)
    % Generates the body-frame vectors of the stars from the centroids
    % identified through means of Feature Extraction
    % Reference:
    % --------
    % Appendix B -  Erlank, Alexander O.. “Development of CubeStar : a
    % CubeSat-compatible star tracker.” (2013).
    % Parameters:
    % -----------
    % fe_output: ( (N, 3) - Matrix )
    %   The output of Feature Extraction block - which contains the
    %   centroids of the identified stars as well ID of the idetified star.
    %   The centroid is represented in $(X,Y)$ format, with the origin at the
    %   center of the sensor. 
    %   Unit of centroid: mm
    % n_fe_strs: (Integer)
    %   The number of stars identified by feature extraction
    % Focal_Length: (Float)
    %   The focal length of the optics system
    %   Unit: mm
    % Returns:
    % --------
    % st_bi: ( (N, 4) - Matrix )
    %   The body-frame vector of each corresponding star. It is a
    %   unit-vector represented in $(X,Y,Z)$ format, with the origin at the
    %   center of the sensor and positive z-axis pointing out of the lens.
    %   The first column corresponds to the index of the star as denoted in
    %   fe_output

    %% Code
    st_bi = zeros(n_fe_strs,4); % Initialize st_input

    for idx = 1:n_fe_strs
        %% Calculate Body-Frame Vectors
        rw = fe_output(idx, :); % Extract (i-th) row
        
        id = rw(1); % ID of identified star in fe_output
        x = rw(2); y = rw(3); % Extract (x,y) coordinates
        
        bi = [x, y, Focal_Length]; % Initialize Body-frame vector
        bi = bi / norm(bi); % Normalize Body-frame vector

        tmp = [id, bi]; % Initialize (i-th) row of st_bi

        st_bi(idx, :) = tmp; % Append row
    end
    
end