file = fopen('C:\Users\Tanmay Ganguli\Documents\STADS\STADS\SIS\gnrt_multiple_inputs.m','w');
while true
    line = fgetl(file);
    if contains(line,'mkdir')
        fprintf('hello')
    end
    fclose(file);
       
end