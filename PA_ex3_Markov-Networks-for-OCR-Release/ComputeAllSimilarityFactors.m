function factors = ComputeAllSimilarityFactors (images, K)
% This function computes all of the similarity factors for the images in
% one word.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word.
%   K: The alphabet size (accessible in imageModel.K for the provided
%     imageModel).
%
% Output:
%   factors: Every similarity factor in the word. You should use
%     ComputeSimilarityFactor to compute these.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

% n number of images in i-th word e.g. allWords{i}
n = length(images);
% number of possible combinations w/o replacement i.e. Gauss sum for i=1 to
% n-1
nFactors = nchoosek (n, 2);

factors = repmat(struct('var', [], 'card', [], 'val', []), nFactors, 1);

% Your code here:

img_indices = zeros(nFactors,2);
% create row counter idx
row_idx = 1;
for i = 1:n-1
    for j = i+1:n
        img_indices(row_idx,:) = [i j];
        row_idx = row_idx + 1;
    end
end    

for a = 1:nFactors
    
    % fetch image indices for a-th factor from img_indices
    var_i = img_indices(a,1);
    var_j = img_indices(a,2);

    % calculate factor of current idx fac_idx
    factors(a) = ComputeSimilarityFactor (images, K, var_i, var_j);  
    
end    
end

