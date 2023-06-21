function q_near = f_getNearestTpoint(G, q_rand)
    
    [n, ~] = size(G.Nodes.Name);
    min_dist = Inf;
    q_near = [0 0 0 0 0 0];

    for i=1:n
        q = G.Nodes.Point(i, :);
        dist = norm(q - q_rand, 2);
        if dist < min_dist
            min_dist = dist;
            q_near = q;
        end
    end
end