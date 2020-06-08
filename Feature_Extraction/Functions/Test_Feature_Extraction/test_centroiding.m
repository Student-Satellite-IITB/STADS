function tests = test_centroiding
%test code for centroiding.m
tests = functiontests(localfunctions);
end

%function to tabulate
%input testCase from /Simulation/
%Add THRESHOLD to fe_tag.m and MIN_PIXELS to fe_merge_tag.m
function testCentroids(testCase)
    clc    %clear screen
    
    n = 15; %number of test cases
    r_allowed = 1; %allowed error
    
    for I = 1: n
        filename = "TEST-RESULTS-SIM-3-IMAGE-"+I+".xlsx";
        %"IMAGE "+I  %output test case number
        imgpath = "C:/Users/aravi/OneDrive/Documents/MATLAB/Simulation_3/Image_"+I+"/se_Image_"+I+".mat";   %input path
        outpath = "C:/Users/aravi/OneDrive/Documents/MATLAB/Simulation_3/Image_"+I+"/se_Verification_"+I+".mat";    %output path
        test_case = load(imgpath);    %loading input of test case
        arr_exp_centroids = load(outpath);  %loading expected output of test case
        
        test_case = test_case.se_Image_Mat; %changing struct to double
        arr_exp_centroids = arr_exp_centroids.se_T_Verification;    %changing struct to double
        arr_exp_centroids = table2array(arr_exp_centroids); %changing table to array
        
        [arr_centroids] = centroiding(test_case); %simulating the function with given input
        num_stars = size(arr_centroids, 1); %num_stars = number of stars identified by the code
        %[num_stars, size(arr_exp_centroids,1)]   %size(arr_exp_centroids, 1) = number of stars according to the test case
        [arr_final, r_values] = test_centroiding_shrink(arr_centroids, arr_exp_centroids, r_allowed, num_stars);
        %arr_final
        r_out = ["Size R", "Mean R", "Std R", "Max R"; size(r_values,1), mean(r_values), std(r_values), max(r_values); "THRESHOLD", "MIN_PIXELS", "MAX_PIXELS", "R ALLOWED"; 10, 3, 150, r_allowed; "FE - num_stars", num_stars, "SE - num_stars", size(arr_exp_centroids,1)];
        %r_out
        header_excel = ["FE - star ID", "FE - x", "FE - y", "SE - star ID", 'SE - x', 'SE - y', 'R'; 0, 0, 0, 0, 0, 0, 0]
        writematrix(header_excel, filename, 'Sheet', 1, 'Range', 'A1:G2');
        writematrix(arr_final, filename, 'Sheet', 1, 'Range', 'A2:G101');
        writematrix(r_out, filename, 'Sheet', 1, 'Range', 'I2:L6');
    end
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
