Quality Assurance Report
====

se_PR_4_Trim2Sensor

----

### Iteration - 1

**Code Author:** Neilabh Banzal


**Review requested by:** Neilabh Banzal


**Reviewer:** Aruja Khanna


**Date of review:**	02/06/2020


**Permanent Links:**

1. https://github.com/arujakhanna/STADS/blob/master/Sensor_Model/Processing/se_PR_4_Trim2Sensor.m

**QA suggestions:**
> Any modifications/additions/deletions to be made to the code. It also includes any flaws/mistakes that need to be corrected in the code

1. Line 2,3- This is the description for function se_PR_3_Lens2Sensor- this function trims the coordinates received from the previous function to include only the ones that are within the sensor boundaries.

2. Line 37- should be returns se_T (Table (n2,m1))

3. For the 2nd boresight input, i.e. when RA=101.2872, Dec=-16.7161,Roll=10 the table after running this function is a 0x14 table, i.e. no stars are captured here. Though I could not see any error in the code, I just felt maybe this should be checked? 

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


2. 

**Implementation:**
> The changes implemented as suggested by the review points will be documented
*Eg:*1. All changes are implemented


**Post-QA Permanent Links:**

1.

2.

3.

================================================================
