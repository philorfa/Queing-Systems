clc;
clear all;
close all;
pkg load queueing;
#2
a = 0.001:0.001:0.999;
C1 = 15000000;
C2 = 12000000;
mean_packet_size = 128 * 8;
m1 = C1 / mean_packet_size;
m2 = C2 / mean_packet_size;
min_T = 1000000;
for i = 1:length(a)
    lambda = 10000 .* [a(i), 1 - a(i)];
    E_n = lambda(1) / (m1 - lambda(1)) + lambda(2) / (m2 - lambda(2));
    gamma = sum(lambda);
    E_T(i) = E_n / gamma;
    if E_T(i) < min_T
        min_T = E_T(i);
        min_a = a(i);
    endif
endfor
figure(1);
plot(a, E_T, "b", "linewidth", 1.2);
title("Mean wait time relative to routing probability a");
xlabel("a");
ylabel("E(T)");
fprintf("minimum E(T) is %d for a = %d\n",min_T, min_a);
function [r, ergodic] = intensities(lambda, mu)
r(1) = lambda(1) / mu(1);
r(2) = (lambda(2) + 2 / 7 * lambda(1)) / mu(2);
r(3) = 4 / 7 * lambda(1) / mu(3);
r(4) = 3 / 7 * lambda(1) / mu(4);
r(5) = (lambda(2) + 4 / 7 * lambda(1)) / mu(5);
ergodic = 1;
disp("Intensities are:");
fprintf("r(1)= %d\n",r(1));
fprintf("r(2)= %d\n",r(2));
fprintf("r(3)= %d\n",r(3));
fprintf("r(4)= %d\n",r(4));
fprintf("r(5)= %d\n",r(5));
for i = 1:length(r)
    if r(i) >= 1
        ergodic = 0;
        break;
    endif
endfor
endfunction
function [E_m] = mean_clients (lambda, mu)
[r, ergodic] = intensities(lambda, mu);
if ergodic == 0
    error("System is not ergodic, cannot calculate mean number of clients");
endif
for i = 1:columns(r)
    E_m(i) = r(i) / (1 - r(i));
endfor
endfunction
#3 / 4
lambda = [4, 1];
mu = [6, 5, 8, 7, 6];
E_n_total = sum(mean_clients(lambda, mu));
gamma = sum(lambda);
fprintf("Average wait time in the system is %d\n",E_n_total/gamma);
#3 / 6
max = 6;
lambda1 = (0.1 * max):0.01:(0.99 * max);
lambda2 = 1;
mu = [6, 5, 8, 7, 6];
for i = 1:length(lambda1)
    E_T_new(i) = sum(mean_clients([lambda1(i), lambda2], mu)) / (lambda1(i) + lambda2);
endfor;
figure(2);
plot(lambda1, E_T_new, "r", "linewidth", 1.2);
title("Mean wait time relative to lambda1");
xlabel("lambda1");
ylabel("E(T)");
