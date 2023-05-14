function H = f_GenerateHammersleySequence(N)
    function r = Phi(i, b)
        r = 0;
        f = 1.0 / b;
    
        while (i > 0)
            r = r + f * mod(i, b);
            i = floor(i / b);
            f = f / b;
        end
    end

    H = zeros(N, 6);
    
    for i=1:N
    
        H(i, 1) = i/N * 16 - 8;
        H(i, 2) = Phi(i, 2) * 16 - 8;
        H(i, 3) = Phi(i, 3) * 16 - 8;
        H(i, 4) = Phi(i, 4) * 2 *pi;
        H(i, 5) = Phi(i, 5) * 2 *pi;
        H(i, 6) = Phi(i, 6) * 2 *pi;
        
    end
end