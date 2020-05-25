function tests = test_merge_tag_5
%test_merge_tag_5 test code for merge_tag_5
tests = functiontests(localfunctions);
end

function testCoords(testCase)
    n=8;
    for I = 0:n
        test_case_1 = load("C:/Users/aravi/OneDrive/Documents/MATLAB/test_cases/test_" +I+ "/sums.csv");
        a = load("C:/Users/aravi/OneDrive/Documents/MATLAB/test_cases/test_" +I+ "/constants.csv");
        [arr_star_coordinates, ~] = merge_tag_6(test_case_1(1), test_case_1(2), test_case_1(3), test_case_1(4), test_case_1(5), a(1), a(2));
        arr_expected_coordinates = double(load("C:/Users/aravi/OneDrive/Documents/MATLAB/test_cases/test_" +I+ "/output_coordinates.csv"));
        arr_expected_coordinates2 = arr_expected_coordinates(:,1:2);
        check = abs(arr_expected_coordinates2 - arr_star_coordinates);
        verifyLessThan(testCase, check, 10^-12);
        %verifyEqual(testCase, arr_star_coordinates, arr_expected_coordinates2);
    end
end

function testConstants(testCase)
     n=8;
    for I = 0:n
        test_case_1 = load("C:/Users/aravi/OneDrive/Documents/MATLAB/test_cases/test_" +I+ "/sums.csv");
        a = load("C:/Users/aravi/OneDrive/Documents/MATLAB/test_cases/test_" +I+ "/constants.csv");
        [, num_stars] = merge_tag_6(test_case_1(1), test_case_1(2), test_case_1(3), test_case_1(4), test_case_1(5), a(1), a(2));
        expected_stars = load("C:/Users/aravi/OneDrive/Documents/MATLAB/test_cases/test_" +I+ "/output_num.csv");
        verifyEqual(testCase, num_stars, expected_stars);
    end
end
