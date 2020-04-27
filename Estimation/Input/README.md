# STADS
This repository contains codes for open- and closed- loops for STADS (Star Tracker based Attitude Determination System)

## Estimation Input

The output of Star-Matching is saved in this folder, as **es_input.mat**

The variables stored are as follows:
* **sm_op_bi:** ( (N, 3) - Matrix )
	The body-frame vectors - (X,Y,Z), of the matched stars 

* **sm_op_ri:** ( (N, 3) - Matrix) 
	The inertial-frame vectors - (X,Y,Z), of the corresponding matched stars

* **n_st_strs:** (Integer) 
	The number of stars matched by Star Matching

>> **NOTE:** (N) in both cases should be equal! The (i-th) body-frame and the (i-th) inertial-frame vector should correspond to the same star.