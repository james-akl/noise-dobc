function [X] = cgls_acc(G,y)
%% DESCRIPTION
% Computes the CGLS and stores all iterates of 'N' steps.
% 'acc' stands for accumulated.

%% BODY
    x = 0;
    s = y;
    r = G' * y;
    p = r;
    N = size(G,2);
    X = zeros(N);
    
    for k = 1:N
        r_old = r;
        Gp = G * p;
        a = (norm(r_old,2) / norm(Gp,2))^2;
        x = x + a * p;
        s = s - a * Gp;
        r = G' * s;
        b = (norm(r,2) / norm(r_old,2))^2;
        p = r + b * p;
        X(:,k) = x;
    end
end