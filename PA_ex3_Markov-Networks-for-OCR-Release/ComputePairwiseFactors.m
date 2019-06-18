function factors = ComputePairwiseFactors (images, pairwiseModel, K)
% This function computes the pairwise factors for one word and uses the
% given pairwise model to set the factor values.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word.
%   pairwiseModel: The provided pairwise model. It is a K-by-K matrix. For
%     character i followed by character j, the factor value should be
%     pairwiseModel(i, j).
%   K: The alphabet size (accessible in imageModel.K for the provided
%     imageModel).
%
% Output:
%   factors: The pairwise factors for this word.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

n = length(images);

% If there are fewer than 2 characters, return an empty factor list.
if (n < 2)
    factors = [];
    return;
end

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
    % set value of pairwise factor by simply squezzing KxK matrix into K^2x1
    % matrix (i.e. we stack columns of matrix into single column vector)
    factors(i).val = pairwiseModel(:);
    
end    

end
