# Default Variable Definitions
import numpy as np

se_Magnitude_Limit = 6

f_noise_max = 30
f_noise_min = 0

sigma = 2.5
check_radius = 20

#-------------------------------------

from Optics.Output.Variables import *

se_Dataset = np.genfromtxt('Inputs/CLS_Dataset.csv', delimiter=',')

'''RA_hr = 5.603559 #Hrs
Dec = -1.201917 #Degrees
Roll = 0.0 #Degrees
RA = RA_hr * 360 / 24 #In Degrees'''


Circular_FOV = np.sqrt(FOV_Length ** 2 + FOV_Width ** 2)
