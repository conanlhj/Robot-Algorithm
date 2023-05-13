function G = f_RRT(q_init, q_goal, Obs, step_size)
    
    G = graph;
    G = addnode(G, table("1", q_init, 'VariableNames', {'Name', 'Point'}));
    V_cnt = 2;
    flag = false;
    
    clf;
    f_draw(Obs, 0, 0, false);
    plot(G, 'XData', G.Nodes.Point(:, 1), ...
    'YData', G.Nodes.Point(:, 2), 'ZData', G.Nodes.Point(:, 3), 'MarkerSize', 1, 'EdgeAlpha', 0.8);
    pause(1);

    camAngle = 0;


    while true
        
        q_rand = f_getRandompoint(Obs, q_goal);
        q_near = f_getNearestTpoint(G, q_rand);
        cnt = 0;

        while true
            cnt = cnt + 1;
            q_new = f_findnewPoint(q_near, q_rand, step_size);
            

            if norm(q_near - q_goal, 2) < step_size
                G = addnode(G, table(string(V_cnt), q_goal, 'VariableNames', {'Name', 'Point'}));
                k = find(all(G.Nodes.Point==q_near, 2));
                G = addedge(G, string(k), string(V_cnt));
                flag = true;
                break;
            elseif norm(q_near - q_rand, 2) < step_size
                break;
            elseif isempty(f_delta(G, q_near, q_new, Obs, 10))
                break;
            elseif cnt > 100
                break;
            end
            
            G = addnode(G, table(string(V_cnt), q_new, 'VariableNames', {'Name', 'Point'}));
            k = find(all(G.Nodes.Point==q_near, 2));
            G = addedge(G, string(k), string(V_cnt));

            V_cnt = V_cnt + 1;
            q_near = q_new;
        end

        clf(1);
        f_draw(Obs, 0, 0, false);
        view(camAngle,0);
        camAngle = mod(camAngle+0.5, 360);
        plot(G, 'XData', G.Nodes.Point(:, 1), ...
        'YData', G.Nodes.Point(:, 2), 'ZData', G.Nodes.Point(:, 3), 'MarkerSize', 1, 'EdgeAlpha', 0.8, ...
        'NodeLabel', {});
        pause(0.0001)

        if flag
            break
        end
    end

end