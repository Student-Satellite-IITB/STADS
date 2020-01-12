Output contains the final output of the CLS-
# The attitude of the sensor (RA, Dec, Roll)
# The angular velocity of the satellite 
  - w_x, w_y, w_z, w_mag
  - w_x, w_y, w_z form the unit vector of the axis of rotation (To separate the 2 possible cases, we can do something like choosing w_x positive case)
  - w_mag contains the magnitude, or the angular speed

output.csv format:
Right Ascension (Hours), Declination (Degrees), Roll (Degrees), w_x, w_y, w_z, w_Magnitude