# STADS
This repository contains codes for open- and closed- loops for STADS (Star Tracker based Attitude Determination System)

## Estimation Testing

This folder includes the testing function for Estimation. 

The input variables for this function are as follows:
* **st_op_bi:** ( (N, 3) - Matrix )
	The body-frame vectors - (X,Y,Z), of the matched stars 

* **st_op_ri:** ( (N, 3) - Matrix) 
	The inertial-frame vectors - (X,Y,Z), of the corresponding matched stars

* **es_a:** ((N, 1) - Matrix) 
	The weights of the corresponding matched stars
  
* **es_q_bi:** ((4, 1) - Matrix) 
	The final estimated quaternion using either of the algorithm 

The output variables for this function are as follows:
* **L:** (Float)
	The value of the calculated Lost function 
