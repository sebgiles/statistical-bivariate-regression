function [] = timing(R)

  warning('off','all')
  T = readtable('table1.xlsx');
  warning('on','all')

  disp('NANS:')

  tic
  for i=1:1000
    [X,NANS_SBRGFR] = stmd(T.CrIDMS, T.mGFR, R);
  end
  toc

  disp(' ')
  disp('Binningless:')

  tic
  for i=1:1000
    SBRGFR = sbr(T.CrIDMS,T.mGFR,X);
  end
  toc

  disp(' ')
end
