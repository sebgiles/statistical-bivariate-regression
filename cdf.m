% evaluate cumulative distribution function inferred from D for values q
function P = cdf(D,q)
  D = sort(D);
  nd = length(D);
  nq = length(q);
  L = zeros(nq, 1);
  R = zeros(nq, 1);

  % for each query
  for k = 1:nq
    % binary search for query's "neighbours"
    l = 1;
    r = nd;
    while r - l > 1
      m = floor((l+r)/2);
      if D(m) > q(k) && D(m) ~= D(l)
        r = m;
      else
        l = m;
      end
    end

    while D(r) == D(l)
      l = l - 1;
    end

    % reach last occurrence of right neighbour
    while r < nd && D(r) == D(r+1)
      r = r + 1;
    end
    L(k) = l;
    R(k) = r;
  end
  % vectorized interpolation
  d = (q-D(L))./(D(R)-D(L));
  P = (L + (R - L).*d)/nd;

  % trim out of range interpolations
  P = P .* (P > 0); % if p<0 then p=0
  P = P - (P - 1).*(P > 1); %if p>1 then p=1

end
