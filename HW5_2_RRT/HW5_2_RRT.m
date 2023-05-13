%% Initialize
clearvars; clc; close all;

%% Define Obstacles
Obs1 = collisionBox(20, 1, 8);
Obs1.Pose = trvec2tform([0 0 6]);

Obs2 = collisionBox(20, 1, 8);
Obs2.Pose = trvec2tform([0 0 -6]);

Obs3 = collisionBox(8, 1, 4);
Obs3.Pose = trvec2tform([6 0 0]);

Obs4 = collisionBox(8, 1, 4);
Obs4.Pose = trvec2tform([-6 0 0]);

Obs = [Obs1, Obs2, Obs3, Obs4];


%% Define Goal
q_goal = [6 -5 5 0 pi/4 0];
Goal = collisionBox(1, 1, 5);
Goal.Pose = trvec2tform(q_goal(1:3)) * eul2tform(q_goal(4:6));


%% Define Obj
q_init = [-5, 5, -7, 0, pi/2, 0];
Obj = collisionBox(1, 1, 5);
Obj.Pose = trvec2tform(q_init(1:3)) * eul2tform(q_init(4:6));


%% RRT
G = f_RRT(q_init, q_goal, Obs, 0.9);

%% Path
P = shortestpath(G, findnode(G, "1"), findnode(G, G.Nodes.Name(end)))
clf(1);
f_draw(Obs, Obj, Goal, true);
plotconfig = plot(G, 'XData', G.Nodes.Point(:, 1), ...
    'YData', G.Nodes.Point(:, 2), 'ZData', G.Nodes.Point(:, 3), 'MarkerSize', 1, 'EdgeAlpha', 0.8);
highlight(plotconfig, P, 'NodeColor','g','EdgeColor','g', 'MarkerSize', 3);

%% draw total path
total_path = f_getPath(G, P);
[path_length, ~] = size(total_path);
Obj_test = collisionBox(1, 1, 5);

for i=1:path_length
    clf(1);
    f_draw(Obs, Obj, Goal, true);
    plotconfig = plot(G, 'XData', G.Nodes.Point(:, 1), ...
        'YData', G.Nodes.Point(:, 2), 'ZData', G.Nodes.Point(:, 3), 'MarkerSize', 1, 'EdgeAlpha', 0.8);
    highlight(plotconfig, P, 'NodeColor','g','EdgeColor','g', 'MarkerSize', 3);
    
    q = total_path(i, :);
    Obj_test.Pose = trvec2tform(q(1:3)) * eul2tform(q(4:6));
    [~, tmp] = show(Obj_test);
    tmp.FaceColor = [0, 0, 1];
    tmp.FaceAlpha = 1;
    tmp.EdgeColor = [1, 1, 1];
    pause(0.05);
end

for i=1:path_length

    q = total_path(i, :);
    Obj_test.Pose = trvec2tform(q(1:3)) * eul2tform(q(4:6));
    [~, tmp] = show(Obj_test);
    tmp.FaceColor = [1, 0, 1];
    tmp.FaceAlpha = 0.01;
    tmp.EdgeColor = [1, 1, 1];
end