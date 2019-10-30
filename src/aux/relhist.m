function [hf] = relhist(x,bins)
% [hf] = relhist(x,bins)
% calculates the relative frequency of values x 
% given binning defined by bins.

h = histc(x,bins);
hf = h./sum(h);

end