function tests = test_tag_2
%TEST_TAG_2 test code for tag_2.m
tests = functiontests(localfunctions);
end

function testSums(testCase)
    N=9;
    for n =1:N
        test_case_1 = load("C:/Users/Millen/OneDrive/Documents/SSP Elec/MATLAB Codes/STADS/Feature_Extraction/Functions/Test_Feature_Extraction/test_case_" +n+ "/input.csv");
        [arr_sums, ~, ~] = tag_2(test_case_1);
        arr_expected_sums = int32(load("C:/Users/Millen/OneDrive/Documents/SSP Elec/MATLAB Codes/STADS/Feature_Extraction/Functions/Test_Feature_Extraction/test_case_" + n +"/sums.csv"));
        verifyEqual(testCase, arr_sums, arr_expected_sums);
    end
end

function testConstants(testCase)
     N=9;
    for n =1:N
        test_case_1 = load("C:/Users/Millen/OneDrive/Documents/SSP Elec/MATLAB Codes/STADS/Feature_Extraction/Functions/Test_Feature_Extraction/test_case_" + n +"/input.csv");
        [~, num_tags, num_final_tags] = tag_2(test_case_1);
        arr_expected_constants = load("C:/Users/Millen/OneDrive/Documents/SSP Elec/MATLAB Codes/STADS/Feature_Extraction/Functions/Test_Feature_Extraction/test_case_" + n + "/constants.csv");
        arr_expected_constants = arr_expected_constants+[1, 1];
        verifyEqual(testCase, [num_tags, num_final_tags], arr_expected_constants);
    end
end

