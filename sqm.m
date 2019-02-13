function s = sqm(y, y0)
  delta = y - y0;
  s = sqrt(delta'*delta/length(y));
end
