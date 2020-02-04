# Import Libraries
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
import matplotlib.image as mpimg
import os

# Initialise variables
from Sensor_Modelling.Functions.Variables import *

# Import Functions
from Sensor_Modelling.Functions.SensorModelling_Functions import *
from Sensor_Modelling.Functions.SensorModelling_Functions_2 import *
from Sensor_Modelling.Functions.Other_Functions import *

def main(debug = False):
    se_count = se_get_var_value()

    # Import Catalogue
    CATALOGUE = pd.read_csv("Sensor_Modelling/Preprocessing/Simulation_HYG.csv")
    CATALOGUE.sort_values('Mag', inplace = True)
    # The Star Catalogue being used is the HYG Database
    # StarID: The database primary key from a larger "master database" of stars
    # Mag: The star's apparent visual magnitude
    # RA, Dec: The star's right ascension and declination, for epoch 2000.0 (Unit: RA - hrs; Dec - degrees)
    if debug: print("Catalogue read")

    # The following pandas dataframe 'IMG_Data' contains the coordinates of the stars in the sensor frame
    IMG_Data = generateImageDataframe(CATALOGUE, RA, Dec, Circular_FOV, se_Magnitude_Limit, ra_hrs = False)
    IMG_Data['Roll'] = Roll
    IMG_Data = IMG_Data.apply(generateCoordinates3D, result_type = 'expand', axis=1).rename(columns = {0 : "x", 1 : "y", 2 : "z", 3 : "Mag"})
    IMG_Data = IMG_Data.apply(imageFrameCoordinates, result_type = 'expand', axis=1).rename(columns = {0 : "x", 1 : "y", 2 : "Mag"})
    if debug: print('Dataframe generated')

    # Generating the image
    Image = np.zeros((CMOS_Width, CMOS_Length))
    #generateImage(Image, IMG_Data)

    # Trimming the data to within the boundary
    IMG_Data = IMG_Data[IMG_Data['x'] < pixel_size * CMOS_Length / 2]
    IMG_Data = IMG_Data[IMG_Data['x'] > - pixel_size * CMOS_Length / 2]
    IMG_Data = IMG_Data[IMG_Data['y'] < pixel_size * CMOS_Width / 2]
    IMG_Data = IMG_Data[IMG_Data['y'] > - pixel_size * CMOS_Width / 2]

    # Converting values to arrays - x, y coordinates and brightness magnitude
    y = IMG_Data.iloc[:,0].values / pixel_size
    x = IMG_Data.iloc[:,1].values / pixel_size
    b = IMG_Data.iloc[:,2].values

    # n is the number of stars in the image
    n = IMG_Data.shape[0]

    for i in np.arange(n):
        for j in np.arange(int(x[i] + CMOS_Width / 2 - check_radius) if int(x[i] + CMOS_Width / 2 - check_radius) > 0 else 0, int(x[i] + CMOS_Width / 2 + check_radius) if int(x[i] + CMOS_Width / 2 + check_radius) < CMOS_Width else CMOS_Width):
            for k in np.arange(int(y[i] + CMOS_Length / 2 - check_radius) if int(y[i] + CMOS_Length / 2 - check_radius) > 0 else 0, int(y[i] + CMOS_Length / 2 + check_radius) if int(y[i] + CMOS_Length / 2 + check_radius) < CMOS_Length else CMOS_Length):
                Image[j][k] = Image[j][k] + f(j, k, H(b[i]), sigma, (x[i] + CMOS_Width / 2), (y[i] + CMOS_Length / 2))

    if debug: print('Image generated')

    mpimg.imsave("Sensor_Modelling/Output/Image.png", Image, cmap='gray', vmax = 255)
    se_dirName = 'Sensor_Modelling/Output/History/' + "{0:0=3d}".format(se_count)
    os.mkdir(se_dirName)
    mpimg.imsave(os.path.join(se_dirName , 'Image.png'), Image, cmap='gray', vmax = 255)

no_loops = 1
for i in np.arange(no_loops):
    RA_hr = se_Dataset[i][0]
    RA = RA_hr * 360 / 24 #In Degrees
    Dec = se_Dataset[i][1]
    Roll = se_Dataset[i][2]
    main(debug = True)
