% Shiyu Tu
% This is a code for Question 2 part1 (b) in Final Project

GetData = readtable('winesinfo.csv');


X_i = zeros(1599,11);
Y_i = zeros(1599,1);

for i = 1:1599
    for j = 1:11
        X_i(i,j) = table2array(GetData(i,j));
    end
    Y_i(i,1) = table2array(GetData(i,12));
end

%define Matrix and Variables
a_needcol = zeros(1,11); % we use aT
b_col = zeros(3198,1);
z_col = zeros(1599,1);
b = zeros(1,1);

% This is to find the minization of (z1 + ... + z1599)
% d = [a1 ... a11 b z1 ... z1599]'

% This problem is to find cT*d
% cT = [0 * (11+1=12) ... 1(z1) ... 1(z1599)] so c is 1611*1

% A is belong to 3198 * 1611
A = zeros(3198,1611);
c_needcol = zeros(1611,1); % use cT
d = zeros(1611,1);

% putting value into A
for i = 1:11
    A(1,i) = (-1)*X_i(1,i);
end

b_col(1,1) = (-1)*Y_i(1,1);
for i = 3:2:3198
    for j = 1:11
        A(i,j) = (-1)*X_i((i-1)/2+1,j);
        b_col(i,1) = (-1)*Y_i((i-1)/2+1,1);
    end
end
for i = 2:2:3198
    for j = 1:11
        A(i,j) = X_i(i/2,j);
        b_col(i,1) = Y_i(i/2,1);
    end
end

for i = 1:1599
   for j = 13:1611
       A((j-12)*2,j) = -1;
       A((j-12)*2-1,j) = -1;
   end
end

for i = 1:3198
   if mod(i,2) == 0 %even row
       A(i,12) = 1;
   else
       A(i,12) = -1;
   end
end

%putting value into c
for i = 13:1611
   c_needcol(i,1) = 1; 
end

% min        cTd
% subto      Ad <= b_col
f = c_needcol'/1599;

[d,fval] = linprog(f,A,b_col);

for i = 1:1611
    if i <= 11
        a_needcol(1,i)' == d(i,1);
    elseif i == 12
        b = d(12,1);
    elseif i > 12
        z_col(i-12,1) = d(i,1);
    end
end

d
fval



















