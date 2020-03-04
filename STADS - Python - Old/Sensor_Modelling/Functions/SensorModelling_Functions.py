# This file contains the functions required for generation of coordinates in the sensor frame



import pandas as pd
import numpy as np


def angularDistance(row, col_names):
    '''
    Computes the angular distance (in degrees) between two points on the celestial
    sphere with a given right-ascension and declination values

    <Formula> - http://spiff.rit.edu/classes/phys373/lectures/radec/radec.html

    Parameters
    ----------
    row : pd.Dataframe - series
        Input right-ascension in (hrs) and declination in (degrees) format

    col_names: list of strings
        The names of the columns on which the function will be applied
        ### SHOULD FOLLOW THIS CONVENTION
        c1 = right-ascension_1; c2 = right-ascension_2
        c3 = declination_1; c4 = declination_2

    Returns
    -------
    y : pd.Dataframe - series
        The corresponding angular distance in degree value.
    '''

    pi = np.pi

    # Unpack column names
    c1, c2, c3, c4 = col_names

    # Assert datatypes
    assert type(c1) == str and type(c2) == str and type(c3) == str and type(c4) == str, 'TypeError: input should be str'


    # Units of right-ascension is in (hours) format
    alpha1, alpha2 = 15 * row[c1] * np.pi / 180, 15 * row[c2] * np.pi / 180

    # Units of declination is in (degrees) format
    delta1, delta2 = row[c3] * np.pi / 180, row[c4] * np.pi / 180

    # Given Formula
    temp = np.cos(pi/2 - delta1) * np.cos(pi/2 - delta2) + np.sin(pi/2 - delta1) * np.sin(pi/2 - delta2) * np.cos(alpha1 - alpha2)

    return np.degrees(np.arccos(temp))





def generateImageDataframe(CATALOGUE, ref_ra, ref_dec, ref_ang_dist, mag_limit = 6, ra_hrs = True):
    '''
    Generates a dataframe consisting of stars that lie within the circular boundary
    for a given max angular distance value for the generation of a star-image.
    The max magnitude limit that the stars possess can be set manually (Default = 6 Mv)

    Parameters
    ----------
    CATALOGUE : pd.Dataframe
        The 'master' star catalogue on which the function works

    ref_ra : floating-point number
        Input reference right-ascension value

    ref_dec : floating-point number
        Input reference declination value

    ref_ang_dist : floating-point number
        Input the circular field-of-view (FOV), the radius of which defines the conical
        boundary within which the stars from the catalogue should lie in

    mag_limit : floating-point number
        Input the maximum value of stars' magnitude that should be visible within with
        circular FOV

    ra_hrs : boolean, default = True
        Input is True if unit of right ascension is in hour format
        Input is False if unit of right ascension is in degrees format

        <Formula> - https://sciencing.com/calculate-longitude-right-ascension-6742230.html

    Returns
    -------
    IMG_DF : pd.Dataframe
        This returns the dataframe consisting of stars that lie inside the specified circular FOV
        that is sorted w.r.t the angular distance column in ascending order
    '''
    if ra_hrs == False:
        # Conversion of right-ascension from degrees to hours
        ref_ra = ref_ra/15

    # Generates image dataframe
    IMG_DF = pd.DataFrame(columns=['Ref_RA', 'Ref_Dec', 'Star_ID', 'RA', 'Dec', 'Mag'])

    # Restricts stars to specified upper magnitude limit
    temp = CATALOGUE[CATALOGUE.Mag <= mag_limit]

    # Total number of rows in <temp>
    size = temp.Mag.shape[0]

    # Counter for rows in <IMG_DF>
    row_count = 0
    for i in range(size):

        # Extracts data from (i - th) row of <temp>
        s_id, ra, dec, mag = temp.iloc[i]

        # Copies data into (row_count - th) row of <IMG_DF>
        IMG_DF.loc[row_count] = [ref_ra] + [ref_dec] + [s_id] + [ra] + [dec] + [mag]

        # Increment row_count
        row_count = row_count + 1


    # Apply angularDistance> function on 'Ang_Dist' column of <IMG_DF>
    cols = ['Ref_RA', 'RA', 'Ref_Dec', 'Dec']
    IMG_DF['Ang_Dist'] = IMG_DF.apply(angularDistance, axis=1, col_names = cols)

    # Sort <IMG_DF> based on 'Ang_Dist' column
    IMG_DF.sort_values('Ang_Dist', inplace = True, ascending = True)

    # Remove entries with angular distance in <IMG_DF> greater than that of <ref_ang_dist>
    IMG_DF = IMG_DF[IMG_DF.Ang_Dist <= ref_ang_dist]

    IMG_DF.sort_values('Mag', inplace = True, ascending = True)

    return IMG_DF.drop(["Ang_Dist"], axis = 1)





def generateCoordinates3D(row):
    '''
    Computes the Coordinates of each star in the image frame from the Right-Ascension
    (RA) & Declination (Dec) value in the dataframe - <IMG_DF>, and the Roll Input,
    which is zero by default.

    Parameters
    ----------
    row : pd.Dataframe - series
        Input RA/Dec in degrees from the <IMG_DF> dataframe

    roll : floating-point number
        Input the Roll Value in degrees

    Returns
    -------
    y : pd.Dataframe - series
        The corresponding vectors in the Celestial Frame and the Image Frame wrt center of the lens
    '''
    alpha = np.radians(row['Ref_RA'] * 15)
    delta = np.radians(row['Ref_Dec'])
    phi = np.radians(row['Roll'])
    Mag = row['Mag']

    alpha_0 = np.radians(row['RA'] * 15)
    delta_0 = np.radians(row['Dec'])

    z_bar = np.cos(alpha_0) * np.cos(delta_0)
    x_bar = np.sin(alpha_0) * np.cos(delta_0)
    y_bar = np.sin(delta_0)

    x_1 = np.array([x_bar, y_bar, z_bar])

    M = np.array([
    [  np.cos(alpha) * np.cos(phi) + np.sin(alpha) * np.sin(delta) * np.sin(phi),
       np.sin(phi) * np.cos(delta),
     - np.sin(alpha) * np.cos(phi) + np.cos(alpha) * np.sin(delta) * np.sin(phi)],
    [- np.cos(alpha) * np.sin(phi) + np.sin(alpha) * np.sin(delta) * np.cos(phi),
       np.cos(phi) * np.cos(delta),
       np.sin(alpha) * np.sin(phi) + np.cos(alpha) * np.sin(delta) * np.cos(phi)],
    [  np.sin(alpha) * np.cos(delta),
     - np.sin(delta),
       np.cos(alpha) * np.cos(delta)]
    ])

    x = np.dot(x_1, np.linalg.inv(M))

    return x[0], x[1], x[2], Mag





def imageFrameCoordinates(row, focal_length = 40):
    '''

    Computes the Coordinates of each star in the image frame from the Right-Ascension
    (RA) & Declination (Dec) value in the dataframe - <IMG_DF>, and the Roll Input,
    which is zero by default.

    Parameters
    ----------
    row : pd.Dataframe - series
        Input x, y, z cordinates of vectors of stars wrt the center of the lens from the <IMG_DF> dataframe

    Returns
    -------
    y : pd.Dataframe - series
        The corresponding coordinates in the Image Frame
    '''
    x_0 = row['x']
    y_0 = row['y']
    z_0 = row['z']
    Mag = row['Mag']

    x = - x_0 * focal_length / z_0
    y = - y_0 * focal_length / z_0

    return x, y, Mag
