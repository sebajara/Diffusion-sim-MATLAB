function [trajectories] = deltas2trajectories(inits,deltas)
% [trajectories] = deltas2trajectories(inits,deltas)
% calculate trajectories given the single step increments and
% initial coordinates.
% See also inverse function TRAJECTORIES2DELTAS.
%
% INPUT:
% deltas       := matrix with the increment of each step along the
%                 trajectory (in 3D). The dimensions are
%                 nsteps x 3 x nmols    
% initis       := nmols by 3 matrix, with the initial position of 
%                 the trajectories
%
% OUTPUT:
% trajectories := matrix with the coordinates for each
%                 trajectory (in 3D). The dimensions are
%                 nsteps+1 x 3 x nmols    
%  
% Sebastian Jaramillo-Riveri
% November, 2018

% Sebastian Jaramillo-Riveri
% November, 2018

    nsteps = size(deltas,1);
    nmols  = size(deltas,3);

    if(~(nmols == size(inits,1)))
        error('Initial position does not match dimension of coordinate increments');
    end

    trajectories = zeros(nsteps+1,3,nmols);

    for m = 1:nmols
        trajectories(1,:,m) = inits(m,:);
        csum = cumsum(deltas(:,:,m));
        trajectories(2:end,:,m) = inits(m,:) + csum;
    end

end