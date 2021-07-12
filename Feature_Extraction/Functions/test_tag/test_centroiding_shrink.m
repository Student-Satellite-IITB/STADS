%function to match stars
function [arr_final, r_values] = test_centroiding_shrink(arr_centroids, arr_exp_centroids, r_allowed, num_stars)
    arr_first = zeros(num_stars, 7);    
    arr_first = arr_first - 2000;   %to set a basis to test against later in the code
    K=0;    %iterator variable to eliminate excess rows generated
    
    %loop to match stars
    for I=1:num_stars
        for J=1:size(arr_exp_centroids,1)
            r_actual = sqrt((arr_centroids(I,2) - arr_exp_centroids(J,2))^2 + (arr_centroids(I,3) - arr_exp_centroids(J,3))^2); %find radial distance between actual and expected centroids
            if r_actual < r_allowed
                K=K+1;
                arr_first(I,1) = arr_centroids(I,1);
                arr_first(I,2) = arr_centroids(I,2);
                arr_first(I,3) = arr_centroids(I,3);
                arr_first(I,4) = arr_exp_centroids(J,1);
                arr_first(I,5) = arr_exp_centroids(J,2);
                arr_first(I,6) = arr_exp_centroids(J,3);
                arr_first(I,7) = r_actual;
            end
        end
    end
    arr_final=zeros(K,7);   %final output array, K might be greater than number of stars matched
    
    %loop to remove excess rows generated
    J=0;
    for I=1:num_stars
        if arr_first(I,7) ~= -2000  %if -2000, element has remained unchanged since beginning of function
            J = J + 1;
            arr_final(J,:) = arr_final(J,:) + arr_first(I,:);
        end
    end
    arr_final = arr_final(1:J,:);   %J = final number of stars matched
    r_values=arr_final(:,7);    %initialising separate column r_values for ease of use
end