function tests = test_fe_region_growth
% test_fe_region_growth for fe_region_growth.m
    tests = functiontests(localfunctions);
end

%function to tabulate
%input testCase from /Simulation/
function testCentroids(testCase)
clc
    % number of test cases
    n = 15;
    % max error (dist in pixels)
    r_allowed = 1;
    % array containing all errors
    r_all = [];
    for I = 1:n
        folder = "C:\Users\Shaun Zacharia\Desktop\SatLAB Project\STADS\Feature Extraction\"; 
        result_path = folder + "Test image results\TEST-RESULTS-SIM-3-IMAGE-"+I+".xlsx";
        %"IMAGE "+I  %output test case number
        imgpath = folder + "Test images\Image_"+I+"\se_Image_"+I+".mat";
        outpath = folder + "Test images\Image_"+I+"\se_Verification_"+I+".mat";
        test_case = load(imgpath);    %loading input of test case
        arr_exp_centroids = load(outpath);  %loading expected output of test case

        test_case = test_case.se_Image_Mat; %changing struct to double
        arr_exp_centroids = arr_exp_centroids.se_T_Verification;    %changing struct to double
        arr_exp_centroids = table2array(arr_exp_centroids); %changing table to array

        [arr_centroids] = fe_region_growth(test_case); %running the function with given input
        num_stars = size(arr_centroids, 1); %num_stars = number of stars identified by the code
        [arr_final, r_values] = test_rga_shrink(arr_centroids, arr_exp_centroids, num_stars);
        %arr_final
        r_out = ["Size R", "Mean R", "Std R", "Max R"; size(r_values,1), mean(r_values), std(r_values), max(r_values); "THRESHOLD", "MIN_PIXELS", "MAX_PIXELS", "R ALLOWED"; 10, 3, 150, r_allowed; "FE - num_stars", num_stars, "SE - num_stars", size(arr_exp_centroids,1)];
        %r_out
        header_excel = ["FE - star ID", "FE - x", "FE - y", "SE - star ID", 'SE - x', 'SE - y', 'R'; 0, 0, 0, 0, 0, 0, 0];
        writematrix(header_excel, result_path, 'Sheet', 1, 'Range', 'A1:G2');
        writematrix(arr_final, result_path, 'Sheet', 1, 'Range', 'A2:G101');
        writematrix(r_out, result_path, 'Sheet', 1, 'Range', 'I2:L6');
        r_all = [r_all; r_values];
    end
    % the mean and standard deviation of the error should be less than 0.3
    verifyLessThanOrEqual(testCase, [mean(r_all), std(r_all)], 0.3);
end
