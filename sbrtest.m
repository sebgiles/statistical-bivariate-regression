function [] = sbrtest()

    % ======= IMPORT data ============
    % stop warning about names being changed (maybe a bug)
    warning('off','all')
    T = readtable('table1.xlsx');
    warning('on','all')
    n = height(T);
    T.Gender = logical(T.Gender);

    set(0,'DefaultFigureColormap',winter);

    % ====== CALCULATE AVERAGE measured CR & SORT by it =========
    T.Cr = (T.CrE + T.CrIDMS) / 2;
    T = sortrows(T,'Cr');

    disp(' ')
    disp('Showing result of statistical bivariate regression.')

    figure('position', [80, 80, 600, 600])
    hold on
    scatter(T.Cr(~T.Gender), T.mGFR(~T.Gender), [], T.Age(~T.Gender), ...
      'filled', 'o')
    scatter(T.Cr(T.Gender), T.mGFR(T.Gender), [], T.Age(T.Gender), ...
      'filled', '^')
    h = colorbar;
    legend('female','male');
    xlabel('Creatinine concentration [mg/dL]')
    ylabel('mGFR [mL/min]')
    title(h, 'age')

    [X,Y] = sbr(T.Cr,T.mGFR,100000,'Decreasing');
    plot(X,Y,'r-','LineWidth',1)

    newY = newsbr(T.Cr,T.mGFR,X);
    plot(X,newY,'b-','LineWidth',1)

    [X,fY] = stmd(T.Cr,T.mGFR,100000);
    plot(X,fY,'g-','LineWidth',1)


    legend('female','male', 'SBR', 'newSBR','fiori');

    pause
    close

    plot([0:1/100000:1]',invpmf(T.mGFR/180, pmf(T.mGFR/180, [0:1/100000:1]')))
    grid on
    hold on
    plot([0:1/100000:1]',invpmf(T.Cr/2.5, pmf(T.Cr/2.5, [0:1/100000:1]')))
    pause
    close

end
