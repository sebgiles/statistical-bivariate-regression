function R = relroughness(y)

    R = sum((diff(diff(y))./y(2:end-1).^2/(length(y)-2)));
end
