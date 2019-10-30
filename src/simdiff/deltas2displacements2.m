function [displacements] = deltas2displacements2(deltas,steps)
% [displacements] = DELTAS2DISPLACEMENTS(deltas,steps)
% for experimental data where deltas are cell arrays
% Sebastian Jaramillo-Riveri
% November, 2018

    displacements = cell(size(steps,2),1);
    
    nmols  = length(deltas);
    
    nsteps = size(deltas,1);

    for ns = 1:size(steps,2)
        s = steps(ns);
        disp = zeros(nmols*(nsteps-s),3);
        count = 0;
        for m = 1:nmols
            for n = 1:(nsteps-s)
                count = count+1;
                disp(count,:) = sum(deltas(n:(n+s),:,m));
            end
        end
        displacements{ns} = disp;
    end
    
end