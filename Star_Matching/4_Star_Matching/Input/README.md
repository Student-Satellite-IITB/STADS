# Student Satellite Project - Indian Institude of Technology, Bombay

## Star Tracker-based Attitude Determination System (STADS)

### Star-Matching Input

The output of Feature Extraction is saved in this folder, as **st_input.mat**

The variables stored are as follows:
* **fe_n_str** : (Integer) - The number of stars identified by *Feature Extraction block*

* **fe_output** : ( (fe_n_str, 3) - Matrix ) - The output of Feature Extraction block - which contains the centroids of the identified stars. The columns of the matrix are as follows:
	1. 1^{st} column - Feature Extraction ID
	1. 2^{nd}, 3^{rd} columns - (X, Y) centroids, with the origin at the center of the sensor
	**NOTE:** Unit of centroid: mm!