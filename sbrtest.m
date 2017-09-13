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

  R = 100000;

  [X,Y] = sbr(T.Cr,T.mGFR,R,'Decreasing');
  plot(X,Y,'r-','LineWidth',1)

  newY = newsbr(T.Cr,T.mGFR,X);
  plot(X,newY,'b-','LineWidth',1)

  exnewY = exnewsbr(T.Cr,T.mGFR,X);
  plot(X,exnewY,'g-','LineWidth',1)

  legend('female','male', 'nans', 'newSBR','exnewsbr');

  pause
  close

  disp(' ')
  disp('testing invpmf(pmf(x)) = x for creatinine data')
  disp('worst relative error: ')
  XX = invcdf(T.Cr, cdf(T.Cr, X));
  plot(X, XX)
  delta = (X-XX)./X;
  SQM = max(abs(delta));
  disp(SQM)
  grid on
  pause
  close

  disp(' ')
  disp('testing invpmf(pmf(x)) = x for mGFR data')
  disp('worst relative error: ')
  X = linspace(min(T.mGFR), max(T.mGFR), R)';
  XX = invcdf(T.mGFR, cdf(T.mGFR, X));
  delta = (X-XX)./X;
  SQM = max(abs(delta));
  disp(SQM)
  grid on
  pause
  close

end
