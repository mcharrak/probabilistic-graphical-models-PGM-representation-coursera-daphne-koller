function factors = ComputeEqualPairwiseFactors (images, K)
% This function computes the pairwise factors for one word in which every
% factor value is set to be 1.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word.
%   K: The alphabet size (accessible in imageModel.K for the provided
%     imageModel).
%
% Output:
%   factors: The pairwise factors for this word. Every entry in the factor
%     vals should be 1.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

n = length(images);

factors = repmat(struct('var', [], 'card', [], 'val', []), n - 1, 1);

% Your code here:

for i = 1:n-1
    % variable numbers of character and its following character
    var_1 = i;
    var_2 = i+1;
    
    % set var assignments of pairswise factor
    factors(i).var = [var_1, var_2];
    % set cardinality of pairwise factor
    factors(i).card = [K, K];
    % set value of pairwise fator
    factors(i).val = ones(K^2,1);
    
end    

end
