function [] = gfr()

    % ======= IMPORT data ============
    % stop warning about names being changed (maybe a bug)
    warning('off','all')
    T = readtable('table1.xlsx');
    warning('on','all')
    n = height(T);
    T.Gender = logical(T.Gender);

    % ====== CALCULATE AVERAGE measured CR & SORT by it =========
    T.Cr = (T.CrE + T.CrIDMS) / 2;
    T = sortrows(T,'Cr');

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


    %set(0,'DefaultFigureColormap',[1:64;zeros(1,64); 64:-1:1]'/64);
    set(0,'DefaultFigureColormap',winter);

    % ====== 1 - PLOT CR vs GFR ======
    figure('position', [80, 80, 600, 720])
    subplot(2,1,1)
    hold on
    plot(NaN,NaN,'ob'); % dummy
    plot(NaN,NaN,'^b'); % dummy
    scatter(T.CrE(~T.Gender), T.mGFR(~T.Gender), [], T.Age(~T.Gender), ...
      'filled', 'o')
    scatter(T.CrE(T.Gender), T.mGFR(T.Gender), [], T.Age(T.Gender), ...
      'filled', '^')
    h = colorbar;
    legend('female','male');
    xlabel('Creatinine measured by Jaffe Method [mg/dL]')
    ylabel('mGFR [mL/min]')
    title(h, 'age')

    subplot(2,1,2)
    hold on
    plot(NaN,NaN,'ob'); % dummy
    plot(NaN,NaN,'^b'); % dummy
    scatter(T.CrE(~T.Gender), T.mGFR(~T.Gender), [], T.Age(~T.Gender), ...
      'filled', 'o')
    scatter(T.CrE(T.Gender), T.mGFR(T.Gender), [], T.Age(T.Gender), ...
      'filled', '^')
    h = colorbar;
    legend('female','male');
    xlabel('Creatinine measured by IDMS Method [mg/dL]')
    ylabel('mGFR [mL/min]')
    title(h, 'age')

    disp('Press any key to continue')
    disp(' ')
    pause
    close

    % ===== 2 - SHOW measurement discrepancies ======
    figure('position', [80, 80, 400, 720])
    subplot(2,1,1)
    scatter(T.CrE, T.CrIDMS)
    xlabel('Creatinine measured by Jaffe Method [mg/dL]')
    ylabel('Creatinine measured by IDMS Method [mg/dL]')
    refline(1,0)
    title('Discrepancy between measurement techniques')

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
    disp(' ')
    pause
    close
    clear h

    % ==== 3 - PLOT AGE vs GFR =====
    figure('position', [80, 80, 400, 400])
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
    xlabel('Age')
    ylabel('mGFR [mL/min]')
    title(h,'Cr')
    disp('By looking at this plotted data GFR does')
    disp('not seem closely related to Age.')
    disp(' ')
    pause
    close

    % ===== 4 - 3D CR vs AGE vs GFR scatter =====
    figure('position', [80, 80, 600, 600])
    plot3(NaN,NaN,NaN,'ob'); % dummy like above
    hold on
    scatter3(T.Cr,T.Age,T.mGFR, 7, [1-T.Gender,zeros(n,1),T.Gender])

    % ===== 5 - MDRD model overlay =====
    % preparo vettori per graficare la legge empiriche nota
    m = 20; % numero di punti per asse per il grafico
    [gridCR, gridAge] = ...
      meshgrid(linspace(min(T.Cr), max(T.Cr),m), ...
        linspace(max(T.Age), min(T.Age),m));
    % eGFR = 186 x CR^(-1.154) x age^(-0.203) x 0.742^(1-gender)
    mdrdM = 186 * gridCR.^-1.154 .* gridAge.^-0.203;
    mdrdF = 186 * gridCR.^-1.154 .* gridAge.^-0.203 * 0.742;

    surf(gridCR, gridAge, mdrdM, cat(3, zeros(m), zeros(m), ones(m)), ...
      'EdgeColor', 'none')
    surf(gridCR, gridAge, mdrdF, cat(3, ones(m), zeros(m), zeros(m)), ...
      'EdgeColor', 'none')
    alpha(0.1)

    legend('male','female','male MDRD Model','female MDRD Model', ...
      'Location','northeast');

    title('GFR')
    xlabel('Creatinine (averaged) [mg/dL]')
    ylabel('Age')
    zlabel('GFR [mL/min]')

    disp('MDRD equation for both males and females seems')
    disp('to be overestimating GFR considerably.')

    pause
    close

    % ===== 6 - compare measurements and estimates =====
    disp(' ')
    disp('showing eGFR from 4 different methods vs mGFR')

    figure('position', [80, 80, 600, 600])
    hold on
    scatter(T.Cr(~T.Gender), T.mGFR(~T.Gender), [], T.Age(~T.Gender), ...
      'filled', 'o')
    scatter(T.Cr(T.Gender), T.mGFR(T.Gender), [], T.Age(T.Gender), ...
      'filled', '^')
    h = colorbar;
    legend('female','male');
    xlabel('Creatinine measured by Jaffe Method [mg/dL]')
    ylabel('mGFR [mL/min]')
    title(h, 'age')

    plot(T.Cr, T.MDRD, 'k:')
    plot(T.Cr, T.CKDEPI, 'k--')
    plot(T.Cr, T.Mayo,'k-.')
    plot(T.Cr, T.Schwartz2009,'k-')

    legend('female','male', 'MDRD', 'CKD-EPI', 'Mayo Quadratic', 'Schwartz2009');
    xlabel('Creatinine concentration [mg/dL]')
    ylabel('GFR [mL/min]')

    pause
    close
end
