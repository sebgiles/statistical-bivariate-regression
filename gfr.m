function [] = gfr()

  % ======= IMPORT data ============
  % stop warning about names being changed (maybe a bug)
  warning('off','all')
  T = readtable('table1.xlsx');
  warning('on','all')
  n = height(T);
  T.Gender = logical(T.Gender);

  % ===== Prepare graphics =====
  set(0,'DefaultFigureColormap',winter);

  % ====== PLOT1 - CR vs GFR ======
  figure('position', [80, 80, 600, 720])
  subplot(2,1,1)
  hold on
  plot(NaN,NaN,'ob'); % dummy
  plot(NaN,NaN,'^b'); % dummy
  scatter(T.CrE(~T.Gender), T.mGFR(~T.Gender), [], T.Height(~T.Gender), ...
    'filled', 'o')
  scatter(T.CrE(T.Gender), T.mGFR(T.Gender), [], T.Height(T.Gender), ...
    'filled', '^')
  h = colorbar;
  legend('female','male');
  xlabel('Creatinine measured by Jaffe Method [mg/dL]')
  ylabel('mGFR [mL/min]')
  title(h, 'height [m]')

  subplot(2,1,2)
  hold on
  plot(NaN,NaN,'ob'); % dummy
  plot(NaN,NaN,'^b'); % dummy
  scatter(T.CrIDMS(~T.Gender), T.mGFR(~T.Gender), [], T.Height(~T.Gender), ...
    'filled', 'o')
  scatter(T.CrIDMS(T.Gender), T.mGFR(T.Gender), [], T.Height(T.Gender), ...
    'filled', '^')
  h = colorbar;
  legend('female','male');
  xlabel('Creatinine measured by IDMS Method [mg/dL]')
  ylabel('mGFR [mL/min]')
  title(h, 'height [m]')

  disp('Press any key to continue')
  disp(' ')
  pause
  close

  % ===== PLOT2 - SHOW measurement discrepancies ======
  figure('position', [80, 80, 400, 720])
  subplot(2,1,1)
  scatter(T.CrE, T.CrIDMS)
  xlabel('Creatinine measured by Jaffe Method [mg/dL]')
  ylabel('Creatinine measured by IDMS Method [mg/dL]')
  refline(1,0)
  title('Discrepancy between measurement techniques')

  T.Cr = (T.CrE + T.CrIDMS) / 2;
  T = sortrows(T,'CrIDMS');

  subplot(2,1,2)
  h = histogram( 100*(T.CrIDMS - T.CrE)./T.Cr);
  h.NumBins = 20;
  title('Relative difference distribution')
  xlabel('Relative difference [%]')
  ylabel('count')
  disp('IDMS method yields systematically yet slightly')
  disp('higher values than Jaffe method.')

  disp('Relative difference is calculated as')
  disp('difference divided by average.')
  disp('IDMS will be used from now on.')
  pause
  close
  clear h

  % ==== PLOT3 - AGE vs GFR and HEIGHT vs GFR =====
  figure('position', [80, 80, 900, 400])
  subplot(1,2,1)
  hold on
  plot(NaN,NaN,'ob'); % dummy
  plot(NaN,NaN,'^b'); % dummy
  scatter(T.Age(~T.Gender), T.mGFR(~T.Gender), [], T.CrIDMS(~T.Gender), ...
    'filled', 'o')
  scatter(T.Age(T.Gender), T.mGFR(T.Gender), [], T.CrIDMS(T.Gender), ...
    'filled', '^')
  h = colorbar;
  legend('female','male');
  title('Influence of age on GFR')
  xlabel('Age')
  ylabel('mGFR [mL/min]')
  title(h,'CrIDMS [mg/dL]')

  subplot(1,2,2)
  hold on
  plot(NaN,NaN,'ob'); % dummy
  plot(NaN,NaN,'^b'); % dummy
  scatter(T.Height(~T.Gender), T.mGFR(~T.Gender), [], T.Cr(~T.Gender), ...
    'filled', 'o')
  scatter(T.Height(T.Gender), T.mGFR(T.Gender), [], T.Cr(T.Gender), ...
    'filled', '^')
  h = colorbar;
  legend('female','male');
  title('Influence of height on GFR')
  xlabel('Height [m]')
  ylabel('mGFR [mL/min]')
  title(h,'CrIDMS [mg/dL]')

  disp(' ')
  disp('By looking at this plotted data GFR does')
  disp('not seem strongly dependent on age or height.')
  pause
  close

  % ===== PLOT4 - 3D CRIDMS vs HEIGHT vs GFR scatter =====
  figure('position', [80, 80, 600, 600])
  plot3(NaN,NaN,NaN,'ob'); % dummy like above
  hold on
  scatter3(T.CrIDMS,T.Height,T.mGFR, 7, [1-T.Gender,zeros(n,1),T.Gender])

  % add Schwartz2009 model overlay =====
  m = 20; % numero di punti per asse per il grafico
  [gridCR, gridHeight] = meshgrid(linspace(min(T.CrIDMS), max(T.CrIDMS), m), ...
                                  linspace(min(T.Height), max(T.Height), m)  );

  SchwartzModel = 41.3 * gridHeight ./ gridCR;

  surf(gridCR, gridHeight, SchwartzModel, 'EdgeColor', 'none')
  alpha(0.1)

  legend('male','female','Schwartz2009 Model', 'Location','northeast');

  xlabel('Creatinine [mg/dL]')
  ylabel('Height [m]')
  zlabel('GFR [mL/min]')
  pause
  close

  % ===== 6 - compare measurements and estimates =====
  % ===== CALCULATE MDRD GFR estimation =====
  T.MDRD =  186 * T.CrIDMS.^-1.154  ...
            .* T.Age.^-0.203    ...
            .* (0.742).^(1-T.Gender);

  % ===== CALCULATE CKD-EPI GFR estimation =====
  T.CKDEPI =  141 ...
              * min(T.CrIDMS./(0.7+0.2*T.Age), 1) .^ -(0.329+0.082*T.Gender) ...
              .* max(T.CrIDMS./(0.7+0.2*T.Age), 1) .^ -1.209 ...
              .* 0.993 .^T.Age ...
              .* (1.018-0.018 * T.Gender);

  % ===== CALCULATE Mayo Quadratic GFR estimation =====
  T.Mayo = exp( 1.911                     ...
                +5.249./max(T.CrIDMS, 0.8)    ...
                -2.114./max(T.CrIDMS, 0.8).^2 ...
                -0.00686*T.Age            ...
                -0.205*(1-T.Gender)       );

  % ===== CALCULATE Schwartz2009 GFR estimation =====
  T.Schwartz2009; % is included in dataset (calculated from CrIDMS)

  disp(' ')
  disp('Showing eGFR from 4 different methods vs mGFR.')

  figure('position', [80, 80, 600, 600])
  hold on
  scatter(T.CrIDMS(~T.Gender), T.mGFR(~T.Gender), [], T.Height(~T.Gender), ...
    'filled', 'o')
  scatter(T.CrIDMS(T.Gender), T.mGFR(T.Gender), [], T.Height(T.Gender), ...
    'filled', '^')
  h = colorbar;
  legend('female','male');
  title(h, 'height [m]')

  plot(T.CrIDMS, T.MDRD, 'k:')
  plot(T.CrIDMS, T.CKDEPI, 'k--')
  plot(T.CrIDMS, T.Mayo,'k-.')
  plot(T.CrIDMS, T.Schwartz2009,'k-')

  ylim([0 1.5*max(T.mGFR)]);

  legend('female','male', 'MDRD', 'CKD-EPI', 'Mayo Quadratic', ...
    'Schwartz2009');
  xlabel('Creatinine concentration [mg/dL]')
  ylabel('GFR [mL/min]')

  pause
  close

  % ===== 6 - distributions
  R = 100;
  disp(' ')
  disp('Showing cumulative distribution functions (CDF).')
  disp('Testing inverse CDF.')

  figure('position', [80, 80, 400, 720])
  subplot(2,1,1)
  QCr = linspace(min(T.CrIDMS), max(T.CrIDMS), R)';
  plot(QCr,cdf(T.CrIDMS, QCr));
  title('Creatinine CDF')
  xlabel('Creatinine concentration [mg/dL]')

  disp(' worst relative error for creatinine data: ')
  invQCr = invcdf(T.CrIDMS, cdf(T.CrIDMS, QCr));
  delta = (QCr-invQCr)./QCr;
  err = max(abs(delta));
  disp(err)

  subplot(2,1,2)
  QmGFR = linspace(min(T.mGFR), max(T.mGFR), R)';
  plot(QmGFR,cdf(T.mGFR, QmGFR));
  title('mGFR CDF')
  xlabel('GFR [mL/min]')

  disp(' worst relative error for mGFR data: ')
  invQmGFR = invcdf(T.mGFR, cdf(T.mGFR, QmGFR));
  delta = (QmGFR-invQmGFR)./QmGFR;
  err = max(abs(delta));
  disp(err)

  pause
  close

  % ===== 7 - regression =====
  disp(' ')
  disp('Showing result of statistical bivariate regression.')

  figure('position', [80, 80, 600, 600])
  hold on

  % show datapoints
  scatter(T.CrIDMS(~T.Gender), T.mGFR(~T.Gender), [], T.Height(~T.Gender), ...
    'filled', 'o')
  scatter(T.CrIDMS(T.Gender), T.mGFR(T.Gender), [], T.Height(T.Gender), ...
    'filled', '^')
  h = colorbar;
  legend('female','male');
  xlabel('Creatinine concentration [mg/dL]')
  ylabel('mGFR [mL/min]')
  title(h, 'height [m]')

  % compute curves
  [X,NANS_SBRGFR] = nans_sbr(T.CrIDMS, T.mGFR, R, 'Decreasing');

  SBRGFR = sbr(T.CrIDMS,T.mGFR,X);

  Schwartz2009MH = 41.3*mean(T.Height)./X;

  [xschw, yschw] = rep2avg(T.CrIDMS,T.Schwartz2009);
  Schwartz2009 = interp1(xschw, yschw, X);

  % show curves
  plot(X, Schwartz2009, 'c-', 'LineWidth', 1)
  plot(X, Schwartz2009MH, 'b-','LineWidth',1)
  plot(X, SBRGFR,'-','Color', [1,0.7,0],'LineWidth',1)
  plot(X, NANS_SBRGFR, 'r-', 'LineWidth', 1)

  legend('female','male', 'Schwartz2009', ...
         'Schwartz2009 (mean height)','Binning-less SBR','NANS SBR');

  % calculate stddev
  T.SBRGFR = sbr(T.CrIDMS,T.mGFR,T.CrIDMS);
  T.NANS_SBRGFR = interp1(X, NANS_SBRGFR, T.CrIDMS);
  T.Schwartz2009MH = 41.3*mean(T.Height)./T.CrIDMS;

  SchwartzSD = sqm(T.Schwartz2009, T.mGFR);
  SchwartzMHSD = sqm(T.Schwartz2009MH, T.mGFR);
  SBRSD = sqm(T.SBRGFR, T.mGFR);
  NANS_SBRSD = sqm(T.NANS_SBRGFR, T.mGFR);

  % roughness
  SchwartzR = roughness(Schwartz2009);
  SchwartzMHR = roughness(Schwartz2009MH);
  SBRR = roughness(SBRGFR);
  NANS_SBRR = roughness(NANS_SBRGFR);

  % ui table
  t_data = [SchwartzSD   SchwartzR
            SchwartzMHSD SchwartzMHR
            SBRSD        SBRR
            NANS_SBRSD   NANS_SBRR];

  figure('position', [680, 580, 410, 100])
  t = uitable('Data', t_data, 'InnerPosition', [0,0,600,100]);
  t.ColumnName = {'MSE','R'};
  t.RowName = {'Schwartz2009', 'Schwartz2009 (mean height)', 'Binning-less SBR', 'NANS SBR'};

  pause
  close
  close
end
