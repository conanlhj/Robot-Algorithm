function total_path = f_getPath(G, P)

    [~, path_length] = size(P);
    total_path = [];
    
    for i=1:path_length-1
        q_start = G.Nodes.Point(P(i), :);
        q_end = G.Nodes.Point(P(i+1), :);

        n = 10;

        dist = sqrt(norm(q_end(1:3) - q_start(1:3)) ^ 2 + ...
           sum(angdiff(q_end(4:6) - q_start(4:6)).^2));

    
        step = dist / (n+1);
        
        delta = [(q_end(1:3) - q_start(1:3)), angdiff(q_start(4:6), q_end(4:6))] ./ dist;
        

        for k = 1:n

            point = q_start + delta .* step * k;
            
            for j=4:6
                if point(j) < 0
                    point(j) = point(j) + 2 * pi;
                elseif point(j) > 2*pi
                    point(j) = point(j) - 2 * pi;
                end
            end
            
            total_path = [total_path; point];

        end
    end


end