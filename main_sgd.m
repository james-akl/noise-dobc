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

%% SGD
stop = 20000;
X = sgd_acc(G,y_noisy,stop);

%% PLOT 1: "BEST" SGD SOLUTIONS
figure('Name','"Best" SGD Solutions');
plot(x_true,'-k','DisplayName','x_{true}');
hold on;
for j = stop-1:stop
    plot(X(1:N/2,j),'-.','DisplayName',strcat("k =", num2str(j)));
end
title('\textbf{SGD Solutions} $$\mathbf{x}_k$$','Interpreter','latex');
ylabel('Solution $$\mathbf{x}_k$$','Interpreter','latex');
xlabel('Index $$i$$','Interpreter','latex');
legend show;

%% COMPUTE NORMS
norm_error = zeros(stop,1);
norm_xk = zeros(stop,1);
norm_rk = zeros(stop,1);

for j = 1:stop/100
    xk = X(:,100*j);
    norm_error(j) = norm(x_true - xk,2);
    norm_xk(j) = norm(xk,2);
    norm_rk(j) = norm(G*xk-y_noisy,2);
end

%% PLOT 2: SOLUTION VERSUS RESIDUAL
figure('Name','L-Curve Plot Solution versus Residual');
semilogx(norm_rk(1:stop/100),norm_xk(1:stop/100),'.-','MarkerSize',12);
hold on;

% j-index the points.
label_d = .001*max(norm_xk);
for j = 1:stop/100
     plot(norm_rk(j),norm_xk(j),'rs');
     text(norm_rk(j),norm_xk(j)+label_d,num2str(j));
end

title('$$\Vert\mathbf{x}_k\Vert_2$$ \textbf{versus} $$\Vert\mathbf{r}_k\Vert_2$$','Interpreter','latex');
ylabel('SVD Solution $$\Vert\mathbf{x}_k\Vert_2$$','Interpreter','latex');
xlabel('Residual $$\Vert\mathbf{r}_k\Vert_2$$','Interpreter','latex');

%% PLOT 3: SIMULATION RESULTS
best = stop;

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
plot(t,y_noisy,'DisplayName','y_{noisy}');
%plot(t,y_hat,'DisplayName','y_{hat}');

title('\textbf{Simulation Results}: Inputs, Disturbances, Outputs','Interpreter','latex');
ylabel('Amplitude','Interpreter','latex');
xlabel('Index $$i$$','Interpreter','latex');
legend show;