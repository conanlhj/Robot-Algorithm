function G = f_Roadmap_Construction(n, k, Obs, isRandomGeneration)
% n : number of nodes to put in the roadmap
% k : number of closest neighbors to examine for each configuration
% dist_metric : distance metric used in norm
% Obs : Obstacles

    G = graph;
    camAngle = 0;
    
    if (isRandomGeneration)
        V_cnt = 1;
        
        disp("Generating HammersleySequence...");
        H = f_GenerateHammersleySequence(n);
        disp("done.");
        H_idx = 1;
        
    
        disp("Generating G.V...");
        while (H_idx <= n)
    
            q = H(H_idx, :);
            H_idx = H_idx + 1;
    
            while (~f_collision_free(q, Obs))
                
                q = H(H_idx, :);
                H_idx = H_idx + 1;
                if (H_idx > n)
                    break;
                end
    
            end
            
            G = addnode(G, table(string(V_cnt), q, 'VariableNames', {'Name', 'Point'}));
            V_cnt = V_cnt + 1;
        end
        disp("done.");
    else
        V_cnt = 1;
        
        disp("Generating Random Points...");
         
        while (V_cnt <= n)
    
            q = [rand(1) * 16 - 8;
                 rand(1) * 16 - 8;
                 rand(1) * 16 - 8;
                 rand(1) * 2 * pi;
                 rand(1) * 2 * pi;
                 rand(1) * 2 * pi]';
    
            while (~f_collision_free(q, Obs))
                
                q = [rand(1) * 16 - 8;
                     rand(1) * 16 - 8;
                     rand(1) * 16 - 8;
                     rand(1) * 2 * pi;
                     rand(1) * 2 * pi;
                     rand(1) * 2 * pi]';
            end
            
            G = addnode(G, table(string(V_cnt), q, 'VariableNames', {'Name', 'Point'}));

            clf;
            f_draw(Obs, 0, 0, false);
            view(90,0);
            plot(G, 'XData', G.Nodes.Point(:, 1), ...
            'YData', G.Nodes.Point(:, 2), 'ZData', G.Nodes.Point(:, 3), 'MarkerSize', 2, 'EdgeAlpha', 0.05, ...
            'NodeLabel', {});
            pause(1e-100);

            V_cnt = V_cnt + 1;
        end
        disp("done.");
    end

    disp("Generating G.E...");
    disp(string(G.numnodes) + " remaining");
    cnt = 0;
    for q=1:G.numnodes

        N_q = f_KNN(G.Nodes.Point, G.Nodes.Point(q, :), k);
        [~, N_q_cnt] = size(N_q);
        
        for qp=1:N_q_cnt
            if findedge(G, string(q), string(N_q(qp))) == 0 && q ~= N_q(qp) && ...
                        ~isempty(f_delta(G, q, N_q(qp), Obs, 10))
                G = addedge(G, string(q), string(N_q(qp)));

                
            end

        end
        cnt = cnt + 1;
        if mod(cnt, 10) == 0
            disp(string(G.numnodes - cnt) + " remaining");
        end

            clf;
                f_draw(Obs, 0, 0, false);
                view(camAngle,0);
                camAngle = mod(camAngle + 0.5, 360);
                            plot(G, 'XData', G.Nodes.Point(:, 1), ...
            'YData', G.Nodes.Point(:, 2), 'ZData', G.Nodes.Point(:, 3), 'MarkerSize', 2, 'EdgeAlpha', 0.5, ...
            'NodeLabel', {});
                pause(1e-100);
    end
    disp("done.");
end