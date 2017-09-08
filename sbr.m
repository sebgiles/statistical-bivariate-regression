% Statistical bivariate regression
% Dx and Dy are data sets for independent and dependent variables respectively
% R is interpolation finesse
% M must be spcified as the string 'Increasing' or 'Decreasing' according to
%   expected model monotonicity, which must be inferred from raw plotted data or
%   deduced by reasoning on the nature of the analyzed phenomenon
function [X,Y] = sbr(Dx,Dy,R,M)

  nx = length(Dx);
  ny = length(Dy);

  Bx = ceil(20*log10(nx));
  By = ceil(20*log10(ny));

  [px,x] = hist(Dx, Bx);
  [py,y] = hist(Dy, By);

  px = px'/nx;
  py = (ny*py'+1)/(ny^2+By);
  Px = cumsum(px);
  Py = cumsum(py);
  Px = [0; Px];
  Py = [0; Py];
  x = [min(Dx); x' + (max(Dx)-min(Dx))/(2*Bx)];
  y = [min(Dy); y' + (max(Dy)-min(Dy))/(2*By)];

  X = linspace(min(Dx), max(Dx), R)';
  if strcmp(M, 'Increasing')
    Pxi = interp1(x,Px,X);
  else
    if strcmp(M, 'Decreasing')
      Pxi = interp1(x,1-Px,X);
    else
      disp('Specify ''Increasing'' or ''Decreasing'' as 4th argument')
      return
    end
  end

  Y = interp1(Py,y,Pxi);
end
