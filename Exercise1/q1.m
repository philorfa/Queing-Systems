#1h OMADA ASKHSEWN
#KATANOMH POISSON
#A
k = 0:1:70;
lambda = [3, 10, 50];
for i = 1:columns(lambda)
    poisson(i, :) = poisspdf(k, lambda(i));
endfor
colors = "rbkm";
figure(1);
hold on;
for i = 1:columns(lambda)
    stem(k, poisson(i, :), colors(i), "linewidth", 1.2);
endfor
hold off;
title("probability density function of Poisson processes");
xlabel("k values");
ylabel("probability");
legend("lambda=3", "lambda=10", "lambda=50");
#B
lambda = [3, 10, 30, 50];
for i = 1:columns(lambda)
    poisson(i, :) = poisspdf(k, lambda(i));
endfor
index = find(lambda == 30);
chosen = poisson(index, :);
mean_value = 0;
for i = 0:(columns(poisson(index, :)) - 1)
    mean_value = mean_value + i .* poisson(index, i + 1);
endfor
display("mean value of Poisson with lambda 30 is");
display(mean_value);
second_moment = 0;
for i = 0:(columns(poisson(index, :)) - 1)
    second_moment = second_moment + i .* i .* poisson(index, i + 1);
endfor
variance = second_moment - mean_value .^ 2;
display("Variance of Poisson with lambda 30 is");
display(variance);
#C
first = find(lambda == 10);
second = find(lambda == 50);
poisson_first = poisson(first, :);
poisson_second = poisson(second, :);
composed = conv(poisson_first, poisson_second);
new_k = 0:1:(2 * 70);
figure(2);
hold on;
stem(k, poisson_first(:), colors(1), "linewidth", 1.2);
stem(k, poisson_second(:), colors(2), "linewidth", 1.2);
stem(new_k, composed, "mo", "linewidth", 2);
hold off;
title("Convolution of two Poisson processes");
xlabel("k values");
ylabel("Probability");
legend("lambda=10", "lambda=50", "new process");
#D
k = 0:1:200;
lambda = 30;
i = [10, 100, 1000];
n = lambda .* i;
p = lambda ./ n;
figure(3);
title("Poisson process as the limit of the binomial process");
xlabel("k values");
ylabel("Probability");
hold on;
for i = 1:3
    binomial = binopdf(k, n(i), p(i));
    stem(k, binomial, colors(i), 'linewidth', 1.2);
endfor
legend("n=300", "n=3000", "n=30000");
hold off;
# EKTHETIKH KATANOMH
#A
k = 0:0.00001:8;
lambda = [0.5, 1, 3];
for i = 1:columns(lambda)
    exp_pdf(i, :) = exppdf(k, lambda(i));
endfor
figure(4);
hold on;
for i = 1:columns(lambda)
    stem(k, exp_pdf(i, :), colors(i), "linewidth", 1.2);
endfor
hold off;
title("probability density function of Exponential processes");
xlabel("k values");
ylabel("probability");
legend("lambda=2", "lambda=1", "lambda=1/3");
#B
for i = 1:columns(lambda)
    exp_cdf(i, :) = expcdf(k, lambda(i));
endfor
figure(5);
hold on;
for i = 1:columns(lambda)
    stem(k, exp_cdf(i, :), colors(i), "linewidth", 1.2);
endfor
hold off;
title("Cumulative Distribution Function of Exponential processes");
xlabel("k values");
ylabel("probability");
legend("lambda=2", "lambda=1", "lambda=1/3");
#C
mean = 2.5;
exponential_cdf(4, :) = expcdf(k, mean);
display("P(X>30000) is");
display(1 - exponential_cdf(4, 30));
display("P(X>50000|X>20000) is");
display(1 - exponential_cdf(4, 50)) / (1 - exponential_cdf(4, 20));
#D
for i = 1:5000
    X(i, :) = [exprnd(2), exprnd(1)];
endfor
for i = 1:5000
    Y(i) = min(X(i, :));
endfor
mean2 = 0;
for i = 1:5000
    mean2 = mean2 + Y(i);
endfor
mean2 = mean2 / 5000;
display("Mean of Y=min{X1,X2} =");
disp(mean2);
max_Y = max(Y);
width_of_class = max_Y / 50;
figure(6);
hold on;
[NN, XX] = hist(Y, 50);
NN_without_free_variables = NN / width_of_class / 5000;
bar(XX, NN_without_free_variables);
plot(XX, NN_without_free_variables, "r", "linewidth", 1.3);
hold off;
title("Histogram of Y=min(X1,X2)");
xlabel("Classes");
ylabel("Number of elements");
# DIADIKASIA KATAMETRHSHS POISSON
#A
A(1) = exprnd(1 / 5);
for i = 2:100
    A(i) = A(i - 1) + exprnd(1 / 5);
    event(i) = i;
endfor
figure(7);
hold on;
stairs(A, event, "linewidth", 1.2);
hold off;
title("Poisson Proccess (100 points, lambda=5)");
xlabel("Time");
ylabel("Event Number");
#B
mean_arrivals = 100 / A(100);
display("Average number of arrivals per second =");
disp(mean_arrivals);
#C
between_49_50 = 0;
between_50_51 = 0;
for i = 1:100
    A(1) = exprnd(1 / 5);
    for j = 2:100
        A(j) = A(j - 1) + exprnd(1 / 5);
        event(j) = j;
    endfor
    between_49_50 = between_49_50 + A(50) - A(49);
    between_50_51 = between_50_51 + A(51) - A(50);
endfor
between_49_50 = between_49_50 / 100;
between_50_51 = between_50_51 / 100;
display("Average time between 49th and 50th event =");
disp(between_49_50);
display("Average time between 50th and 51st event =");
disp(between_50_51);
