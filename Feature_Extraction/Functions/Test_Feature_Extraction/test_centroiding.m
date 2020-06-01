function tests = test_centroiding
%test code for centroiding.m
tests = functiontests(localfunctions);
end

function testCentroids(testCase)
    n = 10;
    imgpath = "C:/";
    outpath = "C:/";
    for I = 1: n
        test_case_1 = load(imgpath);    %loading input of test case
        arr_exp_centroids = load(outpath);  %loading expected output of test case
        [arr_centroids] = centroiding(test_case_1); %simulating the function with given input
        abs_error = abs(arr_exp_centroids - arr_centroids(:, 2:3)); %finding the absolute error between the two outputs
        verifyLessThan(testCase, abs_error, 10^-12);    %successful if error is less than 10e-12 the width of a pixel
        %rms and max error values are required for the star matching and
        %estimation team   
        %square around (x0,y0)
        %sort by brightness?
    end
end