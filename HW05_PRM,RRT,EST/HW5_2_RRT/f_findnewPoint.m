function q_new = f_findnewPoint(q_near, q_rand, step_size)

    delta = [(q_rand(1:3) - q_near(1:3)), angdiff(q_near(4:6), q_rand(4:6))];
    delta = delta / norm(delta, 2) * step_size;

    q_new = q_near + delta;

    for j=4:6
        if q_new(j) < 0
            q_new(j) = q_new(j) + 2 * pi;
        elseif q_new(j) > 2*pi
            q_new(j) = q_new(j) - 2 * pi;
        end
    end

end