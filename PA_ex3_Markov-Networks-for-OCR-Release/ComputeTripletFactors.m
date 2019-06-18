function factors = ComputeTripletFactors (images, tripletList, K)
% This function computes the triplet factor values for one word.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word.
%   tripletList: An array of the character triplets we will consider (other
%     factor values should be 1). tripletList(i).chars gives character
%     assignment, and triplistList(i).factorVal gives the value for that
%     entry in the factor table.
%   K: The alphabet size (accessible in imageModel.K for the provided
%     imageModel).
%
% Hint: Every character triple in the word will use the same 'val' table.
%   Consider computing that array once and then resusing for each factor.
%
% Copyright (C) Daphne Koller, Stanford University, 2012


n = length(images);

% If the word has fewer than three characters, then return an empty list.
if (n < 3)
    factors = [];
    return
end

factors = repmat(struct('var', [], 'card', [], 'val', []), n - 2, 1);

% Your code here:
% M : 1st column: idx within the all 26^3 combinations
% M : 2nd column: corresponding factor value of specific combination
% here M is 2000x2
M = zeros(length(tripletList),length(fieldnames(tripletList)));

% extract assignment of top 2000 triplets
chars = cat(1, tripletList.chars);

for i = 1:length(chars)
    % convert each row in chars into a linear index for a single col vector
    % [K, K, K] is the size/shape of a matrix which contains all factor
    % values of interactions between 3 nodes/words
    M(i,1) = sub2ind([K, K, K],chars(i,1),chars(i,2),chars(i,3));
end    

% extract factor values corresponding to the top 2000 triplets
factorVal = cat(1,tripletList.factorVal);
M(:,2) = factorVal;

vals = ones(K^3,1);
vals(M(:,1)) = M(:,2);

for i = 1:n-2
    % variable numbers of character and its following character
    var_1 = i;
    var_2 = i+1;
    var_3 = i+2;
    
    % set var assignments of pairswise factor
    factors(i).var = [var_1, var_2, var_3];
    % set cardinality of pairwise factor
    factors(i).card = [K, K, K];
    % set factor values previously calculated in in vals
    factors(i).val = vals;
    
end    

end
