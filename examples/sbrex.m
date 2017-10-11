function [] = sbrex()
    X = randn(10000,1)*5;
    Y = (randn(10000,1)*5);
    Y=sin(Y)+Y;
    q = (-10:0.1:30)';
    plot(q,-q+invcdf(Y,cdf(X,q)));
    
end