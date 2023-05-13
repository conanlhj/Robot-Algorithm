function q_near = f_getRandomPointNearQ(q, Obs, q_goal)

    if rand < 0.1
        q_near = q_goal;
    else
        q_near = zeros(1, 6);
        q_near(1:3) = q(1:3) + randn(1, 3)*2;
        q_near(4:6) = q(4:6) + randn(1, 3);
        tmp = q_near(4:6);
        tmp(tmp < 0) = tmp(tmp < 0) + 2*pi;
        tmp(tmp > 2*pi) = tmp(tmp > 2*pi) - 2*pi;
        q_near(4:6) = tmp;
    
    
        while (~f_collision_free(q_near, Obs) || ~isInbound(q_near))                  
           q_near(1:3) = q(1:3) + randn(1, 3)*2;
            q_near(4:6) = q(4:6) + randn(1, 3);
            tmp = q_near(4:6);
            tmp(tmp < 0) = tmp(tmp < 0) + 2*pi;
            tmp(tmp > 2*pi) = tmp(tmp > 2*pi) - 2*pi;
            q_near(4:6) = tmp;
        end
    end
end


function b = isInbound(q_near)
    b = all(q_near(1:3) > -8) && all(q_near(1:3) < 8);
end