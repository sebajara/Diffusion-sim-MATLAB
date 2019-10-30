% assumes here is the current folder
addpath(genpath('../src/'));

length = 3;     % cell lenght (long axis)
width  = 1;     % cell width (same as height)

% arbitrary step
step = [0,0,0;1,1,1];
fig = figure();
plotboth(length,width,step,'autumn');
[bool,inter,normal] = cellintersect(step,length,width);
plottraj([inter;inter+normal],'winter');
plottraj(bouncetrajectory(step(1,:),step(2,:),length,width),'summer');
mypdfpngexpfig('PaperPosition',[0 0 20 4],...
               'outname','FIG_example_bouncing');
close(fig);

