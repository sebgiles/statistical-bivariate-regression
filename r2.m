function out = r2(y,y0)
    out = corrcoef(y,y0);
    out = out(1,2);
end