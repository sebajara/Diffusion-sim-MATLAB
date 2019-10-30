function [newmatrix] = addwhitenoise(matrix,sigma)
% [newmatrix] = ADDWHITENOISE(matrix,sigma)
% adds gaussian noise, meaning x -> x + N(0,sigma)
%
% INPUT:
% matrix := 3 dimensional numeric array
% sigma  := standard deviation for noise added
%
% OUTPUT:
% newmatrix := matrix of same dimension as the input, but each value
%              was added a random number taken from the 
%              distribution N(0,sigma)
%
% Sebastian Jaramillo-Riveri
% November, 2018

    [nrows,ncols,nmols] = size(matrix);

    newmatrix = zeros(nrows,ncols,nmols);

    for x = 1:nrows
        for y = 1:ncols
            for m = 1:nmols
                new = matrix(x,y,m) + normrnd(0,sigma);
                newmatrix(x,y,m) = new;
            end
        end
    end

end