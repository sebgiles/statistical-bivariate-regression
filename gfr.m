function [] = gfr()
    % stop warning about names being changed (maybe a bug)
    warning('off','all')
    T = readtable('table1.xlsx');
    warning('on','all')

    y = T.mGFR;
    n = length(y);
    cr = (T.CrE + T.CrIDMS) / 2;
    X = [cr T.Age T.Gender];

    figure('position', [80, 80, 400, 720])
    subplot(2,1,1)
    scatter(T.CrE, y, 7, [1-X(:,3),zeros(n,1),X(:,3)])
    hold on
    plot(NaN,NaN,'ob'); % dummy set to add second entry to legend, which by
                        % default does not describe conditional colouring

    legend('female','male');
    xlabel('Creatinine measured by Jaffe Method [mg/dL]')
    ylabel('GFR [mL/min]')

    subplot(2,1,2)
    scatter(T.CrIDMS, y, 7, [1-X(:,3),zeros(n,1),X(:,3)])
    hold on
    plot(NaN,NaN,'ob'); % dummy like above
    legend('female','male');
    xlabel('Creatinine measured by IDMS Method [mg/dL]')
    ylabel('GFR [mL/min]')

    disp('Press any key to continue')
    disp(' ')
    pause
    close

    figure('position', [80, 80, 400, 720])
    subplot(2,1,1)
    scatter(T.CrE, T.CrIDMS)
    xlabel('Creatinine measured by Jaffe Method [mg/dL]')
    ylabel('Creatinine measured by IDMS Method [mg/dL]')
    refline(1,0)
    title('Discrepancy between measurement techniques')

    subplot(2,1,2)
    h = histogram( 100*(T.CrIDMS - T.CrE)./cr);
    h.NumBins = 20;
    title('Relative difference distribution')
    xlabel('Relative difference [%]')
    ylabel('count')
    disp('IDMS method yields systematically yet slightly')
    disp('higher values thsn Jaffe method.')

    disp('Relative difference is calculated as')
    disp('difference divided by average.')
    disp(' ')
    pause
    close
    clear h

    figure('position', [80, 80, 400, 400])
    scatter(X(:,2),y, 7, [1-X(:,3),zeros(n,1),X(:,3)])
    title('Influence of age on GFR')
    xlabel('Age')
    ylabel('GFR [mL/min]')
    hold on
    plot(NaN,NaN,'ob'); % dummy like above
    legend('female','male');
    disp('By looking at this plotted data GFR does')
    disp('not seem closely related to Age.')
    disp(' ')
    pause
    close

    figure('position', [80, 80, 600, 600])
    scatter3(X(:,1),X(:,2),y, 7, [1-X(:,3),zeros(n,1),X(:,3)])
    hold on
    plot(NaN,NaN,'ob'); % dummy like above


    % preparo vettori per graficare la legge empiriche nota
    m = 20; % numero di punti per asse per il grafico
    [gridCR, gridAge] = ...
      meshgrid(linspace(min(cr), max(cr),m), linspace(max(T.Age), min(T.Age),m));
    % eGFR = 186 x CR^(-1.154) x age^(-0.203) x 0.742^(1-gender)
    mdrdM = 186 * gridCR.^-1.154 .* gridAge.^-0.203;
    mdrdF = 186 * gridCR.^-1.154 .* gridAge.^-0.203 * 0.742;

    surf(gridCR, gridAge, mdrdM, cat(3, zeros(m), zeros(m), ones(m)), ...
      'EdgeColor', 'none')
    surf(gridCR, gridAge, mdrdF, cat(3, ones(m), zeros(m), zeros(m)), ...
      'EdgeColor', 'none')
    alpha(0.1)

    legend('female','male','female MDRD Model','male MDRD Model', ...
      'Location','northeast');

    title('GFR')
    xlabel('Creatinine (averaged) [mg/dL]')
    ylabel('Age')
    zlabel('GFR [mL/min]')

    disp('MDRD equation for both males and females seems')
    disp('to be overestimating GFR considerably.')

    pause
    close

end
