function f_draw(Obs, Obj, Goal, drawGoal)
    [~, patchObj] = show(Obs(1));
    patchObj.FaceColor = [0 1 1];
    patchObj.FaceAlpha = 0.3;
    patchObj.EdgeColor = 'none';
    hold on;
    [~, patchObj] = show(Obs(2));
    patchObj.FaceColor = [0 1 1];
    patchObj.FaceAlpha = 0.3;
    patchObj.EdgeColor = 'none';
    [~, patchObj] = show(Obs(3));
    patchObj.FaceColor = [0 1 1];
    patchObj.FaceAlpha = 0.3;
    patchObj.EdgeColor = 'none';
    [~, patchObj] = show(Obs(4));
    patchObj.FaceColor = [0 1 1];
    patchObj.FaceAlpha = 0.3;
    patchObj.EdgeColor = 'none';
    if drawGoal
        [~, patchObj] = show(Goal);
        patchObj.FaceColor = [0 1 0];
        patchObj.FaceAlpha = 0.5;
        patchObj.EdgeColor = 'none';
        [~, patchObj] = show(Obj);
        patchObj.FaceColor = [1 0 0];
        patchObj.EdgeColor = 'none';
    end
    axis([-10 10 -10 10 -10 10]);
    title('Real Unity')
end