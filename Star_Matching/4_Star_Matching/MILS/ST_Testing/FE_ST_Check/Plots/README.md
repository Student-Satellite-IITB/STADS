# Student Satellite Project - Indian Institude of Technology, Bombay

## Star Tracker-based Attitude Determination System (STADS)

### Author - KT Prajwal Prathiksh

Plots of summary results of Lost-in-Space mode of Star-Matching, on the output of Feature-Extraction, consisting of `15` images - `\Simulation-3`

1. `Trim-Star-ID`: The SSP-IDs of stars which are greater than this value are not considered for star-matching

1. `True`: Number of stars whose SSP-ID predicted by Star-Matching after verification, matches its actual SSP-ID

1. `False`: Number of stars whose SSP-ID predicted by Star-Matching after verification, does not match its actual SSP-ID

1. `Miss`: Number of stars whose which failed verification step, but had been assigned the true SSP-ID at the end of Star-Matching

1. `Image`: Number of stars in the image, after removing stars with SSP-IDs greater than the `Trim-Star-ID`

1. `\delta_{TM}`: The parameter used in Tracking mode (=8)