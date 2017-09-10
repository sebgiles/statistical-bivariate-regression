% all arguments must be column vectors
% decresing model hypothesis
function [Qy] = newsbr(Dx,Dy,Qx)

  P = sum(Dx>=Qx')/length(Dx)';
  Dy = sort(Dy);
  Qy = interp1(Dy, P*length(Dy));

end
