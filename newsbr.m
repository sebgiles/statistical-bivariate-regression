% all arguments must be column vectors
% decresing model hypothesis
function [Qy] = newsbr(Dx,Dy,Qx)

  P = 1 - pmf(Dx,Qx); % = pmf(Dx,Qx) % for increasing model
  Qy = invpmf(Dy, P);

end
