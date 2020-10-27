function sm_TM_CP_predmat = sm_TM_CP_main (sm_TM_CP_prevmat, sm_TM_CP_currmat, sm_TM_CP_F)
%% Predicts the centroids in the next frame given centroids of previous two frames (with same STAR IDs)
% Parameters
% --------------
% sm_TM_CP_prevmat : (N,2) - Matrix
%   Centroids from (k-1)th frame
% sm_TM_CP_currmat : (N,2) - Matrix
%   Centroids from (k)th frame
% sm_TM_CP_F : double
%   Star sensor focal length (in cm)
%
% Returns
% --------------
% sm_TM_CP_predmat : (N,2) - Matrix
%   Predicted centroids in the (k+1)th frame

%% Code

    % Number of common centroids between k-1 and k frames
    n_centroid = size(sm_TM_CP_prevmat, 1);

    % Compute the difference in u and v coordinates for each centroid in k-1th and kth frames
    m_delta_old = [];
    for i_rw = 1 : n_centroid
        delta_u = sm_TM_CP_currmat(i_rw,1) - sm_TM_CP_prevmat(i_rw,1);
        delta_v = sm_TM_CP_currmat(i_rw,2) - sm_TM_CP_prevmat(i_rw,2);
        m_delta_old = [m_delta_old ; delta_u ; delta_v];
    end

    % Construct the Jacobian matrix using the centroids from the (k-1)th frame and the Star Sensor focal length
    m_A_old = sm_TM_CP_jacobian (n_centroid, sm_TM_CP_F, sm_TM_CP_prevmat);

    % Compute the Roll, Pitch and Yaw (Slew Rate) using the Jacobian matrix and the delta matrix

    m_M = transpose(m_A_old) * m_A_old;

    v_slew = (m_M \ transpose(m_A_old)) * m_delta_old; % Slew rate vector with the Roll, Pitch and Yaw of the Star Tracker between the (k-1)th and (k)th frames

    % Construct the Jacobian matrix using the centroids from the (k)th frame and the Star Sensor focal length
    m_A_new = sm_TM_CP_jacobian (n_centroid, sm_TM_CP_F, sm_TM_CP_currmat);

    % Compute the difference in u and v coordinates for each centroid in kth and (k+1)th frames
    m_delta_new = m_A_new * v_slew;

    % Compute the matrix of predicted centroids in the (k+1)th frame by adding the new delta matrix to the centroids in (k)th frame

    sm_TM_CP_predmat = [];

    for i_rw = 1 : n_centroid
        u_pred = sm_TM_CP_currmat(i_rw,1) + m_delta_new((2*i_rw)-1);
        v_pred = sm_TM_CP_currmat(i_rw,2) + m_delta_new(2*i_rw);
        sm_TM_CP_predmat = [sm_TM_CP_predmat; u_pred v_pred];
    end

end



