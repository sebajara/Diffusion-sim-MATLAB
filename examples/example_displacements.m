% assumes here is the current folder
addpath(genpath('../src/'));

% NOTE: these take a bit of time to run

%% Default parameters

t      = 0.012; % 12 ms
nsteps = 20;    % 20 maximum steps of t time
nmols  = 1e04;  % number of trajectories
length = 3;     % cell lenght (long axis)
width  = 1;     % cell width (same as height)
D      = 1;     % diff coeff
sigma  = 0;     % coordinate noise
steps  = [0,1,3,7]; % for computing final deltas
rbins  = linspace(0,5,200); % for histograms

%% default parameters
steps2 = [0:19];
probmat = zeros(size(rbins,2),size(steps2,2));
[deltas,~] = simconfdiff(nsteps,D,t,nmols, ...
                         length,width,sigma);
dsset = deltas2displacements(deltas,steps2);
for nt = 1:size(steps2,2)
    vals3D = dsset{nt};
    vals   = sqrt(vals3D(:,1).^2+vals3D(:,2).^2);
    probmat(:,nt) = relhist(vals,rbins);
end

fig = figure();
pos = find(rbins>1.5);
mp  = pos(1);
maxd = rbins(mp);
plotheatmap(probmat(1:mp,:)',...
            'title',[''],...
            'xlabel','n',...
            'ylabel','d$_{xy}$ [$\mu$m]',...
            'fsize',12,...
            'nticks',5,...
            'axis',[1,20,min(rbins),1.5]);
mypdfpngexpfig('PaperPosition',[0 0 20 4],...
               'outname','FIG_example_displacements_nsteps');
close(fig);

%% Variations in diffusion coefficient
dgrid = linspace(0.05,5,20);
probmat = zeros(size(rbins,2),size(dgrid,2),size(steps,2));
for nd = 1:size(dgrid,2)
    display(['D = ',num2str(dgrid(nd))]);
    [deltas,~] = simconfdiff(nsteps,dgrid(nd),t,nmols, ...
                             length,width,sigma);
    dsset = deltas2displacements(deltas,steps);
    for nt = 1:size(steps,2)
        vals3D = dsset{nt};
        vals   = sqrt(vals3D(:,1).^2+vals3D(:,2).^2);
        probmat(:,nd,nt) = relhist(vals,rbins);
    end
end

fig = figure();
for n = 1:4
    subplot(1,4,n);
    % plot only up to 1.5
    pos = find(rbins>1.5);
    mp  = pos(1);
    maxd = rbins(mp);
    plotheatmap(probmat(1:mp,:,n)',...
                'title',['n = ',num2str(steps(n)+1)],...
                'xlabel','D [$\mu$m/s]',...
                'ylabel','d$_{xy}$ [$\mu$m]',...
                'fsize',12,...
                'nticks',3,...
                'axis',[min(dgrid),max(dgrid),min(rbins),maxd]);
end
mypdfpngexpfig('PaperPosition',[0 0 20 4],...
               'outname','FIG_example_displacements_dgrid');
close(fig);

%% Variations in length
lgrid = linspace(1,10,20);
probmat = zeros(size(rbins,2),size(lgrid,2),size(steps,2));
for ns = 1:size(sgrid,2)
    [deltas,~] = simconfdiff(nsteps,D,t,nmols, ...
                             lgrid(ns),width,sigma);
    dsset = deltas2displacements(deltas,steps);
    for nt = 1:size(steps,2)
        vals3D = dsset{nt};
        vals   = sqrt(vals3D(:,1).^2+vals3D(:,2).^2);
        probmat(:,ns,nt) = relhist(vals,rbins);
    end
end

fig = figure();
for n = 1:4
    subplot(1,4,n);
    % plot only up to 
    pos = find(rbins>1.5);
    mp  = pos(1);
    maxd = rbins(mp);
    plotheatmap(probmat(1:mp,:,n)',...
                'title',['n = ',num2str(steps(n)+1)],...
                'xlabel','length [$\mu$m]',...
                'ylabel','d$_{xy}$ [$\mu$m]',...
                'fsize',12,...
                'nticks',3,...
                'axis',[min(lgrid),max(lgrid),min(rbins),maxd]);
end
mypdfpngexpfig('PaperPosition',[0 0 20 4],...
               'outname','FIG_example_displacements_lgrid');
close(fig);

%% Variations in width
wgrid = linspace(0.5,2,20);
probmat = zeros(size(rbins,2),size(wgrid,2),size(steps,2));
for ns = 1:size(sgrid,2)
    [deltas,~] = simconfdiff(nsteps,D,t,nmols, ...
                             length,wgrid(ns),sigma);
    dsset = deltas2displacements(deltas,steps);
    for nt = 1:size(steps,2)
        vals3D = dsset{nt};
        vals   = sqrt(vals3D(:,1).^2+vals3D(:,2).^2);
        probmat(:,ns,nt) = relhist(vals,rbins);
    end
end

fig = figure();
for n = 1:4
    subplot(1,4,n);
    % plot only up to 
    pos = find(rbins>1.5);
    mp  = pos(1);
    maxd = rbins(mp);
    plotheatmap(probmat(1:mp,:,n)',...
                'title',['n = ',num2str(steps(n)+1)],...
                'xlabel','width [$\mu$m]',...
                'ylabel','d$_{xy}$ [$\mu$m]',...
                'fsize',12,...
                'nticks',3,...
                'axis',[min(wgrid),max(wgrid),min(rbins),maxd]);
end
mypdfpngexpfig('PaperPosition',[0 0 20 4],...
               'outname','FIG_example_displacements_wgrid');
close(fig);

%% Variations in error
sgrid = linspace(0.0,0.4,20);
probmat = zeros(size(rbins,2),size(sgrid,2),size(steps,2));
for ns = 1:size(sgrid,2)
    ns
    [deltas,~] = simconfdiff(nsteps,D,t,nmols, ...
                             length,width,sgrid(ns));
    dsset = deltas2displacements(deltas,steps);
    for nt = 1:size(steps,2)
        vals3D = dsset{nt};
        vals   = sqrt(vals3D(:,1).^2+vals3D(:,2).^2);
        probmat(:,ns,nt) = relhist(vals,rbins);
    end
end

fig = figure();
for n = 1:4
    subplot(1,4,n);
    % plot only up to 
    pos = find(rbins>3);
    mp  = pos(1);
    maxd = rbins(mp);
    plotheatmap(probmat(1:mp,:,n)',...
                'title',['n = ',num2str(steps(n)+1)],...
                'xlabel','$\sigma$ [$\mu$m]',...
                'ylabel','d$_{xy}$ [$\mu$m]',...
                'fsize',12,...
                'nticks',3,...
                'axis',[min(sgrid),max(sgrid),min(rbins),maxd]);
end
mypdfpngexpfig('PaperPosition',[0 0 20 4],...
               'outname','FIG_example_displacements_sgrid');
close(fig);