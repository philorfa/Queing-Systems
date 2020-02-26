clc;
clear all;
close all;
pkg load queueing;
#M / M / 1
colors = "rbgm";
lambda = 5;
mu = 5.05:0.01:10;
[U, R, Q, X, p0] = qsmm1(lambda, mu);
figure(1);
hold on;
plot(mu, U, colors(1), "linewidth", 1.2);
hold off;
title("Utilization diagram");
xlabel("mu");
ylabel("Utilization");
figure(2);
hold on;
plot(mu, R, colors(1), "linewidth", 1.2);
hold off;
title("Server Response Time diagram");
xlabel("mu");
ylabel("Server Response Time");
figure(3);
hold on;
plot(mu, Q, colors(1), "linewidth", 1.2);
hold off;
title("Number of Customers diagram");
xlabel("mu");
ylabel("Average Number of Customers");
figure(4);
hold on;
plot(mu, X, colors(1), "linewidth", 1.2);
hold off;
title("Throughtput diagram");
xlabel("mu");
ylabel("Throughtput");
# M / M / 1 vs M / M / 2 comparison
[U2, R2, Q2, X2, p02] = qsmmm(10, 10, 2);
display(cstrcat("M/M/2 queue: E(T) = ", num2str(R2)));
[U1, R1, Q1, X1, p01] = qsmm1(5, 10);
display(cstrcat("2 M/M/1 queues: E(T) = ", num2str(R1)));
# Μ / Μ / 1 / 4, lamda = 5, mu = 1 / lamda = 5, mu = 5 / lamda = 5, mu = 20
lambda = 5;
mu = 10;
states = [0, 1, 2, 3, 4]; % system with capacity 4 states
% the initial state of the system. The system is initially empty.
initial_state = [0, 0, 0, 0, 1];
% define the birth and death rates between the states of the system.
births_B = [lambda, lambda / 2, lambda / 3, lambda / 4];
deaths_D = [mu, mu, mu, mu];
% get the transition matrix of the birth-death process
transition_matrix = ctmcbd(births_B, deaths_D);
% get the ergodic probabilities of the system
P = ctmc(transition_matrix);
display(transition_matrix);
figure(5);
bar(states, P, "r", 0.5);
display(cstrcat("E[n(t)] = ", num2str(sum(P .* [0, 1, 2, 3, 4]))));
display(cstrcat("P{Blocking} = ", num2str(P(5))));
index = 0;
for T = 0:0.01:50
    index = index + 1;
    P0 = ctmc(transition_matrix, T, initial_state);
    Prob0(index) = P0(1);
    if P0 - P < 0.01
        break;
    endif
endfor
T = 0:0.01:T;
figure(6);
plot(T, Prob0, "r", "linewidth", 1.3);
index = 0;
for T = 0:0.01:50
    index = index + 1;
    P0 = ctmc(transition_matrix, T, initial_state);
    Prob0(index) = P0(2);
    if P0 - P < 0.01
        break;
    endif
endfor
T = 0:0.01:T;
figure(7);
plot(T, Prob0, "r", "linewidth", 1.3);
index = 0;
for T = 0:0.01:50
    index = index + 1;
    P0 = ctmc(transition_matrix, T, initial_state);
    Prob0(index) = P0(3);
    if P0 - P < 0.01
        break;
    endif
endfor
T = 0:0.01:T;
figure(8);
plot(T, Prob0, "r", "linewidth", 1.3);
index = 0;
for T = 0:0.01:50
    index = index + 1;
    P0 = ctmc(transition_matrix, T, initial_state);
    Prob0(index) = P0(4);
    if P0 - P < 0.01
        break;
    endif
endfor
T = 0:0.01:T;
figure(9);
plot(T, Prob0, "r", "linewidth", 1.3);
index = 0;
for T = 0:0.01:50
    index = index + 1;
    P0 = ctmc(transition_matrix, T, initial_state);
    Prob0(index) = P0(5);
    if P0 - P < 0.01
        break;
    endif
endfor
T = 0:0.01:T;
figure(10);
plot(T, Prob0, "r", "linewidth", 1.3);
