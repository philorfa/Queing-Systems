clc;
clear all;
close all;
pkg load queueing;
#M/M/N/K system
lambda = [ones(1,8)*0.25;ones(1,8)];
mu = ones(1,8)*4.*[1,2,3,4,5,5,5,5];
for i=1:length(lambda(:,1))
Q = ctmcbd(lambda(i, :), mu);
p = ctmc(Q);
fprintf("Lambda ="); disp(lambda(i,1));
disp(p);
fprintf("Wait Probability ="); disp(p(5)+p(6)+p(7)+p(8));
c = erlangc (lambda(i, :) ./ mu, 5);
fprintf("erlang-c ="); disp(c);
fprintf("Wait Probability c erlang ="); disp(c(5)+c(6)+c(7)+c(8));
disp("");
endfor
function formul = erlangb_factorial(r, c)
fac = factorial(c);
num = r^c/fac;
paron = 0;
for i=0:1:c
paron = paron + r^i/factorial(i);
endfor
formul = num / paron;
endfunction
function retval = erlangb_iterative(r, c)
retval = 1;
counter = 0;
while (counter < c)
retval = r*retval / (r*retval + counter + 1);
counter = counter + 1;
endwhile
endfunction
fprintf("erlang_b factorial =");disp(erlangb_factorial(1024,1024)) ;
fprintf("erlang_b iterative =");disp(erlangb_iterative(1024,1024));
#Call Center design and analysis
Cs = 1:1:200;
for i=1:1:length(Cs)
Pblock(i) = erlangb_iterative(200*23/60, i);
endfor
colors = "rbgm";
figure(1);
plot(Cs,Pblock,colors(1),"linewidth",1.2);
title("P{Blocking} probability against number of lines");
xlabel("Number of lines");
ylabel("P{Blocking}");
for i=1:1:length(Cs)
if(Pblock(i) < 0.01)
fprintf("PBlocking drops below 0.01 at c ="); disp(i);
break;
endif;
endfor
#2 different servers
total_arrivals = 0; % to measure the total number of arrivals
rejected_arrivals = 0; % to measure teh number of clients that were blocked
current_state = 0; % holds the current state of the system
previous_mean_clients = 0; % will help in the convergence test
index = 0;
lambda = 1;
mu1 = 0.8;
mu2 = 0.4;
#threshold0 = lambda/(lambda + mu1 + mu2); % the threshold used to calculate probabilities
threshold1a = lambda/(lambda + mu1);
threshold1b = lambda/(lambda + mu2);
threshold2 = lambda/(lambda + mu1 + mu2);
threshold2dep = mu1/(mu1 + mu2);
transitions = 0; % holds the transitions of the simulation in transitions steps
arrivals = [0,0,0,0];
while transitions >= 0
transitions = transitions + 1; % one more transitions step
if mod(transitions,1000) == 0 % check for convergence every 1000 transitions steps
index = index + 1;
for i=1:1:length(arrivals)
P(i) = arrivals(i)/total_arrivals; % calcuate the probability of every state in the system
endfor
Pblock = rejected_arrivals / total_arrivals;
mean_clients = 1*P(2) + 1*P(4) + 2*P(3); % calculate the mean number of clients in the
system
to_plot(index) = mean_clients;
if abs(mean_clients - previous_mean_clients) < 0.00001 || transitions > 300000 %
convergence test
break;
endif
previous_mean_clients = mean_clients;
endif
random_number = rand(1); % generate a random number (Uniform distribution)
if current_state == 0
total_arrivals = total_arrivals + 1;
arrivals(current_state + 1) = arrivals(current_state + 1) + 1; % increase the number of
arrivals in the current state
current_state = 1; %s1 = 1 client in A
%if(transitions < 30)
%fprintf("current state is 0 and next is 1, ");
%endif
continue;
endif
if current_state == 1
if random_number < threshold1a %arrival
total_arrivals = total_arrivals + 1;
arrivals(current_state + 1) = arrivals(current_state + 1) + 1;
current_state = 2; %s2 = 2 clients
%if(transitions < 30)
%fprintf("current state is 1 and next is 2, "); disp(random_number);
%endif
else % departure
current_state = 0; %s0 = empty
%if(transitions < 30)
%fprintf("current state is 1 and next is 0, "); disp(random_number);
%endif
endif
continue;
endif
if current_state == 2
if random_number > threshold2 %departure
%if(transitions < 30)
%fprintf("current state is 2 and departure, "); disp(random_number);
%endif
random_number = rand(1);
if random_number < threshold2dep %A empties
current_state = 3; %s3 = 1 client in B
%if(transitions < 30)
%fprintf("next is 3, (<)"); disp(random_number); disp(threshold2dep);
%endif
else %B empties
current_state = 1; %s1 = 1 client in A
%if(transitions < 30)
%fprintf("next is 1, "); disp(random_number); disp(threshold2dep);
%endif
endif
else % arrival
total_arrivals = total_arrivals + 1;
rejected_arrivals = rejected_arrivals + 1;
arrivals(current_state + 1) = arrivals(current_state + 1) + 1;
%if(transitions < 30)
%fprintf("current state is 2 and next is 2"); disp(random_number);
%endif
% current_state stays the same
endif
continue;
endif
if current_state == 3
if random_number < threshold1b %arrival
total_arrivals = total_arrivals + 1;
arrivals(current_state + 1) = arrivals(current_state + 1) + 1;
current_state = 2; %s2 = 2 clients
%if(transitions < 30)
%fprintf("current state is 3 and next is 2"); disp(random_number);
%endif
else % departure
current_state = 0; %s0 = empty
%if(transitions < 30)
%fprintf("current state is 3 and next is 0"); disp(random_number);
%endif
endif
continue;
endif
endwhile
fprintf("P(0)="); disp(P(1));
fprintf("P(1a)="); disp(P(2));
fprintf("P(1b)="); disp(P(4));
fprintf("P(2)="); disp(P(3));
fprintf("P(Blocking)="); disp(Pblock);
fprintf("Mean Number of Clients="); disp(mean_clients);