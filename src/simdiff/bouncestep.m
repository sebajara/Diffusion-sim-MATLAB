function [newstep] = bouncestep(step,length,width)
% [newstep] = bouncestep(step,length,width)
% takes a jump from step(1,:) to step(2,:) and bounce it 
% iteratively
% 
% INPUT:
% step    := 2 by 3 matrix. Each step(n,:) is expected as (long axis, 
%            width, height).
%            step(1,:) must be inside the cell.
% length  := length of cell (long axis)
% width   := diameter of the cell
%
% OUTPUT:
% newstep := step after bouncing
%
% WARNING: to avoid infinite loops, maximum iterations is set to
%          1e04. Also, it is possible to find periodic iterations that
%          return to the same intersection point. Those return the
%          intersection point as step(2,:) by default (same as 
%          for max iteration reached).
% Sebastian Jaramillo-Riveri
% November, 2018

maxiter = 5e04; % maximum iterations just in case
citer   = 0;
intersteps = zeros(maxiter+1,3);

[bool,inter,normal] = cellintersect(step,length,width);
newstep = step;
if(bool==1)
    % bounce the vector until we get inside the cell
    while(bool==1 &&  citer < maxiter)
        % use the normal to bounce the remainder of the step
        newstep(2,:) = -2*dotprod(newstep(2,:)-inter,1*normal).*(1*normal)+ newstep(2,:);
        citer        = citer+1;
        %plottraj([inter;newstep(2,:)],'summer');        
        % save the intersection point
        %intersteps(citer,:) = inter;
        % now vector originates from intersection
        newstep(1,:) = inter;
        % re-evaluate if we are now within the cell
        [bool,inter,normal] = cellintersect(newstep,length,width);
% $$$         if(abs(vlength(newstep(1,:)-inter))<1e-6)
% $$$             % simple stationary state!
% $$$             warning('WARNING: periodic bouncing encountered');
% $$$             % NOTE: I am not sure this is the best way to deal with
% $$$             % this, also can't guarantee this is not a bug due to how
% $$$             % I am computing things...
% $$$             newstep(2,:) = inter;
% $$$             bool = 0;
% $$$             break;
% $$$         end
    end
    %intersteps = intersteps(1:citer,:);
    if(bool==1)
        %%display('WARNING: in BOUNCESTEP, maximum iterations reached');
        % is this is wrong? let's leave it like that to avoid conflicts
        newstep(2,:) = inter;
    end
end
if(incell(newstep(2,:),length,width)==0)
    % just in case
    error('ERROR: solution to confinement is out of bounds');
end
% to avoid confusions (may be is more confusing...)
newstep(1,:) = step(1,:);

end