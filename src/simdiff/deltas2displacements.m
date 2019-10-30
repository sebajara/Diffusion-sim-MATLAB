function [displacements] = deltas2displacements(deltas,steps)
% [displacements] = deltas2displacements(deltas,steps)
% collects the values of all increments of size given by the vector 
% in steps. Notice this takes all possible combinations of jumps of 
% that size.
% For example: steps = [0,1] returns all increments after 
% one and two jumps (the code counts from 0).
%
% INPUT:
% deltas       := matrix with the increment of each step along the
%                 trajectory (in 3D). The dimensions are
%                 nsteps x 3 x nmols    
% steps        := vector of the step size to compute the increments.
%                 dimensions 1 x nsteps
% 
% OUTPUT: 
% displacements := cell array with dimension nsteps x 1. Each cell
%                  contains a matrix of size nmols*(nsteps-s) by 3
%                  where s is the value of the entry in the steps vector.
%
% Sebastian Jaramillo-Riveri
% November, 2018
    
    displacements = cell(size(steps,2),1);
    
    ndim   = size(deltas,2);
    nsteps = size(deltas,1);
    nmols  = size(deltas,3);

    for ns = 1:size(steps,2)
        s    = steps(ns);
        disp = zeros(nmols*(nsteps-s),ndim);
        count = 0;
        for m = 1:nmols
            for n = 1:(nsteps-s)
                count = count+1;
                if(s>0)
                    disp(count,:) = sum(deltas(n:(n+s),:,m));
                else
                    disp(count,:) = deltas(n,:,m);
                end
            end
        end
        displacements{ns} = disp;
    end
    
end