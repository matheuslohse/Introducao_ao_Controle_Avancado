function [ d ] = distdata( t )

global dist

switch dist   
    case 0
        d = 0;
    case 1
        if t >= 60
            d = -0.2;
        else
            d = 0;
        end
    otherwise
        d = 0;
end

end

