function [bool,inter,normal] = cellintersect(step,length,width)
% [bool,inter,normal] = cellintersect(step,length,width)
% find the intersection along the trajectory step(1,:) to step(2,:)
% and the cell surface 
%
% The cell is assumed to be centered at the origin, and its 
% geometry defined by a cylinder of radius width/2 and height
% length - width, plus two semi-spheres of radius width/2 
% at each cell tip.
% This gives the following equations for the surface of the cell
% 1) Semi-sphere negative side
%    r^2 = (x+d)^2 + y^2 + z^2 // x in [-d-r,-d]
% 2) Cylinder
%    r^2 = y^2 + z^2           // x in [-d,d]
% 3) Semi-sphere positive side
%    r^2 = (x-d)^2 + y^2 + z^2 // x in [d,d+r]
% where r = width/2 and d = length/2 - width/2;
% 
% INPUT:
% step    := 2 by 3 matrix. Each step(n,:) is expected as (long axis, 
%            width, height).
%            step(1,:) must be inside the cell.
% length  := length of cell (long axis)
% width   := diameter of the cell
%
% OUTPUT:
% bool    := 0 when step(2,:) is outside the cell, 1 when step(2,:) is inside
% inter   := intersection coordinate
% normal  := vector normal to the cell surface at the intersection
%            point. 
%            The normal vector is described taking the intersection
%            point as the origin.
% 
% WARNING: 
% 
% Sebastian Jaramillo-Riveri
% November, 2018

    bool   = 0;
    inter  = [0,0,0];
    normal = [0,0,0];
    
    inside1 = incell(step(1,:),length,width);
    inside2 = incell(step(2,:),length,width);
    
    if(inside1==0)
        errstr = ['ERROR: Initial coordinate in step must be inside the cell:',...
                      ' step = [',num2str(step(1,1)),',',num2str(step(1,2)),',',num2str(step(1,3)),';',...
                      ' ',num2str(step(2,1)),',',num2str(step(2,2)),',',num2str(step(2,3)),'];',...
                      ' length = ',num2str(length),'; width = ',num2str(width),';'];
        error(errstr);
    elseif(inside2==0)
        % Boolean that the step does intersect the boundary
        bool = 1;
        % Long axis of the cylinder
        d = length/2 - width/2;
        % Radius
        r = width/2;
        % Initial coordinate
        x1 = step(1,1); % 1: long axis 
        y1 = step(1,2); % 1: width axis
        z1 = step(1,3); % 1: height axis
        % Final coordinate
        x2 = step(2,1); % 2: long axis 
        y2 = step(2,2); % 2: width axis
        z2 = step(2,3); % 2: height axis
        %% The step vector equation will be given by
        % v(a) = (v2-v1)*a + v1, where a is an scalar
        % Trivially, v(a=1) = v2, v(a=0) = v1
        %
        % The boundaries equations are given by
        % 1) Semi-sphere negative side
        %    r^2 = (x+d)^2 + y^2 + z^2 // x in [-d-r,-d]
        % 2) Cylinder
        %    r^2 = y^2 + z^2           // x in [-d,d]
        % 3) Semi-sphere positive side
        %    r^2 = (x-d)^2 + y^2 + z^2 // x in [d,d+r]
        % 
        % So we need to find solutions that combine both the 
        % step vector equation and the boundaries, such that 
        % a in [0,1].
        % In each case we will get different quadratic equations of
        % the form p3*a^2 + p2*a + p1 = 0
        roots = NaN*[0,0;0,0;0,0];
        p     = [0,0,0;0,0,0;0,0,0]; % cuadratic parameters
        xs    = NaN*[0;0;0];   % long axis intersections
        % case 1)
        p(1,3) = x1^2-2*x1*x2+x2^2+y1^2-2*y1*y2+y2^2+z1^2-2*z1*z2+z2^2;
        p(1,2) = -2*d*x1+2*d*x2-2*x1^2+2*x1*x2-2*y1^2+2*y1*y2-2*z1^2+2*z1*z2;
        p(1,1) = d^2+2*d*x1-r^2+x1^2+y1^2+z1^2;
        % case 2)
        p(2,3) = y1^2-2*y1*y2+y2^2+z1^2-2*z1*z2+z2^2;
        p(2,2) = -2*y1^2+2*y1*y2-2*z1^2+2*z1*z2;
        p(2,1) = -r^2+y1^2+z1^2;
        % case 3)
        p(3,3) = x1^2-2*x1*x2+x2^2+y1^2-2*y1*y2+y2^2+z1^2-2*z1*z2+z2^2;
        p(3,2) = 2*d*x1-2*d*x2-2*x1^2+2*x1*x2-2*y1^2+2*y1*y2-2*z1^2+2*z1*z2;
        p(3,1) = d^2-2*d*x1-r^2+x1^2+y1^2+z1^2;
        
        mindelta = 1e-2;
        rootpos  = [0,0,0];
        for sc = 1:3
            disc = p(sc,2)^2-4*p(sc,3)*p(sc,1);
            if(disc >= 0)
                % non negative discriminant
                roots(sc,1) = (-p(sc,2)+sqrt(disc))/(2*p(sc,3));
                roots(sc,2) = (-p(sc,2)-sqrt(disc))/(2*p(sc,3));
                for i = 1:2
                    if(roots(sc,i) >= 0 && roots(sc,i)-1 <= 0)
                        xs(sc) = (x2-x1)*roots(sc,i)+x1;
                        rootpos(sc) = i;
                        break;
                    elseif(roots(sc,i) >= -mindelta && roots(sc,i) <= 0)
                        % solution almost within step
                        % force to be mindelta/10
                        % NOTE: not completely sure about this
                        roots(sc,i) = 0;
                        xs(sc)      = (x2-x1)*roots(sc,i)+x1;
                        rootpos(sc) = i;
                        break;
                    elseif(roots(sc,i)-1 >= 0 && roots(sc,i)-1 <= mindelta)
                        % solution almost within step
                        % force to be 1
                        % NOTE: not completely sure about this
                        roots(sc,i) = 1;
                        xs(sc) = (x2-x1)*roots(sc,i)+x1;
                        rootpos(sc) = i;
                        break;
                    end
                end
            end
        end
% $$$         xs
% $$$         roots
        % find solution that is within the domain 
        % (checking only long axis)
        xlimits = [-d-r,-d;...
                   -d  ,d;...
                    d  ,d+r];
        found = 0;
        
        for sc = [2,1,3] % cylinder first (assuming is quicker)
            if((xs(sc)-xlimits(sc,1) >= 0) && ...
               (xs(sc)-xlimits(sc,2) <= 0))
                factor = 1*roots(sc,rootpos(sc));
                inter  = [(x2-x1)*factor+x1,...
                          (y2-y1)*factor+y1,...
                          (z2-z1)*factor+z1];
                found = sc;
                if(incell(inter,length,width)==0)
                    inter
                    errstr = ['ERROR: Intersection point outside of cell:',...
                              ' inter = [',num2str(inter(1)),',',num2str(inter(2)),',',num2str(inter(3)),'];',...
                              ' sc = ',num2str(sc),'; ',...
                              ' step = [',num2str(step(1,1)),',',num2str(step(1,2)),',',num2str(step(1,3)),';',...
                              ' ',num2str(step(2,1)),',',num2str(step(2,2)),',',num2str(step(2,3)),'];',...
                              ' length = ',num2str(length),'; width = ',num2str(width),';'];
                    error(errstr);
                end
                if(sc==2)
                    normal = unitvect([0,inter(2),inter(3)]);
                    if(~(inter(2)^2+inter(3)^2-r^2 < mindelta))
                        error(['Problem with the intersection value ' ...
                               '(case 2)']);
                    end
                    % proof 
                elseif(sc==1)
                    normal = unitvect([inter(1)+d,inter(2),inter(3)]);
                    if(~((inter(1)+d)^2+inter(2)^2+inter(3)^2-r^2 < mindelta))
                        error(['Problem with the intersection value ' ...
                               '(case 1)']);
                    end
                else
                    normal = unitvect([inter(1)-d,inter(2),inter(3)]);
                    if(~((inter(1)-d)^2+inter(2)^2+inter(3)^2-r^2 < mindelta))
                        error(['Problem with the intersection value ' ...
                               '(case 3)']);
                    end
                end
                %normal = unitvect(normal);
                break;
            end
        end
        if(found==0)
            roots
            xs
            errstr = ['ERROR: Could not find intersection point:',...
                      ' step = [',num2str(step(1,1)),',',num2str(step(1,2)),',',num2str(step(1,3)),';',...
                      ' ',num2str(step(2,1)),',',num2str(step(2,2)),',',num2str(step(2,3)),'];',...
                      ' length = ',num2str(length),'; width = ',num2str(width),';'];
            error(errstr);
        end
    end
end