% evaluate probability mass fuction inferred from D for values x
function P = pmf(D,x)
  D = sort(D);
  nd = length(D);
  nx = length(x);
  L = zeros(nx, 1);
  R = zeros(nx, 1);

  % for each query
  for k = 1:nx
    % binary search for query's "neighbours"
    l = 1;
    r = nd;
    while r - l > 1
      m = floor((l+r)/2);
      if D(m) > x(k)
        r = m;
      else
        l = m;
      end
    end

    % reach last occurrence of right neighbour
    while r < nd & D(r)==D(r+1)
      r = r + 1;
    end

    L(k) = l;
    R(k) = r;
  end

  % vectorized interpolation
  d = (x-D(L))./(D(R)-D(L));
  P = (L + (R - L).*d)/nd;

  % trim out of range interpolations
  P = P .* (P > 0); % if p<0 then p=0
  P = P - (P - 1).*(P > 1); %if p>1 then p=1

end
