
Quality Assurance Report
====

ca_preprocessing.m
----

### Iteration - 1

**Code Author:** KT Prajwal Pratiksh


**Review requested by:** KT Prajwal Pratiksh


**Reviewer:** Neilabh Banzal


**Date of review:**	15/05/2020


**Permanent Links:**

1. [ca_preprocessing.m](https://github.com/Jamun-Fanatic-Foreva/STADS/blob/a5c8b3f7faa5086019f0ebc7c9096d01c6978cfa/Catalogue/SKY2000/ca_preprocessing.m)

**QA suggestions:**

0. (Optional) Write the Full Forms of the variables you have named in short for others

1. Line 2: `SKY_C = readtable('.\Catalogue\SKY2000\Catalogues\SKY2000.csv');`
`Warning: Table variable names were modified to make them valid MATLAB identifiers. The original names are saved in the VariableDescriptions property. `

2. Line 5: `skip = 3; %Skip first <skip> rows` and `clm = SKY_C.RAJ2000(skip:end);` skips the first **2** rows, and starts from the 3rd row and *not* skips **3** rows.

3. Moreover, `SKY_C([1,2],:) = []` might be a better implementation to delete the first 2 rows. From then on, you can simply use `SKY_C(:,:)` instead of `SKY_C(skip:end,:)`

4. (Optional) Lines 12 - 13: `clm = SKY_C.RAJ2000(skip:end);`
`clm_new = split(clm); % Split at whitespaces`
A Cleaner Implementation could be: `clm = split(SKY_C.RAJ2000(3:end)) `

5. Lines 38-39: `sz = size(M_SC);`
`N = sz(1); % Number of rows in Master Star Catalogue`
Replace with - `size(M_SC, 1)` or `height(M_SC)` *(Works only for tables)*

6. Line 42: `tmp1 = rowfun(@ca_DMS2degrees, M_SC, 'InputVariables', [5,6,7], 'OutputVariableNames', {'DE'});`
Instead of `[5,6,7]`, use `{'DE_d' 'DE_m' 'DE_s'}` for ease of use *(Suppose in the future, a new variable gets added which shifts the position of your columns )*

7. Line 45: `tmp2 = rowfun(@ca_HMS2degrees, M_SC, 'InputVariables', [2,3,4], 'OutputVariableNames', {'RA'});`
Instead of `[2,3,4]`, use `{'RA_h' 'RA_m' 'RA_s'}` for ease of use *(Suppose in the future, a new variable gets added which shifts the position of your columns )*

8. You can append the columns straight away by using something like `T = [T, rowfun(...)]`

9. (Optional) Line 52: `val = transpose(1:N);` -> You can use `val = (1:N)'` too.

Overall, I feel it works correctly. There are a couple of places where the same thing can be done in a more compact and reader friendly manner.

<!---
**Implementation:**
> The changes implemented as suggested by the review points will be documented
*Eg:*1. All changes are implemented


**Post-QA Permanent Links:**

1.

2.

3.
====

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
> Any modifications/additions/deletions to be made to the code. It also includes any flaws/mistakes that need to be corrected in the code
*Eg:* 1. Add formula for func1 in comments

2. ‘+’ sign is missing in func2 line2

3. V_ not added for vector variable pos_i

4. Add definition of equinox in README file


**Implementation:**
> The changes implemented as suggested by the review points will be documented
*Eg:*1. All changes are implemented


**Post-QA Permanent Links:**

1.

2.

3.
====
--->