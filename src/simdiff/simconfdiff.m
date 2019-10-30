function [deltas,trajectories] = simconfdiff(nsteps,D,t,nmols,length,width,sigma)
% [deltas,trajectories] = SIMCONFDIFF(nsteps,D,t,nmols,length,width,sigma)
% Simulation of confined diffusion. The initial position of each
% trajectory is assigned randomly within the cell. See SIMFREEDIFF
% function for simulating free diffusion, and BOUNCETRAJECTORY
% function for how confinement is computed. Finally, a Gaussian error
% is added on each coordinate using ADDWHITENOISE function.
% 
% INPUT:
% nsteps := number of jumps for each trajectory
% D      := diffusion coefficient
% t      := time interval of each jump
% nmols  := number of trajectories
% length := cell length (long axis)
% width  := cell diameter 
% sigma  := standard deviation for coordinate error
% 
% OUTPUT:
% deltas       := matrix with the increment of each step along the
%                 trajectory (in 3D). The dimensions are
%                 nsteps x 3 x nmols    
% trajectories := matrix with the actual coordinates for each
%                 trajectory (in 3D). The dimensions are
%                 nsteps+1 x 3 x nmols    
%
% Sebastian Jaramillo-Riveri
% November, 2018

% free diff
freedeltas   = simfreediff(nsteps,D,t,nmols);
% random initial position
inits        = rndcellcoordinate(nmols,length,width);

if(sigma==0)
    % bounce trajectories
    trajectories = bouncetrajectory(inits,freedeltas,length,width);
else
    % bounce first and then add noise
    trajectories = addwhitenoise(bouncetrajectory(inits,freedeltas,length,width),sigma);
end

% compute confined deltas
deltas = trajectories2deltas(trajectories);

end