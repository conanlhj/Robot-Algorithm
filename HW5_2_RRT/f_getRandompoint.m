function q = f_getRandompoint(Obs, q_goal)

    p = rand;

    if p < 0.1
        q = q_goal;
    else

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
    end
end