function [Train, Test, f] = makeartificialdata(ntrain,ntest,xrange)
    P = [   90    90
            50    50
            20    40
            10     5
            70    55
            85    70];


    poly = polyfit(P(:,1),P(:,2),5);
    f = poly2sym(poly);

    trainnoisex = 0;
    trainnoisey = 2;

    Train = table();
    Train.perfx = randnconstrained(ntrain,1,xrange);
    Train.perfy = polyval(poly, Train.perfx);

    Train.x = Train.perfx + randn(ntrain,1)*trainnoisex;
    Train.y_m = Train.perfy + randn(ntrain,1)*trainnoisey;

    Train = sortrows(Train,'x');

    testnoisex = 0;
    testnoisey = 2;
    
    Test = table();
    Test.perfx = randnconstrained(ntest,1,xrange);
    Test.perfy = polyval(poly, Test.perfx);

    Test.x = Test.perfx + randn(ntest,1)*testnoisex;
    Test.y_m = Test.perfy + randn(ntest,1)*testnoisey;
    
    Test = sortrows(Test,'x');
end