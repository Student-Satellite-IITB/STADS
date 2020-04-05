# This file contains the functions required for generation of the modelled image from the coordinates



from Sensor_Modelling.Functions.Variables import f_noise_max, f_noise_min, pixel_size, check_radius, CMOS_Width, CMOS_Length, sigma
import numpy as np



def f(x, y, H, sigma, x_0, y_0):
    return H * np.exp(-((x - x_0) ** 2 + (y - y_0) ** 2) / (2 * sigma ** 2)) / (2 * np.pi * sigma ** 2)



def H(M, k_1 = 5 * 10 ** 4, k_2 = 0.92):
    return k_1 * np.exp(- k_2 * M)



def r(f_n_max = f_noise_max, f_n_min = f_noise_min):
    return f_n_min + (f_n_max - f_n_min) * np.random.random()



def generateImage(Image, IMG_Data):
    
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
        for j in np.arange(int(x[i] - check_radius) if int(x[i] - check_radius) > 0 else 0, int(x[i] + check_radius) if int(x[i] + check_radius) < CMOS_Width else CMOS_Width):
            for k in np.arange(int(y[i] - check_radius) if int(y[i] - check_radius) > 0 else 0, int(y[i] + check_radius) if int(y[i] + check_radius) < CMOS_Length else CMOS_Length):
                Image[j][k] = Image[j][k] + f(j, k, H(b[i]), sigma, (x[i] + CMOS_Width / 2), (y[i] + CMOS_Length / 2))
    return Image
