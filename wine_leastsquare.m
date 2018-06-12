% Shiyu Tu
% This is a code for Question 2 part2 (a) in Final Project

GetData = readtable('winesinfo.csv');

X_i = zeros(1599,11);
Y_i = zeros(1599,1);

for i = 1:1599
    for j = 1:11
        X_i(i,j) = table2array(GetData(i,j));
    end
    Y_i(i,1) = table2array(GetData(i,12));
end


n = 1599;
m = 11;
cvx_begin
    variable a(m)
    variable b(1)
    minimize(norm(Y_i - X_i * a - b))
cvx_end

