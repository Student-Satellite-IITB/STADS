function tests = test_centroiding_2
%test code for fe_centroiding_2.m
tests = functiontests(localfunctions);
end

function testCentroids(~)
    clc    %clear screen
    THRESHOLD = 14;
    STAR_MIN_PIXEL = 3;
    STAR_MAX_PIXEL = 50;
    n = 15; %number of test cases
    r_allowed = 1; %allowed error
    arr_final_out = zeros(n+1, 12);
    M=0;
    save('constants_feature_extraction_3.mat', 'THRESHOLD', 'STAR_MIN_PIXEL', 'STAR_MAX_PIXEL');
    load('constants_feature_extraction_2.mat', 'PIXEL_WIDTH');
    for I = 1: n
        imgpath = "C:/Users/aravi/OneDrive/Documents/MATLAB/Simulation_3/Image_"+I+"/se_Image_"+I+".mat";   %input path
        outpath = "C:/Users/aravi/OneDrive/Documents/MATLAB/Simulation_3/Image_"+I+"/se_Verification_"+I+".mat";    %output path
        outfilename = "M" + STAR_MIN_PIXEL + "_T" + THRESHOLD + ".xlsx";    %FE_out filename
        matfilename = "st_input_"+I;    %ST_in filename
        
        %-----LOAD TEST CASES-----
        "IMAGE " + I  %output test case number
        test_case = load(imgpath);    %loading input of test case
        arr_exp_centroids = load(outpath);  %loading expected output of test case
        test_case = test_case.se_Image_Mat; %changing struct to double
        arr_exp_centroids = arr_exp_centroids.se_T_Verification;    %changing struct to double
        arr_exp_centroids = table2array(arr_exp_centroids); %changing table to array
        
        %-----SIMULATION------
        [arr_centroids] = fe_centroiding_2(test_case); %simulating the function with given input
        num_stars = size(arr_centroids, 1); %num_stars = number of stars identified by the code
        
        %-----TESTING-----
        [arr_final, r_values] = test_centroiding_shrink_3(arr_centroids, arr_exp_centroids, r_allowed, num_stars);
        %for r_out_2, use test_centroiding_shrink_3.m()
        r_out_2 = [mean(r_values), std(r_values), max(r_values), size(r_values,1), num_stars, size(arr_exp_centroids,1)];
        [size(r_values,1), num_stars, size(arr_exp_centroids,1)];   % Stars Matched, Stars Identified, Stars Actual
        
        %-----FINAL OUTPUT PARAMETERS-----
        M = max(0, max(arr_final(:,4))); %Calculate max Star_ID for given simulation
        A = arr_final(:,1:4);            %FE_STAR_ID   X   Y   SE_STAR_ID
        A(:,2:3) = PIXEL_WIDTH * A(:,2:3);  %Scaling output by width of a pixel
        arr_final_out(I,:) = r_out_2;   
        
        %-----INPUT FOR ST-----
        %save(matfilename,'A')
    end
    
    M;
    
    %-----OUTPUT FOR SCRUTINISING-----
    arr_final_out(n+2,1:6) = mean(arr_final_out(1:n,1:6));
    arr_final_out(n+2,7:9) = max(arr_final_out(1:n,7:9));
    arr_final_out(n+2,10:12) = sum(arr_final_out(1:n,10:12));
    
    header_excel = ["Mean_r", "Mean_x", "Mean_y", "STD_r", 'STD_x', 'STD_y', 'Max_r', 'Max_x', 'Max_y', 'Num_Mat', 'Num_Id', 'Num_Act'];
    range_excel = "A2:L" + (n + 3);
    
    %-----SAVE SPREADSHEET-----
    %writematrix(header_excel, outfilename, 'Sheet', 1, 'Range', 'A1:L1');
    %writematrix(arr_final_out, outfilename, 'Sheet', 1, 'Range', range_excel);
end