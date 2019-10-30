function [deltas] = weinerdeltas(n,D,t)
% [deltas] = weinerdeltas(n,D,t)
% creates weiner step deltas in 3 dimensions
% 
% INPUT:
% n  =: number of steps
% D  =: diffusion coefficient
% t  =: time increment per step
%
% OUTPUT:
% deltas := n by 3 matrix, where each value is a random sampling 
%           from distribution N(0,sqrt(2*D*t)) 
%
% Sebastian Jaramillo-Riveri
% November, 2018
deltas = zeros(n,3); % n steps, in 3 dimensions

sigma  = sqrt(2*D*t); % variance is 2*D*t
%sigma  = 2*D*t; % 
for i = 1:n
    for j = 1:3
        deltas(i,j) = normrnd(0,sigma);
    end
end

end