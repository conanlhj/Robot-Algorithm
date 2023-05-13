function result = f_Query_Algorithm(q_init, q_goal, k, G, Obs)
% q_init : the initial configuration
% q_goal : the goal configuration
% k : the number of closest neighbors to examine for each configuration
% G : the roadmap computed by roadmap construction
% dist_metric : distance metric used in norm
    
    G = addnode(G, table("q_init", q_init, 'VariableNames', {'Name', 'Point'}));
    G = addnode(G, table("q_goal", q_goal, 'VariableNames', {'Name', 'Point'}));

    N_q_init = f_KNN(G.Nodes.Point, q_init, k+1);
    N_q_goal = f_KNN(G.Nodes.Point, q_goal, k+1);
    
    N_q_init = N_q_init(1, 2:end);
    N_q_goal = N_q_goal(1, 2:end);
    
    qp_idx = 1;
    qp = N_q_init(qp_idx);
    qp_idx = qp_idx + 1;
    
    
    while true
        if ~isempty(f_delta(G, findnode(G, "q_init"), qp, Obs, 10))
            G = addedge(G, "q_init", string(qp));
            break
        else
            qp = N_q_init(qp_idx);
            qp_idx = qp_idx + 1;
            [~, c] = size(N_q_init);
            if qp_idx > c
                break
            end
        end
    end

    qp_idx = 1;
    qp = N_q_goal(qp_idx);
    qp_idx = qp_idx + 1;
    
    
    while true
        if ~isempty(f_delta(G, findnode(G, "q_goal"), qp, Obs, 10))
            G = addedge(G, "q_goal", string(qp));
            break
        else
            qp = N_q_goal(qp_idx);
            qp_idx = qp_idx + 1;
            [~, c] = size(N_q_goal);
            if qp_idx > c
                break
            end
        end
    end

    result = G;

end