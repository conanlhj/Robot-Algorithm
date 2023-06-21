function N = f_KNN(X, y, k)

    [n, ~] = size(X);

    d = [];
    for i=1:n
        d = [d, dist(X(i, :), y)];
    end

    [~, N] = sort(d);
    N = N(1:k);
    
end

function d = dist(a, b)
    d = sqrt(norm(a(1:3) - b(1:3)) ^ 2 + ...
               sum(angdiff(a(4:6) - b(4:6)).^2));
end