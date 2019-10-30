function [gyrations,centers,steps] = trajectories2gyration2D(trajectories,steps)
% [gyrations,centers,steps] = TRAJECTORIES2GYRATION2D(trajectories,steps)
% Given trajectories, calculates the radius of gyration in 2D for all
% step sizes given by steps (it counts from 0, meaning step size 0 is
% one jump).
%
% INPUT:
% trajectories := matrix with the coordinates for each
%                 trajectory (in 3D). The dimensions are
%                 nsteps+1 x 3 x nmols    
% steps        := vector of the step size to compute the increments.
%                 dimensions 1 x nsteps
%
% OUTPUT:
% gyrations    := 
% centers      := 
% steps        := 
%
% Sebastian Jaramillo-Riveri
% November, 2018

    ncoor  = size(trajectories,1);
    nmols  = size(trajectories,3);
    nst    = size(steps,2);
    
    gyrations = cell(nst,1);
    centers   = cell(nst,1);
    
    for ns = 1:nst
        % for each step in the set of steps
        s    = steps(ns);
        gyrs = zeros(nmols*(ncoor-s),1);
        cent = zeros(nmols*(ncoor-s),3);
        count = 0;
        for m = 1:nmols
            % for each trajectory
            for n = 1:(ncoor-s)
                % for each step size
                count = count+1;
                locations     = trajectories(n:(n+s),:,m);
                % get the center
                center        = mean(locations);
                % get the distance to the center
                dist          = center - locations;
                % calculate the average distance in 2D (only x and y)
                gyrs(count)   = mean(sqrt(dist(:,1).^2+dist(:,2).^2));
                cent(count,:) = center;
            end
        end
        gyrations{ns} = gyrs;
        centers{ns}   = cent;
    end

end