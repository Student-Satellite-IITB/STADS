function [cos_ang_dist] = sm_TM_calc_angdist (id_centroid_1, id_centroid_2, is_id, sm_GD_SC, sm_TM_CP_F)

    if is_id==true
        % call the guide star catalogue for accessing the star unit vectors
        v1 = sm_GD_SC(id_centroid_1,2:end);
        v2 = sm_GD_SC(id_centroid_2,2:end);
        cos_ang_dist = dot(v1, v2)/(norm(v1)*norm(v2));
    else
        % convert the 2D centroids to 3D star unit vectors
        v1 = [id_centroid_1 sm_TM_CP_F];
        v2 = [id_centroid_2 sm_TM_CP_F];
        cos_ang_dist = dot(v1, v2)/(norm(v1)*norm(v2));
    end
end