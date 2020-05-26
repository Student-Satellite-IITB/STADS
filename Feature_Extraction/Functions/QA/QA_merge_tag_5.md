Quality Assurance Report
====

Code_name.m
----

### Iteration - 1

**Code Author:** Aravind


**Review requested by:** Aravind


**Reviewer:** Millen


**Date of review:**	25/05/2020


**Permanent Links:**

1. https://github.com/bvcxz1/STADS/blob/6dc41416d61ecd0b7e860c8fb64128dd9f300e49/Feature_Extraction/Functions/merge_tag_3.m


**QA suggestions:**
- The length of the star coordinates array is bounded to be under num_tag, so it should be alloted memory appropriately
- The iterator variable in both loops should be renamed to appropriately prefixed iterator variables, like i_find_centroids.
- All arrays should have an `arr_` prefix



**Implementation:**
> arr_star_coordinates = zeros(num_tags, 2); %(k, 1)=pos_x (k,2)=pos_y

> for i_first_loop=1:num_tag
> ...
>end

>arr_tot_sum_x = zeros(num_final_tags,1);
arr_tot_sum_y = zeros(num_final_tags,1);
arr_tot_weights = zeros(num_final_tags,1);
arr_tot_pixels = zeros(num_final_tags,1);

**Post-QA Permanent Links:**

1.

2.

3.

================================================================

### Iteration - 2

**Code Author:** Name of the author of the original code


**Review requested by:** Name of the person who is requesting the review *Eg: PQR*


**Reviewer:** Name of the allotted reviewer


**Date of review:**	DD/MM/YYYY


**Permanent Links:**

1. 

2. 

3. 


**QA suggestions:**



**Implementation:**
> The changes implemented as suggested by the review points will be documented
*Eg:*1. All changes are implemented


**Post-QA Permanent Links:**

1.

2.

3.

================================================================



