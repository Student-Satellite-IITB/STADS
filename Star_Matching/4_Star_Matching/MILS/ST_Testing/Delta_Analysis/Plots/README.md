# Student Satellite Project - Indian Institude of Technology, Bombay

## Star Tracker-based Attitude Determination System (STADS)

### Author - KT Prajwal Prathiksh

Plots of summary results of DELTA_Analysis, which is done to find the appropirate value for the DELTA parameter to be used in Lost-in-Space mode of Star-Matching. Analysis was performed on the output of Feature-Extraction, consisting of `15` images - `\Simulation-3`

1. `Coarse_x.png`: Star-Matching was performed with DElTA values ranging from `linspace(1e-5, 0.75, 600)` on all `15` images

1. `Fine_x.png`: Star-Matching was performed with DElTA values ranging from `linspace(1e-7, 1e-4, 600)` on all `15` images

1. `Occurance Rate`: (Number of images which satisfied the given condition / Total number of images) X 100 % , where Total number of images = `15`

1. Conditions:
	1. `>= 4`: Number of images in which the number of `True` star matches were greater than 4

	1. `> \delta_{TM}:8`: Number of images in which the number of `True` star matches were greater than 8