% remove repetitions in x, keep y of first occurrence
% x and y must be the same size
function [x,y] = derep(x,y)
  %reps = 1;
  k = 2;
  while k <= length(x)
    if x(k) == x(k-1)
      x(k) = [];
      y(k) = [];
      k = k - 1;
    end
    k = k + 1;
  end
end
