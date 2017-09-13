% evaluate inverse cumulative distribution fuction inferred from D for
% probabilities P. (D must contain at least two different values.)
function x = invcdf(D, P)
  nd = length(D);
  D = sort(D);
  np = length(P);
  P = P*nd;       % float in [0,nd]
  R = ceil(P);    % int in [0, nd]
  R = R + (R==0); % int in [1, nd], points in [0,1) are interpolated externally
  L = zeros(np,1);

  % for each query
  for k = 1:np
    r = R(k);
    l = r;

    % find last occurrence of pointed element
    while r < nd & D(r) == D(r+1)
      r = r + 1;
    end

    % find first occurrence of pointed element
    while l > 1 & D(l - 1) == D(l)
      l = l - 1;
    end

    if l == 1
      % find last occurrence of following element
      l = r;
      r = r + 1;
      while r < nd & D(r) == D(r+1)
        r = r + 1;
      end
    else
      % find last occurrence of previous element
      l = l - 1;
    end

    R(k) = r;
    L(k) = l;
  end

  % vectorized interpolation
  d = (P-L)./(R-L);
  x = (D(L) + (D(R) - D(L)).*d);

end
