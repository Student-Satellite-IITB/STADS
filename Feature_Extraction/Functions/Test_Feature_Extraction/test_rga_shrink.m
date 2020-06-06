function [arr_final, r_values] = test_rga_shrink(arr_centroids, arr_exp_centroids, num_stars)
arr_final = zeros(num_stars, 7);
r_values = zeros(num_stars, 1);    
%loop to match stars
    for I=1:num_stars
        % calculating the dist between current coordinate and all
        % coordinates in arr_exp_centroids
        dist = sqrt(sum((arr_exp_centroids(:, 2:3) - arr_centroids(I, 2:3)).^2, 2));
        % the star which is nearest is the one it matches
        [r_values(I, 1), index] = min(dist);
        % storing the relevant data in arr_final
        arr_final(I, 1:3) = arr_centroids(I, :);
        arr_final(I, 4:6) = arr_exp_centroids(index, :);
        arr_final(I, 7) = r_values(I, 1);
    end
end
