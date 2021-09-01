function [X] = sgd_acc(G,y,stop)
%% DESCRIPTION Computes the solution using Stochastic Gradient Descent.
% Stores all iterates of 'stop' steps.
% 'acc' stands for accumulated.
% Estimates the largest singular value to obtain an upper bound.

%% BODY
    N = size(G,2);
    X = zeros(N,stop);

    %---ESTIMATION OF S(1,1)---%
    p = 100; % Number of iterations.
    xk = rand(N,1);
    for k = 1:p
        xk = G'* (G * xk) / norm(xk,2);
        rho = sqrt(norm(xk,2));
    end

    %---PARAMETER SELECTION---%
    bound = 2/rho^2;
    a = 0.8422 * bound;

    %---STOCHASTIC GRADIENT DESCENT---%
    for k = 1:stop-1
        i = randi([1 N/2],1,1);
        grad = 2 * G(i,:)'* G(i,:) * X(:,k) - 2 * y(i) * G(i,:)';
        X(:,k+1) = X(:,k) - a * grad;
    end
end
