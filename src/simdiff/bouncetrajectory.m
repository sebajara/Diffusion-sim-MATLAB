function [trajectories] = bouncetrajectory(inits,deltas,length,width)
% [trajectories] = BOUNCETRAJECTORY(inits,deltas,length,width)
% Bounce the trajectories defined by initial positions (inits) and
% step increments (deltas) by the surface of the cell defined by
% length and width. See BOUNCESTEP function for how individual jumps 
% are bounced or reflected.
%
% INPUT:
% inits  := initial coordinates. Dimensions should be nmols x 3
% deltas := matrix with the increment of each step along the
%           trajectory (in 3D). The dimensions are 
%           nsteps x 3 x nmols
% length  := length of cell (long axis)
% width   := diameter of the cell
% 
% OUTPUT:
% trajectories := Trajectories after iterative bouncing by the cell
%                 boundary. Dimensions of matrix
%                 nsteps+1 x 3 x nmols
%
% Sebastian Jaramillo-Riveri
% November, 2018

nsteps = size(deltas,1);
nmols  = size(deltas,3);

if(~(nmols == size(inits,1)))
    error('Initial position does not match dimension of coordinate increments');
end

trajectories = zeros(nsteps+1,3,nmols);

for m = 1:nmols
    % temporary trajectory matrix
    tracjs      = zeros(nsteps+1,3);
    tracjs(1,:) = inits(m,:);
    % for each step
    for n = 1:nsteps
        % step from n -> n +1
        step    = [tracjs(n,:);tracjs(n,:)+deltas(n,:,m)];
        % bounce if needed
        newstep = bouncestep(step,length,width);
        % update
        tracjs(n+1,:) = newstep(2,:);
    end
    trajectories(:,:,m) = tracjs;
end

end