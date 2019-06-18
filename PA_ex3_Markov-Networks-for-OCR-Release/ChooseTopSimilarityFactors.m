function factors = ChooseTopSimilarityFactors (allFactors, F)
% This function chooses the similarity factors with the highest similarity
% out of all the possibilities.
%
% Input:
%   allFactors: An array of all the similarity factors.
%   F: The number of factors to select.
%
% Output:
%   factors: The F factors out of allFactors for which the similarity score
%     is highest.
%
% Hint: Recall that the similarity score for two images will be in every
%   factor table entry (for those two images' factor) where they are
%   assigned the same character value.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

% If there are fewer than F factors total, just return all of them.
if (length(allFactors) <= F)
    factors = allFactors;
    return;
end

% extract values for each of the length(in) factors
% fact_vals is (K^2) x length(in)
fact_vals = horzcat(allFactors.val);

% find max value in each column (remember that this max value exists
% exactly 26 times in each column
% col_max_vals has dimension 1 x length(in)
col_max_vals = max(fact_vals,[],1);

% fetch column indices of top 2 max value entries in col_max_vals
[~,topF_idxs] = maxk(col_max_vals,F);

% Your code here:

factors = allFactors(topF_idxs);

end

