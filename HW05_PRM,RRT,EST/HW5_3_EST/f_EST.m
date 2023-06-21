function G = f_EST(q_init, q_goal, Obs)

    G = graph;
    G = addnode(G, table("1", q_init, 'VariableNames', {'Name', 'Point'}));
    V_cnt = 2;
    camAngle = 0;

    clf;
    f_draw(Obs, 0, 0, false);
    plot(G, 'XData', G.Nodes.Point(:, 1), ...
    'YData', G.Nodes.Point(:, 2), 'ZData', G.Nodes.Point(:, 3), 'MarkerSize', 1, 'EdgeAlpha', 0.1);
    pause(1);

    while true
        
        q = f_selectConfigFromTree(G);
        q_near = f_getRandomPointNearQ(q, Obs, q_goal);

        if isempty(f_delta(G, q, q_near, Obs, 10))
            continue
        end

        G = addnode(G, table(string(V_cnt), q_near, 'VariableNames', {'Name', 'Point'}));
        k = find(all(G.Nodes.Point==q, 2));
        G = addedge(G, string(k), string(V_cnt));
        V_cnt = V_cnt + 1;

        if norm(q_near - q_goal, 2) < 0.9
            G = addnode(G, table(string(V_cnt), q_goal, 'VariableNames', {'Name', 'Point'}));
            k = find(all(G.Nodes.Point==q_near, 2));
            G = addedge(G, string(k), string(V_cnt));
            break;
        end
        

        clf(1);
        f_draw(Obs, 0, 0, false);
        view(camAngle,0);
        camAngle = mod(camAngle + 0.5, 360);
        plot(G, 'XData', G.Nodes.Point(:, 1), ...
        'YData', G.Nodes.Point(:, 2), 'ZData', G.Nodes.Point(:, 3), 'MarkerSize', 1, 'EdgeAlpha', 0.1, ...
        'NodeLabel', {});
        pause(0.0001)
    end
end