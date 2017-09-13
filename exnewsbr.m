% decresing model hypothesis
function [Qy] = exnewsbr(Dx,Dy,Qx)
  P = sum(Dx>=Qx')/length(Dx)';
  Dy = sort(Dy);
  Qy = interp1(Dy, P*length(Dy));

end
