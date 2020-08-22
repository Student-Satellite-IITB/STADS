N_list = [20,40,50,60,80,100,150,200,250,300,350,400,450,500,600,700,800,900,1000];
FOV_list = zeros(1,length(N_list));
for iter = 1:length(N_list)
    N = N_list(iter);
    [V,Tri,~,Ue]=ParticleSampleSphere('N', N); % Calculate uniform points on sphere

    n_sample_pts = 0.5*N; % Number of sampling points
    avg_min_ang_sep = 0; % Variable will store the average angular sepration between two vectors

    for j = 1:n_sample_pts    

        % Randomly choose a central vector 
        idx = randi(N); central_vector = V(idx,:);

        % Find the closest vector to the central vector
        min_ang_sep = 360;
        for k = 1:N
            if k ~= idx % Ignore case where the central vector == neighbour vector
                nbr_vector = V(k,:);

                % Calculate angular sepration
                ang_sep = atan2d(norm(cross(central_vector,nbr_vector)),dot(central_vector,nbr_vector));

                if ang_sep < min_ang_sep
                    min_ang_sep = ang_sep; % Update with the lower angular separation value
                end
            end
        end

        avg_min_ang_sep = avg_min_ang_sep + min_ang_sep; % Sum the minimum angular separation value
    end

    avg_min_ang_sep = avg_min_ang_sep/n_sample_pts; % Find the average using the number of points used

    FOV_list(iter) = avg_min_ang_sep; % Store the average angular separation value 
    disp(string(avg_min_ang_sep));
end
DataTable = array2table([N_list', FOV_list'], "VariableNames", {'N', 'FOV'});
writetable(DataTable, '.\utils\Uniform_Points_Sphere\DataTable_Sphere_Testing.csv');
%% Plot
close all
figure('Renderer', 'painters', 'Position', [300 100 1000 600]);
plot(N_list, FOV_list, 'x');
hold on
plot(N_list, FOV_list, '--');
hold off
legend('FOV');
xlabel('Number of Points (N)');
ylabel('FOV (in degrees)');
xticks([0:50:N]);
yticks([0:5:max(FOV_list)*1.5]);
title('FOV vs Number of uniform points on a sphere');
print('.\utils\Uniform_Points_Sphere\Plot_Sphere_Testing', '-dpng', '-r500');

figure('Renderer', 'painters', 'Position', [300 100 1000 600]);
semilogy(N_list, FOV_list, 'x');
hold on
semilogy(N_list, FOV_list, '--');
hold off
legend('FOV');
xlabel('Number of Points (N)');
ylabel('FOV (in degrees) - Log');
xticks([0:50:N]);
title('FOV vs Number of uniform points on a sphere (Semilog-y)');
print('.\utils\Uniform_Points_Sphere\Plot_Sphere_Testing_log_y', '-dpng', '-r500');