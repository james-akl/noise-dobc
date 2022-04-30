%% INITIALIZE
clc; clear; close all;

%% GENERATE SYSTEM
% {q = 0} -> {d = 0}      % {q = 1} -> {d = 1}
% {q = 2} -> {d = sin(t)} % {q = 4} -> {d = Gaussian(mu=0, sigma=0.2)}
q = 2;    % Distrubance type selector.
N = 1000; % Problem size, must be even.
t = linspace(0,20,N); % Discretized time.
[G, y_true, u, d] = generate(N,q);
x_true = u + d;

%% GENERATE OUTPUT TRANSMISSION NOISE
e = zeros(N/2,1);
for i = 1:N/2, e(i) = 0.1*randn(); end
y_noisy = y_true + e;

%% SVD
[U, S, V] = svd(G);
s = diag(S);

%% TIKHONOV REGULARIZATION
r = 30; % number of instances for regularization parameter.
a = logspace(-3,1,r);
X = zeros(N,r);

p = zeros(r,1);   % plot storage.
q = zeros(r+1,1); % plot storage.

norm_error = zeros(r,1);
norm_xa = zeros(r,1);
norm_ra = zeros(r,1);

for j = 1:r
    xa = zeros(N,1);
    f = s.^2 ./ (s.^2 + a(j)^2);
    for k = 1:N/2
        xa = xa + f(k) .* U(:,k)'*y_noisy / s(k) * V(:,k);
    end
    X(:,j) = xa;
    norm_error(j) = norm(x_true - xa,2);
    norm_xa(j) = norm(xa,2);
    norm_ra(j) = norm(G*xa-y_noisy,2);
end

%% PLOT 1: "BEST" TIKHONOV SOLUTIONS
figure('Name','"Best" Tikhonov Solutions');
plot(x_true,'-k','DisplayName','x_{true}');
hold on;
for j = 14:17
    plot(X(1:N/2,j),'-.','DisplayName',strcat("\alpha =", num2str(a(j))));
end
title('\textbf{Tikhonov Solutions} $$\mathbf{x}_\alpha$$','Interpreter','latex');
ylabel('Solution $$\mathbf{x}_\alpha$$','Interpreter','latex');
xlabel('Index $$i$$','Interpreter','latex');
legend show;

%% PLOT 2: SOLUTION VERSUS RESIDUAL
figure('Name','L-Curve Plot Solution versus Residual');
semilogx(norm_ra,norm_xa,'.-','MarkerSize',12);
hold on;

% j-index the points.
label_d = .001*max(norm_xa);
for j = 1:r
     plot(norm_ra(j),norm_xa(j),'rs');
     text(norm_ra(j),norm_xa(j)+label_d,num2str(j));
end

title('$$\Vert\mathbf{x}_\alpha\Vert_2$$ \textbf{versus} $$\Vert\mathbf{r}_\alpha\Vert_2$$','Interpreter','latex');
ylabel('SVD Solution $$\Vert\mathbf{x}_\alpha\Vert_2$$','Interpreter','latex');
xlabel('Residual $$\Vert\mathbf{r}_\alpha\Vert_2$$','Interpreter','latex');

%% PLOT 3: SIMULATION RESULTS
best = 15;

figure('Name','Simulation: Inputs, Disturbances, Outputs');

d_hat = X(1:N/2,best)-u(1:N/2);
y_true = [y_true; y_true(end) * ones(N/2, 1)];
y_noisy = [y_noisy; y_noisy(end) * ones(N/2, 1)];
y_hat = G(1:N/2,1:N/2)*(u(1:N/2)+d_hat);
y_hat = [y_hat; y_hat(end) * ones(N/2, 1)];

hold on;
plot(t,u,'DisplayName','u');
plot(t,d,'DisplayName','d');
plot(t(1:N/2),d_hat,'DisplayName','d_{hat}');
plot(t,y_true,'DisplayName','y_{true}');
%plot(t,y_noisy,'DisplayName','y_{noisy}');
plot(t,y_hat,'DisplayName','y_{hat}');

title('\textbf{Simulation Results}: Inputs, Disturbances, Outputs','Interpreter','latex');
ylabel('Amplitude','Interpreter','latex');
xlabel('Index $$i$$','Interpreter','latex');
legend show;