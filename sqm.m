function s = sqm(y, y0)
  delta = y - y0;
  s = delta'*delta/length(y);
end
