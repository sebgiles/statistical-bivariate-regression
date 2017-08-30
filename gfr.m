function [] = gfr()
    T = readtable('table1.xlsx');
    y = T.mGFR;
    n = length(y);
    cr = (T.CrE + T.CrIDMS) / 2;
    X = [cr T.Age T.Gender];

    figure('position', [80, 80, 400, 720])
    subplot(2,1,1)
    scatter(T.CrE, y, 7, [1-X(:,3),zeros(n,1),X(:,3)])
    title('GFR vs Creatinine measured using Jaffe Method')
    subplot(2,1,2)
    scatter(T.CrIDMS, y, 7, [1-X(:,3),zeros(n,1),X(:,3)])
    title('GFR vs Creatinine measured using IDMS Method')

    disp('GFR in funzione della concentrazione di siero-creatinina')
    disp('(CR) misurata con due metodi distinti.')
    disp('INVIO per continuare')
    disp(' ')
    pause
    close

    figure('position', [80, 80, 400, 720])
    subplot(2,1,1)
    scatter(T.CrE, T.CrIDMS)
    refline(1,0)
    title('Jaffe vs IDMS')

    subplot(2,1,2)
    h = histogram( (T.CrE - T.CrIDMS)./cr);
    h.NumBins = 20;
    title('Differenza relativa tra i due metodi')

    disp('Il metodo IDMS restituisce valori leggermente superiori.')
    disp('In basso la distribuzione dell''errore relativo nella')
    disp('misura di CR.')
    disp('(differenza tra i due metodi diviso la media)')
    disp(' ')
    pause
    close
    clear h

    figure('position', [80, 80, 400, 400])
    scatter(X(:,2),y, 7, [1-X(:,3),zeros(n,1),X(:,3)])
    title('età vs gfr')
    disp('x = età')
    disp('y = GFR')
    disp('Maschi in blu, femmine in rosso.')
    disp(' ')
    pause
    close

    figure('position', [80, 80, 600, 600])
    scatter3(X(:,1),X(:,2),y, 7, [1-X(:,3),zeros(n,1),X(:,3)])
    title('GFR')
    disp('x = CR (media dei due metodi)')
    disp('y = età')
    disp('z = GFR')
    disp('Maschi in blu, femmine in rosso.')
    pause
    close
    clear T y n cr X
end
