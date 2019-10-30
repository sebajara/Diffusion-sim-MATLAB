function [deltas,inits] = trajectories2deltas2(trajectories)
% [deltas,inits] = TRAJECTORIES2DELTAS(trajectories)
% For experimental data where trajectories are a cell array
% 
% Sebastian Jaramillo-Riveri
% November, 2018
    
    nmols = length(trajectories);
    
    deltas = cell(nmols,3);
    inits  = zeros(nmols,2);

    for m = 1:nmols
        tracks     = trajectories{m};
        inits(m,:) = tracks(1,1:2);
        nsteps     = size(tracks,1);
        if(nsteps>1)
            ldeltas    = zeros(nsteps-1,2);
            for s = 1:(nsteps-1)
                ldeltas(s,:) = tracks(s+1,1:2)-tracks(s,1:2);
            end
            disps = deltas2displacements(ldeltas,[0,1,2]);
            for k = 1:3
                deltas{m,k} = disps{k};
            end
        end
    end

end