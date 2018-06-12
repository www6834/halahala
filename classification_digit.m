load azip.mat; %load training matrix 256*1707
load dzip.mat; %load the correct answer of the training digits 1*1707
load dtest.mat; %load the correct answer of the test digits 1*2007
load testzip.mat %load test digits data 256*2007

num = zeros(1,10); %get how many numbers in 0-9 classes
for i = 1:1707
    if dzip(i) == 0
        num(10) = num(10) + 1;
    elseif dzip(i) == 1
        num(1) = num(1) + 1;
    elseif dzip(i) == 2
        num(2) = num(2) + 1;
    elseif dzip(i) == 3
        num(3) = num(3) + 1;
    elseif dzip(i) == 4
        num(4) = num(4) + 1;
    elseif dzip(i) == 5
        num(5) = num(5) + 1;
    elseif dzip(i) == 6
        num(6) = num(6) + 1;
    elseif dzip(i) == 7
        num(7) = num(7) + 1;
    elseif dzip(i) == 8
        num(8) = num(8) + 1;
    elseif dzip(i) == 9
        num(9) = num(9) + 1;
    end
end

for i = 1:10                       % get variables started
    Matrix{i} = zeros(256,num(i));
    Upper{i} = zeros(256,num(i));
    Sig{i} = zeros(256,num(i));
    Vig{i} = zeros(256,num(i));
    X_5{i} = zeros(256,num(i));
    X_10{i} = zeros(256,num(i));
    X_20{i} = zeros(256,num(i));
    Bk{i} = zeros(256,num(i));    
end

numcount = zeros(1,10);
for i = 1:1707              % classificate numbers according to dzip
    if dzip(i) == 0
        numcount(10) = numcount(10) + 1;
        Matrix{10}(:,numcount(10)) = azip(:,i);
    elseif dzip(i) == 1
        numcount(1) = numcount(1) + 1;
        Matrix{1}(:,numcount(1)) = azip(:,i);
    elseif dzip(i) == 2
        numcount(2) = numcount(2) + 1;
        Matrix{2}(:,numcount(2)) = azip(:,i);
    elseif dzip(i) == 3
        numcount(3) = numcount(3) + 1;
        Matrix{3}(:,numcount(3)) = azip(:,i);
    elseif dzip(i) == 4
        numcount(4) = numcount(4) + 1;
        Matrix{4}(:,numcount(4)) = azip(:,i);
    elseif dzip(i) == 5
        numcount(5) = numcount(5) + 1;
        Matrix{5}(:,numcount(5)) = azip(:,i);
    elseif dzip(i) == 6
        numcount(6) = numcount(6) + 1;
        Matrix{6}(:,numcount(6)) = azip(:,i);
    elseif dzip(i) == 7
        numcount(7) = numcount(7) + 1;
        Matrix{7}(:,numcount(7)) = azip(:,i);
    elseif dzip(i) == 8
        numcount(8) = numcount(8) + 1;
        Matrix{8}(:,numcount(8)) = azip(:,i);
    elseif dzip(i) == 9
        numcount(9) = numcount(9) + 1;
        Matrix{9}(:,numcount(9)) = azip(:,i);
    end
end

for i = 1:10                 %get the SVD values and other varibalesstarted
    [Upper{i},Sig{i},Vig{i}] = svd(Matrix{i});
    Matrix_SVD5{i} = zeros(256,1);
    Matrix_SVD10{i} = zeros(256,1);
    Matrix_SVD20{i} = zeros(256,1);
     U5{i} = zeros(256,5);
     U10{i} = zeros(256,10);
     U20{i} = zeros(256,20);
     findvalue1{i} = zeros(1,10);
     findvalue2{i} = zeros(1,10);
     findvalue3{i} = zeros(1,10);
end


for i = 1:10                         % get the U for different numbers, and get the first 5,10,20 SVD
    for j = 1:20
        U20{i}(:,j) = Upper{i}(:,j);
        Matrix_SVD20{i} = Matrix_SVD20{i} + Upper{i}(:,j) * Sig{i}(j,j) * Vig{i}(:,j)';
        if j <= 10
            U10{i}(:,j) = Upper{i}(:,j);
            Matrix_SVD10{i} = Matrix_SVD20{i} + Upper{i}(:,j) * Sig{i}(j,j) * Vig{i}(:,j)';
             if j <= 5
                U5{i}(:,j) = Upper{i}(:,j);
                Matrix_SVD5{i} = Matrix_SVD20{i} + Upper{i}(:,j) * Sig{i}(j,j) * Vig{i}(:,j)';
             end
        end
    end
end

for i = 1:2007            %get started to calculate norm
     for j = 1:10
         ResidualE1{i}{j} = zeros(1,1);
         ResidualE2{i}{j} = zeros(1,1);
         ResidualE3{i}{j} = zeros(1,1);
     end
end

%get the testzip value
Testvalue_5 = zeros(1,2007);
Testvalue_10 = zeros(1,2007);
Testvalue_20 = zeros(1,2007);
A = 0;
B = 0;
C = 0;

%get the first 5,10,20 singular vectors and get the norm value
for i = 1:2007
   for j = 1:10
           A = (eye(256) - U5{j}* U5{j}')*testzip(:,i);
           ResidualE1{i}{j} = norm(A); 
           findvalue1{i}(1,j) = ResidualE1{i}{j};
           
           B = (eye(256) - U10{j} * U10{j}')*testzip(:,i);
           ResidualE2{i}{j} = norm(B); 
           findvalue2{i}(1,j) = ResidualE2{i}{j};
           
           C = (eye(256) - U20{j} * U20{j}')*testzip(:,i);
           ResidualE3{i}{j} = norm(C);
           findvalue3{i}(1,j) = ResidualE3{i}{j};
   end
   
   Minivalue1 = min(findvalue1{i}(:));
   Minivalue2 = min(findvalue2{i}(:));
   Minivalue3 = min(findvalue3{i}(:)); 
   
   for k = 1:10                       % find for the number with min value
        if Minivalue1 == findvalue1{i}(1,k);
            Testvalue_5(1,i) = k;
            if k == 10;
                Testvalue_5(1,i) = 0;
            end
       end
   end
   for n = 1:10
        if Minivalue2 == findvalue2{i}(1,n);
            Testvalue_10(1,i) = n;
            if n == 10;
                Testvalue_10(1,i) = 0;
            end
       end
   end
   for m = 1:10
        if Minivalue3 == findvalue3{i}(1,m);
            Testvalue_20(1,i) = m;
            if m == 10;
                Testvalue_20(1,i) = 0;
            end
       end
   end
end

correction_5 = 0;
correction_10 = 0;
correction_20 = 0;

%get the percentage of correction of U5,U10,U20
for i = 1:2007
    if Testvalue_5(i) == dtest(i)
        correction_5 = correction_5 + 1;
    end
    if Testvalue_10(i) == dtest(i)
        correction_10 = correction_10 + 1;
    end
    if Testvalue_20(i) == dtest(i)
        correction_20 = correction_20 + 1;
    end
end

percentage_firstfew = zeros(1,3);
 
percentage_firstfew(1) = correction_5 / 2007 * 100;
percentage_firstfew(2) = correction_10 / 2007 * 100;
percentage_firstfew(3) = correction_20 / 2007 * 100;

%draw the table for perentage of correctly basis
BasisImages = {'First5';'First10';'First20'};
CorrectPercentage = [percentage_firstfew(1);percentage_firstfew(2);percentage_firstfew(3)];
T = table(BasisImages,CorrectPercentage)

countCnum5 = zeros(1,10);
countCnum10 = zeros(1,10);
countCnum20 = zeros(1,10);

testnum = zeros(1,10);
for i = 1:2007
    if dtest(i) == 0
        testnum(10) = testnum(10) + 1;
    elseif dtest(i) == 1
        testnum(1) = testnum(1) + 1;
    elseif dtest(i) == 2
        testnum(2) = testnum(2) + 1;
    elseif dtest(i) == 3
        testnum(3) = testnum(3) + 1;
    elseif dtest(i) == 4
        testnum(4) = testnum(4) + 1;
    elseif dtest(i) == 5
        testnum(5) = testnum(5) + 1;
    elseif dtest(i) == 6
        testnum(6) = testnum(6) + 1;
    elseif dtest(i) == 7
        testnum(7) = testnum(7) + 1;
    elseif dtest(i) == 8
        testnum(8) = testnum(8) + 1;
    elseif dtest(i) == 9
        testnum(9) = testnum(9) + 1;
    end
end

for i = 1:2007
    if  dtest(i) == Testvalue_5(i)
        if dtest(i) == 0
            countCnum5(1,10) = countCnum5(1,10) + 1;
        else
            countCnum5(1,dtest(i)) = countCnum5(1,dtest(i)) + 1;
        end
    end
    if  dtest(i) == Testvalue_10(i)
        if dtest(i) == 0
            countCnum10(1,10) = countCnum10(1,10) + 1;
        else
            countCnum10(1,dtest(i)) = countCnum10(1,dtest(i)) + 1;
        end
    end
    if  dtest(i) == Testvalue_20(i)
        if dtest(i) == 0
            countCnum20(1,10) = countCnum20(1,10) + 1;
        else
            countCnum20(1,dtest(i)) = countCnum20(1,dtest(i)) + 1;
        end
    end    
end

percentageMatrix = zeros(3,10);

for i = 1:10
   percentageMatrix(1,i) = countCnum5(i)/testnum(i)*100;
   percentageMatrix(2,i) = countCnum10(i)/testnum(i)*100;
   percentageMatrix(3,i) = countCnum20(i)/testnum(i)*100;
end
percentageMatrix = percentageMatrix';


%draw the table for percentage of correctly classified digits as a
%function of basis vectors
rowNames = {'1','2','3','4','5','6','7','8','9','0'};
colNames = {'First5','First10','First20'};
TTable = array2table(percentageMatrix,'RowNames',rowNames,'VariableNames',colNames)

%Not all digits are equally easy or difficult to classify, o is the easiest and 8 is the hardiest.
%From the table of the correction, I found that number 8 is most difficult digit to read for the computers.
%It does help to increase the number of singular vectors I used, it changed from 79.518% to 89.759%








