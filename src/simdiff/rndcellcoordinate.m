function [coordinates] = rndcellcoordinate(ncoor,length,width)
% [coordinates] = RNDCELLCOORDINATE(ncoor,length,width)
% Gets uniformly random coordinates in 3D within a cell defined
% by length and width inputs. 
% The cell is assumed to be centered at the origin, and its 
% geometry defined by a cylinder of radius width/2 and height
% length - width, plus two semi-spheres of radius width/2 
% at each cell tip.
%
% INPUT:
% ncoor   := number of coordinates
% length  := length of cell (long axis)
% width   := diameter of the cell
%
% OUTPUT:
% coordinates := ncoor by 3 matrix, with uniformly random 3D 
%                coordinates within the defined cell 
% 
% Sebastian Jaramillo-Riveri
% November, 2018

    coordinates = zeros(ncoor,3);

    % Long axis of the cylinder
    d = length/2 - width/2;
    % Radius
    r = width/2;
    
    % divide volume in 3 sub-compartments
    volumes    = zeros(3,1);
    volumes(1) = (2/3)*pi*r^3; % semi-sphere
    volumes(2) = pi*d*r^2;     % cylinder
    volumes(3) = (2/3)*pi*r^3; % semi-sphere
    cvolumes   = cumsum(volumes)./sum(volumes); % [0,1]
    
    % randomly choose coordinates
    for n = 1:ncoor
        coor = [0,0,0];
        % Randomly pick sub-volume (proportional to its size)
        rvol = rand();
        if(rvol<cvolumes(1))
            % left semi-sphere
            % center is [-d,0,0]
            % r^2 >= x^2 + y^2 + z^2 // x in [-r,0], y and z in [-r,r]
            vang1 = pi*rand();       % [0,pi]        (phi)
            vang2 = pi*rand()+pi/2;  % [pi/2,2*pi/3] (theta)
            vlen  = r*rand();        % [0,r]
            coor  = [-d+vlen*sin(vang1)*cos(vang2),vlen*sin(vang1)*sin(vang2),vlen*cos(vang1)];
        elseif(rvol<cvolumes(2))
            % cylinder            
            % center is [0,0,0]
            % r^2 >= y^2 + z^2       // x in [-d,d], y and z in [-r,r]
            vang = 2*pi*rand();      % [0,2*pi]
            vlen = r*rand();         % [0,r]
            x    = d*2*(rand()-0.5); % [-d,d]
            coor = [x,vlen*cos(vang),vlen*sin(vang)];
        else
            % right semi-sphere
            % center is [d,0,0]
            % r^2 >= x^2 + y^2 + z^2   // x in [0,r], y and z in [-r,r]
            vang1 = pi*rand();         % [0,pi]        (phi)
            vang2 = -1*pi*rand()+pi/2; % [pi/2,2*pi/3] (theta)
            vlen  = r*rand();          % [0,r]
            coor  = [d+vlen*sin(vang1)*cos(vang2),vlen*sin(vang1)*sin(vang2),vlen*cos(vang1)];
        end
        if(incell(coor,length,width)==0)
            error('Random coordinates are not within the cell!');
        end
        coordinates(n,:) = coor;
    end
    
end