%% initialization
close all; clearvars; clc;
AutoMove = false;


%% define SampleSpace
SampleSpace = 0:0.1:20;
[~, MAX_cnt] = size(SampleSpace);


%% define Doors
Doors_pnt = zeros(2, 49);
for i=1:49
    Doors_pnt(:, i) = [randi(19); randi(19)];
end
Doors_idx = zeros(size(Doors_pnt));
[~, Doors_num] = size(Doors_idx);
for i=1:Doors_num
    Doors_idx(1, i) = find(SampleSpace==Doors_pnt(1, i));
    Doors_idx(2, i) = find(SampleSpace==Doors_pnt(2, i));
end


%% define Robot
Robot_pnt = [1; 1];
Robot_idx = [1; 1] .* find(SampleSpace==Robot_pnt(1, 1));


%% Define Movement
% 위, 오른위, 오른, 오른아래, 아래, 왼아래, 왼, 왼위, 정지
%           N  NE   E  SE   S  SW   W  NW  stop
d_moves = [ 1,  1,  0, -1, -1, -1,  0,  1,  0;
            0,  1,  1,  1,  0, -1, -1, -1,  0];


%% State Transition Probability
% 이동할 곳으로 이동할 확률 1/2
% 이동할 곳 주변 8방향으로 이동할 확률 각 1/16

M = ones(3, 3);
M(2, 2) = 3;
M = M / sum(sum(M));


%% Bayes_Localization & Plotting
bel = ones(MAX_cnt, MAX_cnt) ./ (MAX_cnt^2);
isEnd = false;

fig = figure;
fig.Position = [0 0 1200 1000];


while ~isEnd
    if AutoMove
        move_idx = randsample(9, 1, true, [0.025 0.18 0.18 0.18 0.025 0.025 0.025 0.18 0.025]);
    else
        waitforbuttonpress;
        move_idx = getMoveIdx(double(get(gcf, 'CurrentCharacter')));
        if move_idx == 0
            break
        elseif move_idx == -1
            continue
        end
    end

    u = d_moves(:, move_idx);
    u_x = u(1); u_y = u(2);

    bel_bar = zeros(size(bel));
    for i=1:MAX_cnt
        for j=1:MAX_cnt
            for x=1:3
                for y=1:3
                    if (0 < i+x-2+u_x)  && ...
                       (i+x-2+u_x <= MAX_cnt) && ...
                       (0 < j+y-2+u_y)  && ...
                       (j+y-2+u_y <= MAX_cnt)

                        bel_bar(i+x-2+u_x, j+y-2+u_y) = ...
                            bel_bar(i+x-2+u_x, j+y-2+u_y) + ...
                            bel(i, j) * M(x, y);
                    end
                end
            end
        end
    end
    
    if all(Robot_idx + u > 0) && all(Robot_idx + u <= MAX_cnt)
        Robot_idx = Robot_idx + u;
    end

    sensor_detected = false;
    for i=1:Doors_num
        if Doors_idx(:, i) == Robot_idx
            sensor_detected = true;
            break
        end
    end
    
    if sensor_detected
        z = zeros(MAX_cnt, MAX_cnt);
        for j=1:Doors_num
            [X1, X2] = meshgrid(SampleSpace, SampleSpace);
            tmp = (mvnpdf([X1(:) X2(:)], [Doors_pnt(2, j) Doors_pnt(1, j)]) ./ Doors_num);
            tmp = reshape(tmp, MAX_cnt, MAX_cnt);
            z = z + tmp;
        end
    else
        z = ones(MAX_cnt, MAX_cnt) ./ (MAX_cnt^2);
    end
    
    bel = z .* bel_bar;
    bel = bel ./ sum(sum(bel));
    Robot_pnt(1) = SampleSpace(Robot_idx(1));
    Robot_pnt(2) = SampleSpace(Robot_idx(2));

    subplot(2, 2, 1);
    contour(SampleSpace, SampleSpace, bel, 0:0.00001:0.002);
    title('bel(x)')

    subplot(2, 2, 2);
    plot(Doors_pnt(2, :), Doors_pnt(1, :), 'go', "MarkerSize", 10, ...
        "MarkerEdgeColor", "g", "MarkerFaceColor", [.6, 1, .6]);
    title('Real World')
    axis([0 20 0 20]);
    hold on;
    plot(Robot_pnt(2), Robot_pnt(1), 'rd', "MarkerSize", 10, ...
        "MarkerEdgeColor", "r", "MarkerFaceColor", [1, .6, .6]);
    hold off;
    
    subplot(2, 2, 3);
    meshc(SampleSpace, SampleSpace, bel);
    axis([0 20 0 20 0 0.005]);
    title('bel(x)')

    subplot(2, 2, 4);
    contour(SampleSpace, SampleSpace, z);
    title('p(z|x)')


    drawnow
end

% bels = zeros(n, MAX_cnt);
% zs = zeros(n, MAX_cnt);
% Robot_pnts = zeros(1, n);
% 
% for i=1:n
%     Robot_idx = Robot_idx + (2 - moves(i));
%     Robot_p = SampleSpace(Robot_idx);
%     Robot_pnts(i) = Robot_p;
% 
%     bels(i, :) = bel;
%     if any(Doors_idx==Robot_idx)
%         z = zeros(size(SampleSpace));
%         for j=1:4
%             z = z + (normpdf(SampleSpace, Doors_pnt(j), 0.5) ./ 4);
%         end
%     else
%         z = ones(size(SampleSpace)) ./ MAX_cnt;
%     end
%     zs(i, :) = z;
%     bel = f_Bayes_Filter(bel, z, moves(i), M, MAX_cnt);
% end

%% Plot Result
% f = figure;
% f.Position = [0 0 1200 1000];
% 
% for i=1:n
%     subplot(3, 1, 1);
%     plot(SampleSpace, bels(i, :), "b", "LineWidth", 3);
%     title('bel(x)')
%     axis([0, 20, 0, 0.05]);
% 
%     subplot(3, 1, 2);
%     plot(Doors_pnt, [1, 1, 1, 1], 'go', "MarkerSize", 10, ...
%         "MarkerEdgeColor", "g", "MarkerFaceColor", [.6, 1, .6]);
%     title('Real World')
%     axis([0, 20, 0, 2]);
%     hold on;
%     plot([Robot_pnts(i)], [1], 'rd', "MarkerSize", 10, ...
%         "MarkerEdgeColor", "r", "MarkerFaceColor", [1, .6, .6]);
%     hold off;
% 
%     subplot(3, 1, 3);
%     plot(SampleSpace, zs(i, :), "m", "LineWidth", 3);
%     title('p(z|x)')
%     axis([0, 20, 0, 0.4]);
% 
%     drawnow
% end

%% Bayes_Filter Fucntion
% function bel = f_Bayes_Filter(bel, z, u, M, MAX_cnt)
%     bel = reshape(M(u, :, :), MAX_cnt, MAX_cnt) * bel';
%     bel = bel';
%     bel = z .* bel;
%     bel = bel ./ sum(bel);
% end


%% KeyBoard Input Mapping Function
function result = getMoveIdx(c)
    try
        result = find([122, 56, 57, 54, 51, 50, 49, 52, 55, 53]==c) - 1;
    catch
        result = -1;
    end
end