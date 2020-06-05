function tests = test_centroiding
%test code for centroiding.m
tests = functiontests(localfunctions);
end

%{
%find mean, standard deviation and maximum value of r
function [mean_r, sd_r, max_r] = find_stats(arr_r)
    sum_r = 0;
    for I=1: size(arr_r)
        sum_r = sum_r + arr_r(I);
    end
    mean_r = sum_r/size(arr_r);
    sq_sum_r = 0;
    max_r = 0;
    for I=1: size(arr_r)
        if max_r < abs(mean_r - arr_r(I))
            max_r = (mean_r - arr_r(I));
        end
        sq_sum_r = sum_r + (mean_r - arr_r(I))^2;
    end
    sd_r = sqrt(sq_sum_r/size(arr_r));
end

%find radial distance between (x0,y0) and (x,y)
function [r] = find_r(x0,y0,x,y)
    r = sqrt((x-x0)^2 + (y-y0)^2);
end

%function to sort
function [arr_sorted] = sort_yx(arr_sorted)
    for I=1:size(arr_sorted,1) - 1
        for J=1:size(arr_sorted,1) - I - 1
            if arr_sorted(J,1) < arr_sorted(J+1,1)
                t = arr_sorted(J, :);
                arr_sorted(J, :) = arr_sorted(J+1, :)
                arr_sorted(J+1, :) = t;
            end
        end
    end
    for I=1: size(arr_sorted,1) - 1
        for J=1: size(arr_sorted,1) - I - 1
            if arr_sorted(J,2) > arr_sorted(J+1,2)
                t = arr_sorted(J, :);
                arr_sorted(J, :) = arr_sorted(J+1, :)
                arr_sorted(J+1, :) = t;
            end
        end
    end
end
%}


%function to tabulate
%input testCase from /Simulation/
%Add THRESHOLD to fe_tag.m and MIN_PIXELS to fe_merge_tag.m
function testCentroids(testCase)
clc
    n = 1; %number of test cases
    r_allowed =1; %allowed error
    for I = 1: n
        "IMAGE "+I  %output test case number
        imgpath = "C:/Users/aravi/OneDrive/Documents/MATLAB/Simulation_3/Image_"+I+"/se_Image_"+I+".mat";   %input path
        outpath = "C:/Users/aravi/OneDrive/Documents/MATLAB/Simulation_3/Image_"+I+"/se_Verification_"+I+".mat";    %output path
        test_case = load(imgpath);    %loading input of test case
        test_case = test_case.se_Image_Mat; %changing struct to double
        arr_exp_centroids = load(outpath);  %loading expected output of test case
        arr_exp_centroids = arr_exp_centroids.se_T_Verification;    %changing struct to double
        arr_exp_centroids = table2array(arr_exp_centroids); %changing table to array
        [arr_centroids] = centroiding(test_case); %simulating the function with given input
        num_stars = size(arr_centroids, 1); %num_stars = number of stars according to the code
        [num_stars, size(arr_exp_centroids,1)]   %size(arr_exp_centroids, 1) = number of stars according to the test case
        [arr_final, r_values] = test_centroiding_shrink(arr_centroids, arr_exp_centroids, r_allowed, num_stars);
        arr_final;
        ["size", "mean", "std", "max"; size(r_values,1), mean(r_values), std(r_values), max(r_values)] 
    end
end
