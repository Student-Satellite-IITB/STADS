iter_no = 0;
for index = 1:50
    iter_no = iter_no + 1;
    writematrix(360*rand,"C:\Users\Tanmay Ganguli\Documents\STADS\STADS\OLS\SIS\Input and Constants\sis_in_bo.xlsx",'Range','B2');%write RA
    writematrix(-90+180*rand,"C:\Users\Tanmay Ganguli\Documents\STADS\STADS\OLS\SIS\Input and Constants\sis_in_bo.xlsx",'Range','C2');%write dec
    
    run('C:\Users\Tanmay Ganguli\Documents\STADS\STADS\OLS\SIS\Input and Constants\sis_gnrt_input_file.m');%run sis_gnrt_input file
    %a = index;
    mkdir(strcat('C:\Users\Tanmay Ganguli\Documents\STADS\SIS run test-',num2str(iter_no)));%make root folder to store generated images
    copyfile('C:\Users\Tanmay Ganguli\Documents\STADS\STADS\OLS\SIS\Input and Constants\sis_input.mat',strcat('C:\Users\Tanmay Ganguli\Documents\STADS\SIS run test-',num2str(iter_no)) );
    %copy sis_input file to root folder

    %writing path into STADS_SIS.m
    fid = fopen('C:\Users\Tanmay Ganguli\Documents\STADS\STADS\OLS\SIS\STADS_SIS.m');
    nameArray = {};
    for j = 1:216
        nameArray = [nameArray,fgetl(fid)];
    end

    nameArray = string(nameArray);
    nameArray(11) = strrep(nameArray(11),'sim_log.path = strcat("C:\Users\Tanmay Ganguli\Documents\STADS\SIS run test-",num2str(iter_no-1)); % Enter Path of Simulation Folder','sim_log.path = strcat("C:\Users\Tanmay Ganguli\Documents\STADS\SIS run test-",num2str(iter_no)); % Enter Path of Simulation Folder');
    fid = fopen('C:\Users\Tanmay Ganguli\Documents\STADS\STADS\OLS\SIS\STADS_SIS.m','w');
    for k = 1:204
        fprintf(fid, '%s\n',nameArray(iter_no));
    end
    fclose(fid);
    %run SIS
    run('C:\Users\Tanmay Ganguli\Documents\STADS\STADS\OLS\SIS\STADS_SIS.m')    
end
