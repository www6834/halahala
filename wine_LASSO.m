% Shiyu Tu
% This is a code for Question 2 part2 (b) in Final Project

GetData = readtable('winesinfo.csv');

X_i = zeros(1599,11);
Y_i = zeros(1599,1);

for i = 1:1599
    for j = 1:11
        X_i(i,j) = table2array(GetData(i,j));
    end
    Y_i(i,1) = table2array(GetData(i,12));
end

m = 11;
gamma_1 = 1;
gamma_2 = 0.01;
gamma_3 = 0.001;
gamma_4 = 5;

% when gamma is 1
cvx_begin
    variable a(m)
    variable b(1)
    minimize(norm(Y_i - (X_i * a + b)) + gamma_1 * norm(a,1))
cvx_end
disp(a)

% when gamma is 0.01
cvx_begin
    variable a(m)
    variable b(1)
    minimize(norm(Y_i - (X_i * a + b)) + gamma_2 * norm(a,1))
cvx_end

% when gamma is 0.001
cvx_begin
    variable a(m)
    variable b(1)
    minimize(norm(Y_i - (X_i * a + b)) + gamma_3 * norm(a,1))
cvx_end

% find the four a_value that is not 0, which are the most important feature 

cvx_begin
    variable a(m)
    variable b(1)
    minimize(norm(Y_i - (X_i * a + b)) + gamma_4 * norm(a,1))
cvx_end

% The first, 6th, 7th, 11th feature are the most important features




