Quality Assurance Report
====

es_quest_newton.m
----

### Iteration - 1

**Code Author:** Shashank Singh


**Review requested by:** Shashank Singh


**Reviewer:** Mitalee Oza


**Date of review:**	09/05/2020


**Permanent Links:**

1. https://github.com/1mitalee/STADS/blob/pdf-upload/Estimation/Functions/QuEST/es_quest_newton.m
 

**QA suggestions:**

1. line 7: * maximum eigen value

2. line 10: check syntax

3. line 14: "func = @(x)'' Couldn't find a proper documentation for this syntax. Also put more brackets just to be safe. Syntax for matrix
multiplication in the same line seems to be wrong at a couple of places.

4. An alternate way of doing this can be by first defining the K(B) matrix as done in q-davenport method and then using the poly() function
which gives the characteristic equation in array form

5.Another alternative is to write the coefficients of the polynomial in array format. This is the most common way of representing
polynomials

6.line 23: How does adding epsilon make it more robust. This step seems unnecessary

7.The norm function used here has different definition from what we require. Check documentation 


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
