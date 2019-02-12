function VAF = vaf(yhat, y)
    S_e = var(y-yhat);
    S = var(y);
    VAF = 1 - S_e/S;    