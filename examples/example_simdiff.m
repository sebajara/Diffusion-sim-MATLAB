% assumes here is the current folder
addpath(genpath('../src/'));

nsteps = 100;
D      = 1;
t      = 0.012;
nmols  = 1;
length = 3;     % cell lenght (long axis)
width  = 1;     % cell width (same as height)

[deltas] = simfreediff(nsteps,D,t,nmols);
[trajectories] = deltas2trajectories([0,0,0],deltas);

fig = figure();
plottraj(trajectories,'autumn');
% export works only in linux
mypdfpngexpfig('PaperPosition',[0 0 20 4],...
               'outname','FIG_example_simdiff_freediff');
close(fig);

fig = figure();
plotboth(length,width,bouncetrajectory([0,0,0],deltas,length,width),'autumn');
mypdfpngexpfig('PaperPosition',[0 0 20 4],...
               'outname','FIG_example_simdiff_confdiff');
close(fig);


