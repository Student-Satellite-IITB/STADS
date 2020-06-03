Quality Assurance Report
====

es_quest_common.m
----

### Iteration - 1

**Code Author:** Shashank Singh


**Review requested by:** Shashank Singh


**Reviewer:** Mitalee Oza


**Date of review:**	09/05/2020


**Permanent Links:**

1. https://github.com/1mitalee/STADS/blob/pdf-upload/Estimation/Functions/QuEST/es_quest_common.m

2. 

3. 


**QA suggestions:**

1. Note that the input to the estimation block consists of 2 matrices of size (N,4). The first column consists of star ids. The input to this algorithm is assumed to consist of (N,3) matrices. Therefore changes need to be made either in the main script by removing the first column of the input matrices to feed into this function or changes need to be made in this function. The former seems more convinient, so I am QA.ing the rest of the code according to that.

2. line 2: matrix K is not being calculated by this function

3. comments in the begining of the code: specify the data type (and the size of the arrays or matrices) of the inputs and outputs for better understanding

4. line 14: "m_B = zeros(v_p(2))", you can instead write this as "m_B = zeros(3)" because m_B will remain a (3,3) matrix irrespective of the format of the input that is, the size of the b_m matrix

5. line 16: for loop: Check if matrix summation can be directly done using the '+' operator. 'Sum' function might need to be used. Also check the syntax, matrix multiplication needs to take place between b_m(i,:)' and m_r(i,:) to generate a (3,3) matrix

6.line 24: Check syntax

7.line 32: write this v_a(i_rw) as v_a(i_rw,1)


**Implementation:**
> The changes implemented as suggested by the review points will be documented
*Eg:*1. All changes are implemented


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

================================================================
