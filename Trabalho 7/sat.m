function [y] = sat(x)

if abs(x) >= 1
    y = sign(x);
    
else
    y = x;

end

end

