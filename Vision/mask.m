function [output] = mask(x,y,z)
%returns 2-D grid coordinates based on the coordinates contained in vectors x and y.
[a,b] = meshgrid(x,y);
output = exp(-(a.^2+b.^2)/(2*z^2));  
output = output/sum(output(:));

end

