xrange = [5,95];
ntrain = 2000;
ntest = 200;
[Train, Test, f] = makeartificialdata(ntrain,ntest,xrange);    

fplot(f,xrange);
hold on
set(gcf, 'Position',  [0, 0, 1000, 1000])

scatter(Test.Dx, Test.Dy,'.');
scatter(Train.Dx, Train.Dy,'.');

Test.y_sbr = sbr(Train.Dx,Train.Dy,Test.Dx,"Increasing");
plot(Test.Dx, Test.y_sbr);

Grid = table();
[Grid.x, Grid.y_nans] = nans_sbr(Train.Dx,Train.Dy,100,"Increasing");
plot(Grid.x, Grid.y_nans);

svm = fitrsvm(  Train.Dx, Train.Dy,          ... 
                'KernelFunction','gaussian'  ...            
                                                );
%                 'Standardize',true,             ...
%                 'KernelScale','auto',           ...
%                 'KernelFunction','polynomial',  ...

Test.y_svr = predict(svm, Test.Dx);
plot(Test.Dx, Test.y_svr);

hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize,'trainlm');
net.divideParam.trainRatio = 90/100;
net.divideParam.valRatio = 10/100;
net.divideParam.testRatio = 0/100;
net.trainParam.showWindow = false;
net= train(net,Train.Dx',Train.Dy');
Test.y_ann = net(Test.Dx')';
plot(Test.Dx, Test.y_ann);

tree = fitrsvm(  Train.Dx, Train.Dy );

Test.y_rt = predict(svm, Test.Dx);
plot(Test.Dx, Test.y_rt);

%Test.y_rt = ;
legend('generator', 'traindata', 'testdata', 'sbr', 'nans', 'svr', 'nn', 'rt');
pause
close