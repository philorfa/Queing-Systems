clc;
clear all;
close all;
pkg load queueing;
function [U, R, Q, X] = qsmd1(lambda, mu)
U = lambda / mu;
if (U >= 1)
    error ("System is not ergodic");
endif
R = 1 / mu + 1 / 2 * U / (mu * (1 - U));
Q = U + 1 / 2 * U ^ 2 / (1 - U);
X = lambda;
endfunction
#Comparison between M / M / 1 and M / D / 1
#3
lambda = 0.1:0.01:2.9;
mu = 3;
for i = 1:columns(lambda)
    [Um(i), Rm(i), Qm(i), Xm(i), pm0(i)] = qsmm1(lambda(i), mu);
    [Ud(i), Rd(i), Qd(i), Xd(i)] = qsmd1(lambda(i), mu);
endfor
colors = "rbgm";
figure(1);
hold on;
plot(Um, Qm, colors(1), "linewidth", 1.2);
plot(Ud, Qd, colors(2), "linewidth", 1.2);
hold off;
title("Mean number of customers");
xlabel("Utilization");
ylabel("Mean number of customers");
legend("M/M/1", "M/D/1");
figure(2);
hold on;
plot(Um, Rm, colors(1), "linewidth", 1.2);
plot(Ud, Rd, colors(2), "linewidth", 1.2);
hold off;
title("Average wait time");
xlabel("Utilization");
ylabel("Average wait time");
legend("M/M/1", "M/D/1");
% M/M/1/10 simulation. We will find the probabilities of the first states.
% Note: Due to ergodicity, every state has a probability >0.
lambda = [1, 5, 10];
mu = 5;
for j = 1:1:3
    %disp("Starting trace...");
    states = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    rand("seed", 1);
    total_arrivals = 0; % to measure the total number of arrivals
    blocked_arrivals = 0;
    current_state = 0; % holds the current state of the system
    previous_mean_clients = 0; % will help in the convergence test
    index = 0;
    threshold = lambda(j) / (lambda(j) + mu); % the threshold used to calculate probabilities
    arrivals = zeros(1, 11);
    transitions = 0; % holds the transitions of the simulation in transitions steps
    while transitions >= 0
        transitions = transitions + 1; % one more transitions step
        if mod(transitions, 1000) == 0 % check for convergence every 1000 transitions steps
            index = index + 1;
            for i = 1:1:length(arrivals)
                P(i) = arrivals(i) / total_arrivals; % calculate the probability of every state in the system
            endfor
            Pblock = blocked_arrivals / total_arrivals;
            mean_clients = 0; % calculate the mean number of clients in the system
            for i = 1:1:length(arrivals)
                mean_clients = mean_clients + (i - 1) .* P(i);
            endfor
            gamma = lambda(j) * (1 - Pblock);
            mean_wait_time = mean_clients / gamma;
            to_plot(index) = mean_clients;
            if abs(mean_clients - previous_mean_clients) < 0.00001 || transitions > 1000000 %
                convergence test
                break;
            endif
            previous_mean_clients = mean_clients;
        endif
        random_number = rand(1); % generate a random number (Uniform distribution)
        if current_state == 0 % arrival
            total_arrivals = total_arrivals + 1;
            arrivals(current_state + 1) = arrivals(current_state + 1) + 1; % increase the number of
            arrivals in the current state
            %if transitions <= 30
            %fprintf("State: 0, arrival, arrivals in this state: %d\n", arrivals(1));
            %endif
            current_state = current_state + 1;
        else
            if random_number < threshold % arrival
                if current_state == 10 % blocked
                    total_arrivals = total_arrivals + 1;
                    arrivals(current_state + 1) = arrivals(current_state + 1) + 1;
                    blocked_arrivals = blocked_arrivals + 1;
                    %if transitions <= 30
                    %fprintf("State: 10, arrival, arrivals in this state: %d\n", arrivals(11));
                    %endif
                else
                    total_arrivals = total_arrivals + 1;
                    arrivals(current_state + 1) = arrivals(current_state + 1) + 1;
                    %if transitions <= 30
                    %fprintf("State: %d, arrival, arrivals in this state: %d\n", current_state,
                    arrivals(current_state + 1));
                    %endif
                    current_state = current_state + 1;
                endif
            else % departure
                %if transitions <= 30
                %fprintf("State: %d, departure, arrivals in this state: %d\n", current_state,
                arrivals(current_state + 1));
                %endif
                current_state = current_state - 1;
            endif
        endif
    endwhile
    fprintf("Ergodic probabilities for lambda = %d\n", lambda(j));
    for i = 1:1:length(arrivals)
        fprintf("P( %d) = %d\n", i-1, P(i));
    endfor
    fprintf("Pblock for lambda = %d: Pblock = %d\n", lambda(j), Pblock);
    fprintf("Mean number of clients for lambda = %d: E[n(t)] = %d\n", lambda(j), mean_clients);
    fprintf("Mean wait time for lambda = %d: E[T] = %d\n\n", lambda(j), mean_wait_time);
    figure(2 * j + 1);
    plot(to_plot, "r", "linewidth", 1.3);
    title("Average number of clients in the M/M/1/10 queue: Convergence");
    xlabel("transitions in thousands");
    ylabel("Average number of clients");
    figure(2 * j + 2);
    bar(states, P, 'r', 0.4);
    title("Probabilities");
endfor
%M/M/1/5 with variable service rate simulation
lambda = 3;
mu = [2, 3, 4, 5, 6];
Q = ctmcbd(lambda .* ones(1, 5), mu);
p = ctmc(Q);
fprintf("Ergodic probabilities of M/M/1/5 as calculated by queuing package:\n");
disp(p);
mean_clients_real = 0;
for i = 1:1:length(p)
    mean_clients_real = mean_clients_real + p(i) * (i - 1);
endfor
fprintf("Mean clients of M/M/1/5 as calculated by queuing package:\n");
disp(mean_clients_real); disp("");
%disp("Starting trace...");
states = [0, 1, 2, 3, 4, 5];
difference = [0.01, 0.001, 0.0001, 0.00001, 0.000001, 0.0000001];
for j = 1:1:length(difference)
    rand("seed", 1);
    total_arrivals = 0; % to measure the total number of arrivals
    blocked_arrivals = 0;
    current_state = 0; % holds the current state of the system
    previous_mean_clients = 0; % will help in the convergence test
    index = 0;
    threshold = lambda ./ (lambda . + mu); % the threshold used to calculate probabilities
    arrivals = zeros(1, 6);
    clear P; clear to_plot;
    transitions = 0; % holds the transitions of the simulation in transitions steps
    while transitions >= 0
        transitions = transitions + 1; % one more transitions step
        if mod(transitions, 1000) == 0 % check for convergence every 1000 transitions steps
            index = index + 1;
            for i = 1:1:length(arrivals)
                P(i) = arrivals(i) / total_arrivals; % calculate the probability of every state in the system
            endfor
            Pblock = blocked_arrivals / total_arrivals;
            mean_clients = 0; % calculate the mean number of clients in the system
            for i = 1:1:length(arrivals)
                mean_clients = mean_clients + (i - 1) .* P(i);
            endfor
            to_plot(index) = mean_clients;
            if abs(mean_clients - previous_mean_clients) < difference(j) || transitions > 20000000 %
                convergence test
                break;
            endif
            previous_mean_clients = mean_clients;
        endif
        random_number = rand(1); % generate a random number (Uniform distribution)
        if current_state == 0 % arrival
            total_arrivals = total_arrivals + 1;
            arrivals(current_state + 1) = arrivals(current_state + 1) + 1; % increase the number of
            arrivals in the current state
            %if transitions <= 30
            %fprintf("State: 0, arrival, arrivals in this state: %d\n", arrivals(1));
            %endif
            current_state = current_state + 1;
        else
            if random_number < threshold(current_state) % arrival
                if current_state == 5 % blocked
                    total_arrivals = total_arrivals + 1;
                    arrivals(current_state + 1) = arrivals(current_state + 1) + 1;
                    blocked_arrivals = blocked_arrivals + 1;
                    %if transitions <= 30
                    %fprintf("State: 10, arrival, arrivals in this state: %d\n", arrivals(11));
                    %endif
                else
                    total_arrivals = total_arrivals + 1;
                    arrivals(current_state + 1) = arrivals(current_state + 1) + 1;
                    %if transitions <= 30
                    %fprintf("State: %d, arrival, arrivals in this state: %d\n", current_state,
                    arrivals(current_state + 1));
                    %endif
                    current_state = current_state + 1;
                endif
            else % departure
                %if transitions <= 30
                %fprintf("State: %d, departure, arrivals in this state: %d\n", current_state,
                arrivals(current_state + 1));
                %endif
                current_state = current_state - 1;
            endif
        endif
    endwhile
    fprintf("Ergodic probabilities of M/M/1/5 by simulation:\n");
    for i = 1:1:length(arrivals)
        fprintf("P( %d) = %d\n", i-1, P(i));
    endfor
    fprintf("Pblock = %d\n", Pblock);
    fprintf("Mean number of clients: E[n(t)] = %d\n", mean_clients);
    mean_error(j) = abs(mean_clients_real - mean_clients);
    trans(j) = transitions;
endfor
figure(11);
bar(mean_error, 'r', 0.4);
title("Mean abs error");
figure(12);
bar(trans, 'r', 0.4);
title("Number of transitions required");
