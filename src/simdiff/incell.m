function [bool,c] = incell(coor,length,width)
% [bool,c] = incell(coor,length,width)
% decides whether 3D coordinates are within a cell or not.
% The cell is assumed to be centered at the origin, and its 
% geometry defined by a cylinder of radius width/2 and height
% length - width, plust two semi-spheres are each tip of radius 
% width/2.
% This gives the following equations for the volume of the cell
% 1) Semi-sphere negative side
%    r^2 >= (x+d)^2 + y^2 + z^2 // x in [-d-r,-d]
% 2) Cylinder
%    r^2 >= y^2 + z^2           // x in [-d,d]
% 3) Semi-sphere positive side
%    r^2 >= (x-d)^2 + y^2 + z^2 // x in [d,d+r]
% where r = width/2 and d = length/2 - width/2;
%
% INPUT:
% coor    := 3D coordinates (long axis, width, height)
% length  := length of cell (long axis)
% width   := diameter of the cell
%
% OUTPUT:
% bool    := 0 when is outside the cell, 1 when is inside
% c       := 1 when x in [-d,d], 2 when abs(x) in [d,d+r],
%            3 when abs(x) in [d+r,inf]
%
% Sebastian Jaramillo-Riveri
% November, 2018
    
    % Long axis of the cylinder
        d = length/2 - width/2;
    % Radius
    r = width/2;
    
    nrows = size(coor,1);
    
    bool = zeros(nrows,1);
    c    = 0;
    mindelta = 5e-6;
    for n = 1:nrows
        
        x = coor(n,1); % long axis 
        y = coor(n,2); % width
        z = coor(n,3); % height
        
        if(((abs(x) - d >= -mindelta) || (abs(x) - d <= mindelta)) && ((y^2 + z^2) - r^2 > mindelta))
            % First test is the condition for the long axis within
            % the cylinder
            c = 1;
            bool(n) = 0;
        elseif((abs(x) - d > mindelta) && (((abs(x)-d)^2 + y^2 + z^2) - r^2 > mindelta))
            % Second test is for long axis outside of the cylinder 
            % (semi spheres)
            c = 2;
            bool(n) = 0;
        elseif((abs(x) - (d+r) > mindelta))
            c = 3;
            bool(n) = 0;
        else
            bool(n) = 1;
        end
    end

end