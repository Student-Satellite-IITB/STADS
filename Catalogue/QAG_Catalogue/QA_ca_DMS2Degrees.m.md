
Quality Assurance Report
====

ca_DMS2degrees.m
----

### Iteration - 1

**Code Author:** KT Prajwal Pratiksh


**Review requested by:** KT Prajwal Pratiksh


**Reviewer:** Neilabh Banzal


**Date of review:**	17/05/2020


**Permanent Links:**

1. [ca_DMS2degrees.m](https://github.com/Jamun-Fanatic-Foreva/STADS/blob/a5c8b3f7faa5086019f0ebc7c9096d01c6978cfa/Catalogue/SKY2000/Functions/ca_DMS2degrees.m)

**QA suggestions:**

1. Lines 5, 7, 9: There is no data type in Matlab called `Float`. Check documentation or run `help class`

2. [Sign Function](https://in.mathworks.com/help/matlab/ref/sign.html) to be used instead of user-defined function for compactness and robustness (Suppose in a commit, somebody edits the user defined function?)

3. Use assert commands to ensure that only valid input goes in. Right now, I could use an input of 100 seconds, which makes no sense at all.

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