function [l] = vlength(v)
% [l] = vlength(v)
%
% computes the distance to the origin of vector v
% assumed to be 3 dimensional
%
% Sebastian Jaramillo-Riveri
% November, 2018
l = sqrt(v(1).^2+v(2).^2+v(3).^2);

end