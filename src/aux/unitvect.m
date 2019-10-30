function [nv,c] = unitvect(v)
% [nv,c] = unitvect(v)
% normalises 3D vector by its distance to the origin
% returning a vector of unit distance
%
% INPUT:
% v := 3D vector 
%
% OUTPUT:
% nv := normalised vector of unit 1
% c  := distance to the origin of input vector
%
% Sebastian Jaramillo-Riveri
% November, 2018
c = sqrt(v(1)^2+v(2)^2+v(3)^2);

nv = v./c;

end