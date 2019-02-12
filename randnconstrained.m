function out = randnconstrained(h, w, limits, var)
    if nargin < 4
        var = range(limits)/2;
    end
    offset = mean(limits);
    out = (randn(h,w))*var + offset;
    
    for r=1:h
        for c=1:w
            while out(r,c) < limits(1) || out(r,c) > limits(2)
                out(r,c) = randn*var + offset;
            end
        end
    end
    out = sort(out);           
end