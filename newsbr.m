% all arguments must be column vectors
% decresing model hypothesis
function [Qy] = newsbr(Dx,Dy,Qx)

  Px = sum(Dx>=Qx')/length(Dx)*length(Dy);
  Dy = sort(Dy);
  Qy = interp1(Dy, Px);

end
