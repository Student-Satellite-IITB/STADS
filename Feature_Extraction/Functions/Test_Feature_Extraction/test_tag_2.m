function tests = test_tag_2
%TEST_TAG_2 test code for tag_2.m
tests = functiontests(localfunctions);
end

function testSums(testCase)
    N=1;
    for n =1:N
        test_case = importdata("C:/Users/Millen/OneDrive/Documents/SSP Elec/MATLAB Codes/STADS/Feature_Extraction/Functions/Test_Feature_Extraction/moderate/moderate_10x100/input.csv");
        [arr_sums, ~, ~] = tag_2(test_case);
        arr_expected_sums = int32(load("C:/Users/Millen/OneDrive/Documents/SSP Elec/MATLAB Codes/STADS/Feature_Extraction/Functions/Test_Feature_Extraction/moderate/moderate_10x100/sums.csv"));
        %temp = arr_expected_sums(:, 1);
        %arr_expected_sums(:, 1) = arr_expected_sums(:, 2);
        %arr_expected_sums(:, 2) = temp;
        verifyEqual(testCase, arr_sums, arr_expected_sums);
    end
end

function testConstants(testCase)
     N=9;
    for n =1:N
        test_case = importdata("C:/Users/Millen/OneDrive/Documents/SSP Elec/MATLAB Codes/STADS/Feature_Extraction/Functions/Test_Feature_Extraction/moderate/moderate_10x100/input.csv");
        [~, num_tags, num_final_tags] = tag_2(test_case);
        arr_expected_constants = load("C:/Users/Millen/OneDrive/Documents/SSP Elec/MATLAB Codes/STADS/Feature_Extraction/Functions/Test_Feature_Extraction/moderate/moderate_10x100/constants.csv");
        arr_expected_constants = arr_expected_constants+[1, 1];
        verifyEqual(testCase, [num_tags, num_final_tags], arr_expected_constants);
    end
end

