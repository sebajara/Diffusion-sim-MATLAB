function [deltas] = simfreediff(nsteps,D,t,nmols)
% For a given diff coeff D and time step t, it gives the deltas in 3D
% coordinate for nmols molecules
%    
% Sebastian Jaramillo-Riveri
% November, 2018

    
    deltas = zeros(nsteps,3,nmols);

    for m = 1:nmols
        deltas(:,:,m) = weinerdeltas(nsteps,D,t);
    end

end