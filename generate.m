function [G,y,u,d] = generate(N,q)
%% DESCRIPTION
% Discretization of the first-kind Fredholm integral equation
% for kernel K, integrand f(t), and output y(s).
%    K(s,t) = H(s - t),
%    f(t)   = u(t) + d(t),
%    y(s)   = integral(K(s,t) f(t), dt).
% t-discretization interval is [t_1, t_N].
% s-discretization interval is [t_1, t_N / 2].
% Interpreation: signal ampltiude caps halfway, at t_N / 2.

% Discretization scheme: Rectangular midpoint quadrature rule.

% Check input.
if (rem(N,2) ~= 0), error('The order N must be even.'), end

%% SIMULATION TIME t
[t_1, t_N] = deal(0, 10);
t = linspace(t_1, t_N, N);

%% GENERATE SYSTEM G
Dt = (t_N - t_1)/N;
G = Dt * tril(ones(N/2,N));

%% GENERATE INPUT u.
if (nargout > 2)
  u = ((sin(pi * t)).^2)';
end

%% GENERATE DISTURBANCE d
if (nargout == 4)
    switch q
    case 0   % NONE
        d = zeros(N,1);
    case 1   % CONSTANT
        d = ones(N,1);
    case 2   % SINUSOIDAL
        d = (sin(t))';
    case 3   % GAUSSIAN
        d = zeros(N,1);
        for k = 1:N
            d(k) = 0.2*randn();
        end
    otherwise
        error('ERROR: Disturbance type seclector "q" can only be: 0 (none), 1 (constant), 2 (sinusoidal), 3 (Gaussian).')
    end
end

%% GENERATE OUTPUT y
if (nargout > 1)
  y = G * (u + d);
  % Output is sustained at final value.
  % User plots y as follows.
  % y = [y; y(end) * ones(N/2, 1)];
end
