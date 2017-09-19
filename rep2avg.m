% remove repetitions in x, average corresponding elements in y
% x and y must be the same size
function [x,y] = rep2avg(x,y)
  reps = 1;
  k = 2;
  while k <= length(x)
    if x(k) == x(k-1)
      x(k) = [];
      y(k-1) = y(k-1) + y(k);
      y(k) = [];
      reps = reps + 1;
      k = k - 1;
    else
      y(k-1) = y(k-1) / reps;
      reps = 1;
    end
    k = k + 1;
  end
  y(end) = y(end) / reps;
end
