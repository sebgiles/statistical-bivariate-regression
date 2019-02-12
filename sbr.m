% all arguments must be column vectors
% decresing model hypothesis
function [Qy] = sbr(Dx,Dy,Qx, monotonicity)
  if nargin < 4
    monotonicity = "Decreasing";
  end

  if monotonicity == "Increasing"
    P = cdf(Dx,Qx);
  elseif monotonicity == "Decreasing"
    P = 1 - cdf(Dx,Qx);
  else
    disp Invalid fourth argument
    return
  end
  Qy = invcdf(Dy, P);

end
