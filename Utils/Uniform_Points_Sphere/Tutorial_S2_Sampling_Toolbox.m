close all
clear
clc

%% Generate (N) uniformly distributed points on a sphere
tic

N = 1100; % Number of points
choice = 1; % Select Choice

if choice == 1
    %%% Slower, but more accurate method (Go through the documentation properly)
    [V,Tri,~,Ue]=ParticleSampleSphere('N',N); % ~19s for N=500, ~400s for N=1100
    
elseif choice == 2
    %%% Faster, but less accurate method
    [V,Tri]=SpiralSampleSphere(N,false); % ~0.05s for N=500

elseif choice == 3
    %%% Generates a uniform or stratified sampling of a unit sphere (NOT
    %%% WHAT WE ARE LOOKING FOR!!)
    V = RandSampleSphere(N,'uniform');  % ~0.00004s for N=500
end
toc
%% Plot the uniformly distributed points
figure();

% Plot the sphere's surface of radius 1
[x, y, z] = sphere;
r = 1;
a=[0,0,0,r];
hSurface=surf(x*a(1,4)+a(1,1),y*a(1,4)+a(1,2),z*a(1,4)+a(1,3));
set(hSurface,'FaceColor',[0 0 1],'FaceAlpha',0.5,'FaceLighting','gouraud','EdgeColor','none')
daspect([1 1 1]);
xlabel('X'); ylabel('Y'); zlabel('Z');
camlight

hold on

% Plot points
scatter3(V(:,1), V(:,2), V(:,3),'MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75])
heading_1 = 'Uniformly Distributed Points | N= ' + string(N);
set(get(gca,'Title'),'String',heading_1,'FontSize',15)
hold off

if choice == 1
    % Visualize optimization progress
    figure('color','w')
    subplot(1,2,1)
    plot(log10(1:numel(Ue)),Ue,'.-')
    set(get(gca,'Title'),'String','Optimization Progress','FontSize',40)
    set(gca,'FontSize',20,'XColor','k','YColor','k')
    xlabel('log_{10}(Iteration #)','FontSize',30,'Color','k')
    ylabel('Reisz s-Energy','FontSize',30,'Color','k')

    % Visualize mesh
    subplot(1,2,2)
    h=patch('faces',Tri,'vertices',V);
    set(h,'EdgeColor','b','FaceColor','w')
    axis equal
    hold on
    plot3(V(:,1),V(:,2),V(:,3),'.k','MarkerSize',15)
    set(gca,'XLim',[-1.1 1.1],'YLim',[-1.1 1.1],'ZLim',[-1.1 1.1])
    view(3)
    grid off
    heading_2 = 'N= ' + string(N) + ' (base mesh)';
    set(get(gca,'Title'),'String',heading_2,'FontSize',30)
end

%% Save points
points_table = array2table(V,'VariableNames',{'X','Y','Z'});
fileName = ".\utils\Uniform_Points_Sphere\" + string(choice) + "_uniform_points_" + string(N) + ".csv";
writetable(points_table, fileName);

fileName = ".\utils\Uniform_Points_Sphere\" + string(choice) + "_uniform_points_" + string(N) + ".mat";
save(fileName, 'V', 'Tri', 'Ue', 'N', 'choice');