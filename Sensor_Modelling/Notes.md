## Notes on Editing / Using Sensor Modelling Block

#1: *level.mat* contains a single variable *level. level = 0* for root, i.e. STADS folder, which contains main.m. *level = 1* for a subdirectory of the root, for example, *Sensor_Modelling*. Note that *level.mat* is stored in root with the corresponding value of *level*. Similarly, another *level.mat* is stored in *Sensor_Modelling* with the corresponding value of the *level,* i.e., *1*. This is so that we can differentiate between operations from *se_main.m* and *main.m.* To implement this:

> % Load level.mat to get file level\
> load('level.mat', 'level');\
>\
> % Add to Path - Inputs\
> if (level == 1)\
>     addpath(genpath('./Inputs/'));\
> elseif (level == 0)\
>     addpath(genpath('./Sensor_Modelling/Inputs/'));\
> else\
>     error('Error: level.mat file missing or incorrect path');\
> end

for reading files, and

> % Save all relevant workspace variables to 'se_variables.mat'\
> if (level == 1)\
>     save('./se_variables.mat', 'se_debug_run');\
> elseif (level == 0)\
>     save('./Sensor_Modelling/se_variables.mat', 'se_debug_run');\
> else\
>     error('Error: level.mat file missing or incorrect path');\
> end

for writing to files. Please skip to Note #6 for explanation of these paths.

I tested running from both - the *main.m* and the *se_main.m* and everything worked smoothly.

I also tried using absolute paths like '$/Sensor_Modelling/' in conjunction with Matlab Project, but it was throwing errors in a lot of places, which were unresolvable.

#2: The function *se_check_mag_lim.m* uses something called a *persistent variable*. This can retain the memory of the variable even if the files are closed. Hence, it is being used for checking if the magnitude limit has changed between runs. 

This is used in *se_edit_input_data.m* as follows:

> % If the se_magnitude_limit has changed, then automatically set se_pp = 1\
> if (se_check_mag_lim(se_magnitude_limit) == 1)\
>     se_pp = 1;\
> end

#3: Only the *.xls files are to be updated while running the code. Nothing else is to be tweaked in the code. I implemented this because I was tired of changing multiple variables in multiple places. The implementation from *.xls to workspace variables is slightly complicated. This is done via:

> se_inputs = readtable('se_inputs.xls', 'ReadVariableNames', false, 'ReadRowNames', true);
> se_inputs = se_inputs(:,1);
> se_magnitude_limit= str2double(se_inputs{'Magnitude Limit', 1}{1});

The first line read the **.xls* file into a table.  The second line trims the Comments column. Not necessary, but easier to debug. The third line takes *se_inputs*'s row with label *'Magnitude Limit'* and gets the cell with column number *1*. Then, it converts this value to a double.

#4: I wanted the preprocessing to happen only once, so, I have put a variable named *se_pp* in *se_inputs.xls*. If *se_pp = 1*, preprocessing occurs, otherwise, if *se_pp = 0*, it's skipped. Also, once the preprocessing is done, the variable reverts back to *0*. I achieved that using:

> % Automatically change se_pp back to 0 after 1 run if se_pp == 1\
> if (se_pp == 1)\
>     if (level == 1)\
>         writematrix(0,'./Inputs/se_inputs.xls','Range','B4');\
>     elseif (level == 0)\
>         writematrix(0,'./Sensor_Modelling/Inputs/se_inputs.xls','Range','B4');\
>     else\
>         error('Error: level.mat file missing or incorrect path');\
>     end\
> end

Note that the *writematrix* function doesn't work with **.csv* files, but only **.xls* files

#5: The *se_debug_run* variable is used for Develepor Comments ( *= 1*)or Silent Run ( *= 0*)

#6: I had started out with importing functions, but for some reason, nested functioning was not reading/writing and data, which I checked with the debug statements. So, I shifted to writing all code in scripts. 

So, all of these files are scripts, and so, when you import another script, the read/write commands are executed wrt the original script. So, everywhere, the imports/exports are wrt "./Sensor_Modelling" or "./". Note that './' mean the current directory. While '../' means the parent directory.

#7: The resources folder contains the files created by Matlab for the Project definitions. DO NOT DELETE this folder. The Project can be accessed via the Matlab Interface by double-clicking on STADSMatlab.prj
