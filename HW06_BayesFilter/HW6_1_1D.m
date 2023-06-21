%% initialization
close all; clearvars; clc;
MAX_cnt = 1001;


%% define SampleSpace
SampleSpace = linspace(0, 20, MAX_cnt);


%% define Doors
Doors_pnt = [3, 6, 9, 15];
Doors_idx = zeros(size(Doors_pnt));
for i=1:4
    Doors_idx(i) = find(SampleSpace==Doors_pnt(i));
end


%% define Robot
Robot_pnt = 1;
Robot_idx = find(SampleSpace==Robot_pnt);


%% State Transition Probability
% M(1, :, :) => u가 +1인 경우
% M(2, :, :) => u가  0인 경우
% M(3, :, :) => u가 -1인 경우
% 이동할 곳으로 이동할 확률 1/2
% 이동할 곳 +1, -1 으로 이동할 확률 각 1/4

M = zeros(3, MAX_cnt, MAX_cnt);
for i=1:MAX_cnt
    if i-2 > 0
        M(3, i-2, i) = 1/4;
    end
    if i-1 > 0
        M(2, i-1, i) = 1/4;
        M(3, i-1, i) = 1/2;
    end
    M(1, i, i) = 1/4;
    M(2, i, i) = 1/2;
    M(3, i, i) = 1/4;
    if i+1 <= MAX_cnt
        M(1, i+1, i) = 1/2;
        M(2, i+1, i) = 1/4;
    end
    if i+2 <= MAX_cnt
        M(1, i+2, i) = 1/4;
    end
end


%% Define Movement
moves = [ones(1, fix(MAX_cnt/2)), ...
         2*ones(1, fix(MAX_cnt/4)), ...
         3*ones(1, fix(MAX_cnt/4)), ...
         ones(1, 3*fix(MAX_cnt/5))];

%% Bayes_Localization
bel = ones(size(SampleSpace)) ./ MAX_cnt;
[~, n] = size(moves);
bels = zeros(n, MAX_cnt);
zs = zeros(n, MAX_cnt);
Robot_pnts = zeros(1, n);

for i=1:n
    Robot_idx = Robot_idx + (2 - moves(i));
    Robot_p = SampleSpace(Robot_idx);
    Robot_pnts(i) = Robot_p;

    bels(i, :) = bel;
    if any(Doors_idx==Robot_idx)
        z = zeros(size(SampleSpace));
        for j=1:4
            z = z + (normpdf(SampleSpace, Doors_pnt(j), 0.5) ./ 4);
        end
    else
        z = ones(size(SampleSpace)) ./ MAX_cnt;
    end
    zs(i, :) = z;
    bel = f_Bayes_Filter(bel, z, moves(i), M, MAX_cnt);
end

%% Plot Result
f = figure;
f.Position = [0 0 1200 1000];

for i=1:n
    subplot(3, 1, 1);
    plot(SampleSpace, bels(i, :), "b", "LineWidth", 3);
    title('bel(x)')
    axis([0, 20, 0, 0.05]);

    subplot(3, 1, 2);
    plot(Doors_pnt, [1, 1, 1, 1], 'go', "MarkerSize", 10, ...
        "MarkerEdgeColor", "g", "MarkerFaceColor", [.6, 1, .6]);
    title('Real World')
    axis([0, 20, 0, 2]);
    hold on;
    plot([Robot_pnts(i)], [1], 'rd', "MarkerSize", 10, ...
        "MarkerEdgeColor", "r", "MarkerFaceColor", [1, .6, .6]);
    hold off;

    subplot(3, 1, 3);
    plot(SampleSpace, zs(i, :), "m", "LineWidth", 3);
    title('p(z|x)')
    axis([0, 20, 0, 0.4]);

    drawnow
end

%% Bayes_Filter Fucntion
function bel = f_Bayes_Filter(bel, z, u, M, MAX_cnt)
    bel = reshape(M(u, :, :), MAX_cnt, MAX_cnt) * bel';
    bel = bel';
    bel = z .* bel;
    bel = bel ./ sum(bel);
end