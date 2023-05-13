function b = f_collision_free(q, Obs)
    
    Obj_tmp = collisionBox(1, 1, 5);
    Obj_tmp.Pose = trvec2tform(q(1:3)) * eul2tform(q(4:6));
    
    [b1, ~, ~] = checkCollision(Obj_tmp, Obs(1));
    [b2, ~, ~] = checkCollision(Obj_tmp, Obs(2));
    [b3, ~, ~] = checkCollision(Obj_tmp, Obs(3));
    [b4, ~, ~] = checkCollision(Obj_tmp, Obs(4));

    b = ~any([b1, b2, b3, b4]);
end