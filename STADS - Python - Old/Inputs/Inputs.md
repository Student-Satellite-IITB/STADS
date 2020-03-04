This module contains the inputs to the Sensor Modelling in the form of csv file.
The format of the inputs is:
Attitude_RA_hr | Attitude_Dec | Attitude_Roll | w_x | w_y | w_z | w_mag | pos_x | pos_y | pos_z
The Attitude is for knowing the direction to point in for the sensor modelling.
The w is to model slew rate.
The position is in the ECIF frame, so, with the attitude, we can figure out the position of the earth.
Can we model the sun?
