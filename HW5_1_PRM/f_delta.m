function P = f_delta(G, q, qp, Obs, n)
    q_point = G.Nodes.Point(q, :);
    qp_point = G.Nodes.Point(qp, :);

    dist = sqrt(norm(qp_point(1:3) - q_point(1:3)) ^ 2 + ...
           sum(angdiff(qp_point(4:6) - q_point(4:6)).^2));

    
    step = dist / (n+1);
    
    delta = [(qp_point(1:3) - q_point(1:3)), angdiff(q_point(4:6), qp_point(4:6))] ./ dist;


    P = [q_point];
    
    for i = 1:n

        point = q_point + delta .* step * i;
        
        for j=4:6
            if point(j) < 0
                point(j) = point(j) + 2 * pi;
            elseif point(j) > 2*pi
                point(j) = point(j) - 2 * pi;
            end
        end
        if f_collision_free(point, Obs)
            P = [P; point];
        else
            P = [];
            break;
        end
    end
    if ~isempty(P)
        P = [P; G.Nodes.Point(qp, :);];
    end
end