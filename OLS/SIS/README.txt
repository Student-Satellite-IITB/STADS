1) Create a root folder to run SIS
2) Generate a 'sis_input.mat' file through the 'sis_gnrt_input_file.m' script input file in the Input and Constants Folder
	First set the values of input and constants in the corresponding xlsx files
	Then run the script to generate the corresponding output file
3) Copy the 'sis_input.mat' file into the new root simulation folder to run simulation
4) Run the 'STADS_SIS.mlx' script with the address of the root simulation folder 

Note: Current directory while running any code on matlab should be the root directory of STADS, also the 
project file should be loaded