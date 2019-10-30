function [likelhmat,obsacc] = simplelhdiffgrid(trajectories,fitsteps,params)
% [likelhmat,obsacc] = SIMPLELHDIFFGRID(trajectories,fitsteps,params)
% Single diffusion likelihood
%
% INPUT:
% trajectories  := matrix n x 3 x m, where n is ordered by time and m
%                  are tracks
%
% fitsteps      := 
%
% params        := structure
% params.steps  := delta steps to be used for fitting
% params.rbins  := binning of displacements
% params.darray := D coeff array
% params.sarray := white noise sigma array
% params.dprobs := matrix r x t x d x s / where:
%                  r is the index in rbins,
%                  t is the index in steps,
%                  d is the index in darray,
%                  s is the index in sarray
%
% OUTPUT:
%
% Sebastian Jaramillo-Riveri
% November, 2018

    nrbins = size(params.rbins,2);
    ndcoef = size(params.darray,2);
    nsigwn = size(params.sarray,2);
    ndelts = size(fitsteps,2);
    
    % convert trajectory and extract displacements for each step
    [deltas,~]      = trajectories2deltas(trajectories);
    [displacements] = deltas2displacements(deltas,fitsteps);

    % counting how many instances we have within each bin
    counts = zeros(nrbins,ndelts);
    for ns = 1:ndelts
        disps        = displacements{ns};
        vals         = sqrt(disps(:,1).^2+disps(:,2).^2);
        counts(:,ns) = histc(vals,params.rbins);
    end
    % get only positions bigger than 0 to save time later
    ppos    = find(counts>0);
    tcounts = counts(ppos);
    totalobs = sum(tcounts); % total number of observations
    
    % map fitsteps to params.steps
    ntpos = zeros(size(fitsteps));
    for nt = 1:ndelts
        ntpos(nt) = find(params.steps==fitsteps(nt));        
    end
    
    % actual output
    likelhmat = zeros(ndcoef,nsigwn); % diff by sigma
    obsacc    = zeros(ndcoef,nsigwn); % diff by sigma
    for nd = 1:ndcoef
        for ns = 1:nsigwn
            % probs for this parameter
            lprobs = params.dprobs(:,ntpos,nd,ns);
            % probs where values were observed
            tprobs = lprobs(ppos);
% $$$             % log likelihood of the whole observation given the
% $$$             % parameters
% $$$             likelhmat(nd,ns) = sum(log(tprobs).*tcounts);
            % get only positive probs
            ppos2  = find(tprobs>0);
            % log likelihood of the whole observation given the
            % parameters
            if(sum(tcounts(ppos2))<totalobs)
                % some observations have prob 0
                lh = NaN;
            else
                lh = sum(log(tprobs(ppos2)).*tcounts(ppos2));
            end
            likelhmat(nd,ns) = lh;
            obsacc(nd,ns) = sum(tcounts(ppos2));
        end
    end
    
end