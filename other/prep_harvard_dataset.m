T = readtable('table2.xlsx');
T = T(T.equation == 0, :);
T2 = table();
T2.Gender = mod(T.sexe, 2);
T2.Age = T.age;
T2.Height = T.heightm;
T2.mGFR = T.inuline;
T2.CrIDMS = T.cretmg;
T2.CrE = zeros(height(T2),1);
T2.Schwartz2009 = (41.3*T2.Height)./T2.CrIDMS;
disp('writing to file')
%writetable(T2, 'table3.csv');
