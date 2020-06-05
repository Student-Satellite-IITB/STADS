function tests = test_centroiding
%test code for centroiding.m
tests = functiontests(localfunctions);
end

%{
%function to sort
%order of preference: 1) y axis descending, 2) x axis ascending
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
    clc    %clear screen
    
    n = 1; %number of test cases
    r_allowed =1; %allowed error
    
    for I = 1: n
        "IMAGE "+I  %output test case number
        imgpath = "C:/Users/aravi/OneDrive/Documents/MATLAB/Simulation_3/Image_"+I+"/se_Image_"+I+".mat";   %input path
        outpath = "C:/Users/aravi/OneDrive/Documents/MATLAB/Simulation_3/Image_"+I+"/se_Verification_"+I+".mat";    %output path
        test_case = load(imgpath);    %loading input of test case
        arr_exp_centroids = load(outpath);  %loading expected output of test case
        
        test_case = test_case.se_Image_Mat; %changing struct to double
        arr_exp_centroids = arr_exp_centroids.se_T_Verification;    %changing struct to double
        arr_exp_centroids = table2array(arr_exp_centroids); %changing table to array
        
        [arr_centroids] = centroiding(test_case); %simulating the function with given input
        num_stars = size(arr_centroids, 1); %num_stars = number of stars identified by the code
        [num_stars, size(arr_exp_centroids,1)]   %size(arr_exp_centroids, 1) = number of stars according to the test case
        [arr_final, r_values] = test_centroiding_shrink(arr_centroids, arr_exp_centroids, r_allowed, num_stars);
        arr_final;
        ["size", "mean", "std", "max"; size(r_values,1), mean(r_values), std(r_values), max(r_values)] 
    end
end
