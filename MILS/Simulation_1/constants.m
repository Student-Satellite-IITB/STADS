%-----------------------------CONSTANTS FILE-----------------------------%


%% Star Image Simulations Constants
SIS_const.a = 1;
SIS_const.b = -15.2;
%-------------------------END-------------------------%


%% Feature Extraction Constants
FE_const.a = -64163.64;
FE_const.b = -6463; 
%-------------------------END-------------------------%


%% Star Matching Constants
SM_const.a = -64163.64;
SM_const.b = -464;
%-------------------------END-------------------------%


%% Save constants.mat file
currentFolder = matlab.desktop.editor.getActiveFilename;
fileName = currentFolder + "at";
save(fileName, 'SIS_const','FE_const', 'SM_const');
%-----------------------------------END-----------------------------------%