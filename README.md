# Simulation of confined diffusion within a cell

## Algorithm

### Free diffusion

We will assume that the position of particles in time can be described
by a Weiner process, meaning the displacement in each axis follows a
distribution
```math
x(s+t) = x(s) + \mathcal{N}(0,\sqrt{2Dt})
```
where $`D`$ is the diffusion coefficient and $`t`$ is time increment. We
will call this free diffusion.

Here is an example of free diffusion in 3D. Trajectories are coloured by
time (from red to yellow).  Diffusion coefficient = 1, 100 steps of 12
ms each.

![Free diffusion example](/examples/FIG_example_simdiff_freediff.png)

### Confinement

We assume that the cell geometry is fully defined by its length ($`l`$)
and diameter ($`w`$).  In particular, the cell surface will be described
by a cylinder of radius $`r = w/2`$ and height $`h = l - w`$, plus two
semi-spheres of the same radius at each tip (see drawings below).
This geometry gives the following equations for the volume of the cell
1. Semi-sphere negative side
   ```math
   r^2 \ge (x+d)^2 + y^2 + z^2 \mid x \in [-d-r,-d]
   ```
2. Cylinder
   ```math
   r^2 \ge y^2 + z^2 \mid x \in [-d,d]
   ```
3. Semi-sphere positive side
   ```math
   r^2 \ge (x-d)^2 + y^2 + z^2 \mid x \in [d,d+r]
   ```

where $`r = w/2`$ and $`d = l/2 - w/2`$. For these equations, the center
of the cell is located at the axis origin.

For any step that leads outside the cell, we assume that the trajectory
is "perfectly" reflected by the boundary (elastic collision). The new
position is computed by calculating the intersection bewteen the step
and the cell surface, together with the vector normal to the
surface. 

Here is an example of a step from $`[0,0,0]`$ to $`[1,1,1]`$ "bounced" by the
cell boundary. The original step is on red, the normal vector to the
intersection is on blue, and the resulting reflected step is on green.

![Reflection example](/examples/FIG_example_bouncing.png)

With the reflection (or bounce) operation, we can iteratively reflect
every step that exits the cell volume back into the cell. 

Here is an example of confined diffusion in 3D. The same trajectory from
the free diffusion simulation above was confined to a cell of length = 3
and width = 1. Trajectories are coloured by time (from red to yellow).

![Confined diffusion example](/examples/FIG_example_simdiff_confdiff.png)

## Displacement distributions 

We can define a random variable accounting for the increment after a
number of jumps ($`n`$) of a given time $`t`$
```math
i_{x}(n) = x(s+nt) - x(s) \mid n \in \mathbb{N}
```
which is equivalent to the frame acquisition time interval while
imaging (assuming no error on time delay).

Given only two dimensions are recorded experimentally, we will define
the displacement as the absolute distance in 2D.
```math
d_{xy}(n) = \sqrt{i_{x}(n)^2+i_{y}(n)^2} \mid n \in \mathbb{N}
```
In principle would be better to condition this distance on the initial
coordinates $`x(s),y(s)`$, however for the moment we will consider the
marginal distribution. 

Additionally, we will assume that the measurement of the particle
localisation in each dimension is subject to an error following a
Gaussian distribution $`\mathcal{N}(0,\sigma)`$, and the error in each
axis is independent from each other.

Summarising, the displacement will be a random variable,
and we will be interested in their p.d.f. 
```math
d_{xy}(n) \sim f(d \mid n,t,D,w,l,\sigma) 
```

To illustrate the effect of each parameter, we variate each one
individually using default parameters $`t = 0.012`$, $`D = 1`$, $`\sigma = 0`$, $`l
= 3`$, $`w = 1`$. For each parameter set we simulated 10000 trajectories
with 20 jumps each, and estimated the distributions of $`d_{xy}(n)`$ for
$`n = \{1,2,4,8\}`$. For simulations, the initial position of a
trajectory is uniformly sampled.

Here we present the histograms as heatmaps:

Default parameters example
![Changing number of frames](/examples/FIG_example_displacements_nsteps.png)

Variations in diffusion coefficient
![Changing diffusion coefficient](/examples/FIG_example_displacements_dgrid.png)

Variations in cell length
![Changing diffusion coefficient](/examples/FIG_example_displacements_lgrid.png)

Variations in cell width
![Changing diffusion coefficient](/examples/FIG_example_displacements_wgrid.png)

Variations in localisation error
![Changing localisation error](/examples/FIG_example_displacements_sgrid.png)


## Likelihood of trajectory ensembles

TODO

## TODO / problems

1. [ ] Estimate how much error is added from reflecting, and what is a good tolerance bound. Possible workaround: for high diffusion coefficient reduce the size of the time interval.
1. [ ] Resolve what to do with trajectories exceeding the maximum reflection iterations (>1000).
1. [ ] Random initial position may over-estimate the effect of confinement in experimental observations. Possible workaround: use positions from a long simulation (reach stationary distribution) as initial positions.
1. [ ] Technically would be better to use the distributions of displacements conditioned on the initial coordinate, rather than the marginal distributions. This would avoid any potential positioning bias and should be more accurate (but more intensive to simulate).

## List of functions

Please use the help command to see a more detailed explanation of each
function. Also, scrips used for generating the figures can be found in
the examples folder.

#### Simple diffusion:
* [deltas] = SIMFREEDIFF(nsteps,D,t,nmols)
* [deltas] = WEINERDELTAS(nsteps,D,t)

#### Diffusion auxiliary functions:
* [trajectories] = DELTAS2TRAJECTORIES(inits,deltas)
* [deltas,inits] = TRAJECTORIES2DELTAS(trajectories)

#### Confined diffusion:
* [deltas,trajectories] = SIMCONFDIFF(nsteps,D,t,nmols,length,width,sigma)
* [trajectory] = BOUNCETRAJECTORY(inits,deltas,length,width)
* [newstep] = BOUNCESTEP(step,length,width)

#### Confinement auxiliary functions
* [boolean,intersection,normal] = CELLINTERSECT(step,length,width)
* [boolean] = INCELL(coor,length,width)
* [coordinates] = RNDCELLCOORDINATE(n,length,width)

#### Post-analysis functions
* [displacements] = DELTAS2DISPLACEMENTS(deltas,steps)

#### Fitting:

#### Auxiliary generic function:
* [newmatrix] = ADDWHITENOISE(matrix,sigma)
* [product]  = DOTPROD(vector1,vector2)
* [length]  = VLENGTH(vector) 
* [normvector,prevlength] = UNITVECT(vector)

#### Plotting:
* [] = PLOTBOTH(length,width,trajectory,cmap)
* [] = PLOTCELL(length,width)
* [] = PLOTTRAJ(trajectory,cmap)



