function R = roughness(y)
  %R = sqrt(sum(diff(atan(diff(y))).^2)/(length(y)-2));
  R = sqrt(sum(diff(diff(y)).^2)/(length(y)-2));
  %R = sqrt(sum(diff(y).^2)/ (length(y)-1));
end
