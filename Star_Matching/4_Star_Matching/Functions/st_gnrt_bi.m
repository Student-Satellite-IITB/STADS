function st_bi = st_gnrt_bi(fe_output, fe_n_str, Focal_Length)
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
    % fe_n_str: (Integer)
    %   The number of stars identified by feature extraction
    % Focal_Length: (Float)
    %   The focal length of the optics system
    %   Unit: mm
    % Returns:
    % --------
    % st_bi: ( (N, 4) - Matrix )
    %   Generates the body-frame vectors for all the stars identified by
    %   Feature Extraction using the centroids. The body-frame vectors are
    %   unit-vectors represented in $(X,Y,Z)$ format, with the origin at the 
    %   center of the sensor and positive z-axis pointing out of the lens.
    %   The columns of matrix are as follows:
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}, 3^{rd}, 4^{th}$ columns - $(X,Y,Z)$ unit vector

    %% Code
    st_bi = zeros(fe_n_str,4); % Initialize st_input

    for idx = 1:fe_n_str
        %% Calculate Body-Frame Vectors
        rw = fe_output(idx, :); % Extract (i-th) row
        
        id = rw(1); % ID of identified star in fe_output
        x = rw(2); y = rw(3); % Extract (x,y) coordinates
        
        bi = [x, y, Focal_Length]; % Initialize Body-frame vector
        bi = bi / norm(bi); % Normalize Body-frame vector

        tmp = [id, bi]; % Initialize (i-th) row of st_bi

        st_bi(idx, :) = tmp; % Append row
    end
    
    % Shift body-frame vectors
    st_bi(:, 2:4) = circshift(st_bi(:, 2:4), [0, 1]);
end