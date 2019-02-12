function [Train, Test, f] = makeartificialdata(ntrain,ntest,xrange)
    P = [   90    90
            50    50
            20    40
            10     5
            70    55
            85    70];


    poly = polyfit(P(:,1),P(:,2),5);
    f = poly2sym(poly);

    noisex = 0;
    noisey = 10;

    Train = table();
    Train.perfx = randnconstrained(ntrain,1,xrange);
    Train.perfy = polyval(poly, Train.perfx);

    Train.Dx = Train.perfx + randn(ntrain,1)*noisex;
    Train.Dy = Train.perfy + randn(ntrain,1)*noisey;

    Test = table();
    Test.perfx = randnconstrained(ntest,1,xrange);
    Test.perfy = polyval(poly, Test.perfx);

    Test.Dx = Test.perfx + randn(ntest,1)*noisex;
    Test.Dy = Test.perfy + randn(ntest,1)*noisey;
end