function [] = nonmonotonic()

    finesse = 0.05;
    maxupslope = 1.5;
    
    N = 200;
    mu = 1;
    sigma = 1;
    xnoise = 0.2;
    ynoise = 0.02;
  
    %generate random sampling
    realX = abs(randn(N,1)*sigma+mu);
    realY = realX.^2.*exp(-realX.^2);

    %add noise
    X = realX + randn(N,1)*xnoise;
    Y = realY + randn(N,1)*ynoise;
    
    %show data 
    scatter(X,Y,1);
    xlim([0,4]);
    ylim([min(Y),max(Y)]);
    hold on
    pause
    %compare with underlying model
    fplot(@(x)(x.^2.*exp(-x.^2)), '--')

    
    %the model is not monotonic so we bias Y by summing X
    %this requires data to be in pairs...
    Y = Y - maxupslope*X;

    qx = (min(X):finesse:max(X))';
    qy = sbr(X,Y,qx);
    pause
    plot(qx, qy+maxupslope*qx, 'g','LineWidth', 1);
    
    [envHigh, envLow] = envelope(qy+maxupslope*qx,5,'peak');
    fqy = (envHigh+envLow)/2;
    pause
    plot(qx,fqy, 'r','LineWidth', 1);
    pause
    
    close
    
end