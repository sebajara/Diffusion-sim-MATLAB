function [deltas,inits] = trajectories2deltas(trajectories)
% [deltas,inits] = TRAJECTORIES2DELTAS(trajectories)
% calculate the single step increments for trajectories and
% and also return the initial coordinates.
% See also inverse function DELTAS2TRAJECTORIES.
%
% INPUT:
% trajectories := matrix with the coordinates for each
%                 trajectory (in 3D). The dimensions are
%                 nsteps+1 x 3 x nmols    
% 
% OUTPUT:
% deltas       := matrix with the increment of each step along the
%                 trajectory (in 3D). The dimensions are
%                 nsteps x 3 x nmols    
% initis       := nmols by 3 matrix, with the initial position of 
%                 the trajectories
% 
% Sebastian Jaramillo-Riveri
% November, 2018

    nsteps = size(trajectories,1);
    nmols  = size(trajectories,3);

    deltas = zeros(nsteps-1,3,nmols);
    inits  = zeros(nmols,3);

    for m = 1:nmols
        inits(m,:) = trajectories(1,:,m);
        for s = 1:(nsteps-1)
            deltas(s,:,m) = trajectories(s+1,:,m)-trajectories(s,:,m);
        end
    end

end