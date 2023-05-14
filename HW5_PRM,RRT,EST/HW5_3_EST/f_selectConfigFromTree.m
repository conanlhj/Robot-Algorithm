function q = f_selectConfigFromTree(G)

    [n, ~] = size(G.Nodes.Name);

    w = zeros(1, n);

    for i=1:n
        w(i) = 1 / (1 + degree(G, string(i)));
    end

    w = w / sum(w);

    q_idx = datasample(1:n, 1, "Weights", w);

    q = G.Nodes.Point(q_idx, :);
end