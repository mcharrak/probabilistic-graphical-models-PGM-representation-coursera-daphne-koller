function factor = ComputeSimilarityFactor (images, K, i, j)
% This function computes the similarity factor between two character images
% in one word --- which characters is given by indices i and j (a
% description of how the factor should be computed is given below).
%
% Input:
%   images: A struct array of character images from one word.
%   K: The alphabet size.
%   i,j: The scope of that factor. That is, you should construct a factor
%     between characters i and j in the images array.
%
% Output:
%   factor: The similarity factor between these two characters. For any
%     assignment C_i != C_j, the factor value should be one. For any
%     assignment C_i == C_j, the factor value should be
%     ImageSimilarity(I_i, I_j) --- ie, the computed value given by
%     ImageSimilarity.m on the two images.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

factor = struct('var', [], 'card', [], 'val', []);

% Your code here:

% set var number of factor (i.e. scope)
factor.var = [i, j];
% set cardinality of each var in scope of variable
factor.card = [K, K];

char_idx_vec = 1:K;
% number of permutations with repetition for pairs of two alphabet letters
perms = combvec(char_idx_vec,char_idx_vec);
% transpose because we need (K^2)x2 instead of 2x(K^2)
perms = perms';

% fetch i-th and j-th images from images strict
img1 = images(i).img;
img2 = images(j).img;

% calculate image-similartiy (cosine similarity between images I_i and I_j)
sim = ImageSimilarity(img1,img2);

% default similarity for cases where C_i != C_j is 1 only when C_i != C_j we
% set similarity to ImageSimilarity(I_i,I_j)
factor_vals = ones(K^2,1);

% find rows in entries in perms are same
rel_idx = find(perms(:,1) == perms(:,2));

%update factor vals
factor_vals(rel_idx) = sim;

factor.val = factor_vals;

end

