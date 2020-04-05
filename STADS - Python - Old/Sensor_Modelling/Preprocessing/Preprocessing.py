import pandas as pd

# Variables
from Sensor_Modelling.Functions.Variables import se_Magnitude_Limit
from Boolean_Inputs import se_pp

CATALOGUE = pd.read_csv("Catalogue\HYG.csv", usecols = ["StarID", "RA", "Dec", "Mag"])
#Refer to https://github.com/astronexus/HYG-Database for Details
CATALOGUE.sort_values('Mag', inplace=True)
CATALOGUE = CATALOGUE[CATALOGUE.Mag <= se_Magnitude_Limit]

if se_pp: CATALOGUE.to_csv("Sensor_Modelling\Preprocessing\Simulation_HYG.csv", index = False)

