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
    r_allowed = 1; %allowed errors
    for I = 1: n
        filename = "EXP-OUT-SIM-3-IMAGE-"+I+".mat";
        var_name = "arr_exp_final_image_"+I;
        "IMAGE "+I  %output test case number
        imgpath = "C:/Users/aravi/OneDrive/Documents/MATLAB/Simulation_3/Image_"+I+"/se_Image_"+I+".mat";   %input path
        outpath = "C:/Users/aravi/Desktop/IITB/SSP/STADS Feature Extraction/centroids_"+I+".csv";    %output path
        test_case = load(imgpath);    %loading input of test case
        arr_exp_centroids = load(outpath);  %loading expected output of test case
        
        test_case = test_case.se_Image_Mat; %changing struct to double
               
        [arr_centroids] = fe_centroiding_2(test_case); %simulating the function with given input
        num_stars = size(arr_centroids, 1); %num_stars = number of stars identified by the code
        [num_stars, size(arr_exp_centroids,1)]   %size(arr_exp_centroids, 1) = number of stars according to the test case
        [arr_final, r_values] = test_centroiding_shrink(arr_centroids, arr_exp_centroids, r_allowed, num_stars);
        arr_final;
        %[arr_centroids, arr_exp_centroids]
        r_out = ["Size R", "Mean R", "Std R", "Max R"; size(r_values,1), mean(r_values), std(r_values), max(r_values); "THRESHOLD", "MIN_PIXELS", "MAX_PIXELS", "R ALLOWED"; 10, 3, 150, r_allowed; "FE - num_stars", num_stars, "SE - num_stars", size(arr_exp_centroids,1)];
        r_out;
    end
end