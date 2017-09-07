function I = interp(x,y,D)
  n = length(D);
  [~,U] = histc(D,x(1:end));
  I = zeros(n,1);
  for k = 1:n
    if U(k)==0
      break
    end
    if U(k) == length(x)
      I(k) == y(length(x));
    else
      t = ( D(k) - x(U(k)) ) / ( x( U(k)+1 ) - x(U(k)) );
      I(k) = (1-t)*y(U(k))+t*y(U(k)+1);
    end
  end
end
