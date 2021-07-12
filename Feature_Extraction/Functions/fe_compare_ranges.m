function [bool_comp] = fe_compare_ranges(start_1, end_1, start_2, end_2)
%{
returns true if the two ranges intersect at some pixel, returns false
otherwise
%}

    bool_comp = (start_1<=start_2 && start_2<=end_1) || (start_1 <= end_2 && end_2 <= end_1) ||  (start_2<=start_1 && end_1<=end_2);
end