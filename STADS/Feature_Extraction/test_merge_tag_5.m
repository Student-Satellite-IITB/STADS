%test code for merge_tag_5

function tests = merge_tag_5
tests = functiontests(localfunctions);
end

function testConstants(testCase)
    n=1;   %number of test cases
    for I=1: n
        test_case_1 = load("C:/Users/aravi/OneDrive/Documents/MATLAB/test_cases/test_"+I+"/constants.csv");
        [num_stars, ~] = merge_tag_5(test_case_1);
        expected_constants = load("C:/Users/aravi/OneDrive/Documents/MATLAB/test_cases/test_"+I+"/output.csv");
        expected_constants = expected_constants + [1];
        verifyEqual(testCase, [num_stars], expected_constants);
    end
end

function testCoordinates(testCase)
    n=1;   %number of test cases
    for I=1: n
        test_case_1 = load("C:/Users/aravi/OneDrive/Documents/MATLAB/test_cases/test_"+I+"/sums.csv");
        [~, arr_star_coordinates] = tag_2(test_case_1);
        arr_expected_coordinates = int32(load("C:/Users/aravi/OneDrive/Documents/MATLAB/test_cases/test_"+I+"/output.csv"));
        verifyEqual(testCase, arr_star_coordinates, arr_expected_coordinates);
    end
end
