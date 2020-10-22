function m_A = sm_TM_CP_jacobian (n_centroid, sm_TM_CP_F, m_centroids)
%% Constructs the Jacobian Matrix given a set of centroids and star sensor's focal length
% Parameters 
% -------------
% n_centroid : int 
%   Number of centroids in the (k-1)th or the (k)th frame
% sm_TM_CP_F : double
%   Star sensor focal length (in cm)
% m_centroids : (N,2) - Matrix
%   Set of centroids from either the (k-1)th frame or the (k)th frame

% Returns 
% -------------
% m_A : (2N,3) - Matrix
%   Jacobian Matrix constructed using the Focal Length and the u,v coordinates from the set of centroids

%% Code

    % Initialise the Jacobian Matrix
    m_A = [];
    for i = 1 : n_centroid
        u = m_centroids(i,1);
        v = m_centroids(i,2);
        rw_1 = [(u*v)/sm_TM_CP_F -sm_TM_CP_F-(u^2/sm_TM_CP_F) v];
        rw_2 = [sm_TM_CP_F+(v^2/sm_TM_CP_F) -u*v/sm_TM_CP_F -u];
        m_A = [m_A; rw_1; rw_2];
    end
end