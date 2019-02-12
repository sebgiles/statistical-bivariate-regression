function [] = gfr(T)

  % ======= IMPORT data ============
  % stop warning about names being changed (maybe a bug)
  warning('off','all')
  %T = readtable(filename);
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
  ylabel('mGFR [mL/min/1.73m^2]')
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
  ylabel('mGFR [mL/min/1.73m^2]')
  title(h, 'height [m]')

  disp('Press any key to continue')
  disp(' ')
  %pause
  close

  % ===== PLOT2 - SHOW measurement discrepancies ======
  figure('position', [80, 80, 400, 720])
  subplot(2,1,1)
  scatter(T.CrE, T.CrIDMS)
  xlabel('Creatinine measured by Jaffe Method [mg/dL]')
  ylabel('Creatinine measured by IDMS Method [mg/dL]')
  refline(1,0)
  title('Discrepancy between measurement techniques')

  T.CrM = (T.CrE + T.CrIDMS) / 2;

  T = sortrows(T,'CrIDMS');

  subplot(2,1,2)
  h = histogram( 100*(T.CrIDMS - T.CrE)./T.CrM);
  h.NumBins = 20;
  title('Relative difference distribution')
  xlabel('Relative difference [%]')
  ylabel('count')
  disp('IDMS method yields systematically yet slightly')
  disp('higher values than Jaffe method.')

  disp('Relative difference is calculated as')
  disp('difference divided by average.')
  disp('IDMS will be used from now on.')
  %pause
  close
  clear h

  T.Cr = T.CrIDMS;

  % ==== PLOT3 - AGE vs GFR and HEIGHT vs GFR =====
  figure('position', [80, 80, 900, 400])
  subplot(1,2,1)
  hold on
  plot(NaN,NaN,'ob'); % dummy
  plot(NaN,NaN,'^b'); % dummy
  scatter(T.Age(~T.Gender), T.mGFR(~T.Gender), [], T.Cr(~T.Gender), ...
    'filled', 'o')
  scatter(T.Age(T.Gender), T.mGFR(T.Gender), [], T.Cr(T.Gender), ...
    'filled', '^')
  h = colorbar;
  legend('female','male');
  title('Influence of age on GFR')
  xlabel('Age [years]')
  ylabel('Measured GFR [mL/min/1.73m^2]')
  title(h,'sCr [mg/dL]')

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
  ylabel('Measured GFR [mL/min/1.73m^2]')
  title(h,'sCr [mg/dL]')

  disp(' ')
  disp('By looking at this plotted data GFR does')
  disp('not seem strongly dependent on age or height.')
  %pause
  close

  % ===== PLOT4 - 3D CRIDMS vs HEIGHT vs GFR scatter =====
  figure('position', [80, 80, 600, 600])
  plot3(NaN,NaN,NaN,'ob'); % dummy like above
  hold on
  scatter3(T.Cr,T.Height,T.mGFR, 7, [1-T.Gender,zeros(n,1),T.Gender])

  % add Schwartz2009 model overlay =====
  m = 20; % numero di punti per asse per il grafico
  [meshCr, meshHeight] = meshgrid(linspace(min(T.Cr), max(T.Cr), m), ...
                                  linspace(min(T.Height), max(T.Height), m)  );

  SchwartzModel = 41.3 * meshHeight ./ meshCr;

  surf(meshCr, meshHeight, SchwartzModel, 'EdgeColor', 'none')
  alpha(0.1)

  legend('male','female','Schwartz2009 Model', 'Location','northeast');

  xlabel('Creatinine [mg/dL]')
  ylabel('Height [m]')
  zlabel('GFR [mL/min/1.73m^2]')
  %pause
  close

  % ===== 6 - compare measurements and estimates =====
  % ===== CALCULATE MDRD GFR estimation =====
  T.MDRD =  186 * T.Cr.^-1.154  ...
            .* T.Age.^-0.203    ...
            .* (0.742).^(1-T.Gender);

  % ===== CALCULATE CKD-EPI GFR estimation =====
  T.CKDEPI =  141 ...
              * min(T.Cr./(0.7+0.2*T.Age), 1) .^ -(0.329+0.082*T.Gender) ...
              .* max(T.Cr./(0.7+0.2*T.Age), 1) .^ -1.209 ...
              .* 0.993 .^T.Age ...
              .* (1.018-0.018 * T.Gender);

  % ===== CALCULATE Mayo Quadratic GFR estimation =====
  T.Mayo = exp( 1.911                     ...
                +5.249./max(T.Cr, 0.8)    ...
                -2.114./max(T.Cr, 0.8).^2 ...
                -0.00686*T.Age            ...
                -0.205*(1-T.Gender)       );

  % ===== CALCULATE Schwartz2009 GFR estimation =====
  T.Schwartz2009; % is included in dataset (calculated from CrIDMS)

  disp(' ')
  disp('Showing eGFR from 4 different methods vs mGFR.')

  figure('position', [80, 80, 600, 600])
  hold on
  scatter(T.Cr(~T.Gender), T.mGFR(~T.Gender), [], T.Height(~T.Gender), ...
    'filled', 'o')
  scatter(T.Cr(T.Gender), T.mGFR(T.Gender), [], T.Height(T.Gender), ...
    'filled', '^')
  h = colorbar;
  legend('female','male');
  title(h, 'height [m]')

  plot(T.Cr, T.MDRD, 'k:')
  plot(T.Cr, T.CKDEPI, 'k--')
  plot(T.Cr, T.Mayo,'k-.')
  plot(T.Cr, T.Schwartz2009,'k-')

  ylim([min(T.mGFR) 1.1*max(T.mGFR)]);

  legend('female','male', 'MDRD', 'CKD-EPI', 'Mayo Quadratic', ...
    'Schwartz2009');
  xlabel('Measured serum creatinine concentration (sCr) [mg/dL]')
  ylabel('Measured and estimated GFR [mL/min/1.73m^2]')

  %pause
  close

  % ===== 6 - distributions
  R = 100;
  disp(' ')
  disp('Showing cumulative distribution functions (CDF).')
  disp('Testing inverse CDF.')

  figure('position', [80, 80, 400, 720])
  subplot(2,1,1)
  QCr = linspace(min(T.Cr), max(T.Cr), R)';
  plot(QCr,cdf(T.Cr, QCr));
  title('Creatinine CDF')
  xlabel('Creatinine concentration [mg/dL]')

  disp(' worst relative error for creatinine data: ')
  invQCr = invcdf(T.Cr, cdf(T.Cr, QCr));
  delta = (QCr-invQCr)./QCr;
  err = max(abs(delta));
  disp(err)

  subplot(2,1,2)
  QmGFR = linspace(min(T.mGFR), max(T.mGFR), R)';
  plot(QmGFR,cdf(T.mGFR, QmGFR));
  title('mGFR CDF')
  xlabel('GFR [mL/min/1.73m^2]')

  disp(' worst relative error for mGFR data: ')
  invQmGFR = invcdf(T.mGFR, cdf(T.mGFR, QmGFR));
  delta = (QmGFR-invQmGFR)./QmGFR;
  err = max(abs(delta));
  disp(err)

  %pause
  close

  % ===== 7 - regression =====

  % set aside a test set
  [Train, Test] = splitdata(T, 0.9);

  disp(' ')
  disp('Showing result of statistical bivariate regression.')

  figure('position', [80, 80, 600, 600])
  hold on

  % show Test set datapoints
  scatter(Test.Cr(~Test.Gender), Test.mGFR(~Test.Gender), [], ...
      Test.Height(~Test.Gender), 'filled', 'o')
  scatter(Test.Cr(Test.Gender), Test.mGFR(Test.Gender), [], ...
      Test.Height(Test.Gender),  'filled', '^')
  h = colorbar;
  legend('female','male');
  xlabel('Serum creatinine concentration (sCr) [mg/dL]')
  ylabel('Measured and estimated GFR [mL/min/1.73m^2]')
  title(h, 'height [m]')

  Grid = table();

  % get models
  [Grid.Cr, Grid.NANS_GFR] = nans_sbr(Train.Cr, Train.mGFR, R, 'Decreasing');
  Grid.SBR_GFR = sbr(Train.Cr, Train.mGFR, Grid.Cr);
  Grid.Schw09MH = 41.3*mean(Train.Height)./Grid.Cr;

  %rep2avg smooths my lines too much if there are many reps, so i use derep
  %[xschw, yschw] = rep2avg(T.Cr,T.Schwartz2009);
  %[xschw, yschw] = derep(T.Cr,Test.Schwartz2009);
  %Schwartz2009 = interp1(xschw, yschw, GridCr);

  % show curves
  plot(Test.Cr, Test.Schwartz2009, 'k:', 'LineWidth', 0.8)
  plot(Grid.Cr, Grid.Schw09MH, 'k-.','LineWidth',0.6)
  plot(Grid.Cr, Grid.SBR_GFR,'k-','LineWidth',0.6)
  plot(Grid.Cr, Grid.NANS_GFR, 'k--', 'LineWidth', 0.6)
  ylim([0.9*min(Test.mGFR) 1.1*max(Test.mGFR)]);
  legend('female','male', 'Schwartz2009', ...
         'Schwartz2009 (mean height)','Binning-less SBR','NANS SBR');

  % apply models to testset
  Test.SBR_GFR = sbr(Train.Cr, Train.mGFR, Test.Cr);
  % above is to be compared with following:
  %    Test.SBR_INTERP_GFR = interp1(Grid.Cr, Grid.SBR_GFR, Test.Cr);
  Test.NANS_GFR = interp1(Grid.Cr, Grid.NANS_GFR, Test.Cr,'linear', 'extrap');
  Test.Schw09MH = 41.3*mean(Train.Height)./Test.Cr;

  % calculate stddev
  Schwartz_SD = sqm(Test.Schwartz2009, Test.mGFR);
  SchwMH_SD = sqm(Test.Schw09MH, Test.mGFR);
  SBR_SD = sqm(Test.SBR_GFR, Test.mGFR);
  NANS_SD = sqm(Test.NANS_GFR, Test.mGFR);

  trim = 1;

  % roughness
  %SchwartzR = roughness(Schwartz2009(trim:end-trim)); % does not apply
  SchwartzR = NaN;
  SchwMH_R = roughness(Grid.Schw09MH(1+trim:end-trim));
  SBR_R = roughness(Grid.SBR_GFR(1+trim:end-trim));
  NANS_R = roughness(Grid.NANS_GFR(1+trim:end-trim));

  %relativeroughness
  SchwartzRR = NaN;
  SchwMH_RR = relroughness(Grid.Schw09MH(1+trim:end-trim));
  SBR_RR = relroughness(Grid.SBR_GFR(1+trim:end-trim));
  NANS_RR = relroughness(Grid.NANS_GFR(1+trim:end-trim));

  % MAE
  Schwartz_MAE = mae(Test.Schwartz2009, Test.mGFR);
  SchwMH_MAE = mae(Test.Schw09MH, Test.mGFR);
  SBR_MAE = mae(Test.SBR_GFR, Test.mGFR);
  NANS_MAE = mae(Test.NANS_GFR, Test.mGFR);

  % VAF
  Schwartz_VAF = vaf(Test.Schwartz2009, Test.mGFR);
  SchwMH_VAF   = vaf(Test.Schw09MH, Test.mGFR);
  SBR_VAF      = vaf(Test.SBR_GFR, Test.mGFR);
  NANS_VAF     = vaf(Test.NANS_GFR, Test.mGFR);

  % R-Squared
  Schwartz_R2 = corrcoef(Test.Schwartz2009, Test.mGFR);
  SchwMH_R2   = corrcoef(Test.Schw09MH, Test.mGFR);
  SBR_R2      = corrcoef(Test.SBR_GFR, Test.mGFR);
  NANS_R2     = corrcoef(Test.NANS_GFR, Test.mGFR);

  % ui table
  t_data = [
    SchwartzR SchwartzRR Schwartz_SD Schwartz_MAE Schwartz_R2(1,2) Schwartz_VAF
    SchwMH_R  SchwMH_RR  SchwMH_SD   SchwMH_MAE   SchwMH_R2(1,2)   SchwMH_VAF
    NANS_R    SBR_RR     NANS_SD     NANS_MAE     NANS_R2(1,2)     NANS_VAF
    SBR_R     NANS_RR    SBR_SD      SBR_MAE      SBR_R2(1,2)      SBR_VAF
    ];

  figure('position', [680, 580, 720, 100])
  t = uitable('Data', t_data, 'InnerPosition', [0,0,800,100]);
  t.ColumnName = {'G', 'G_R','MSE','MAE','R^2','VAF'};
  t.RowName = {'Schwartz2009', 'Schwartz2009 (mean height)', 'NANS SBR', 'Binning-less SBR'};

  pause
  close
  close
end
