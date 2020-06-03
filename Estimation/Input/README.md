# STADS
This repository contains codes for open- and closed- loops for STADS (Star Tracker based Attitude Determination System)

## Estimation Input

The output of Star-Matching is saved in this folder, as **es_input.mat**

The variables stored are as follows:
* **st_N_Match** : (Integer) - Number of matched stars in st_Match matrix 

* **st_op_bi** : ( (st_N_Match, 4) - Matrix ) - The body-frame vectors $b_i$ of the image stars that have been matched through Star-Matching. The columns include:
	1. $1^{st}$ column - Feature Extraction ID
	1. $2^{nd}, 3^{rd}, 4^{th}$ columns - $(X, Y, Z)$ unit body-frame vector 

* **st_op_ri** : ( (st_N_Match, 4) - Matrix ) - The corresponding inertial-frame vectors $r_i$ of the matched stars obtained from the Guide Star Catalogue. The columns include:
	1. $1^{st}$ column - Corresponding SSP-ID of the matched star
	1. $2^{nd}, 3^{rd}, 4^{th}$ columns - $(X, Y, Z)$ unit inertial-frame vector

>> **NOTE:** $(N)$ in both cases should be equal! The $i^{th}$ body-frame and the $i^{th}$ inertial-frame vector should correspond to the same star