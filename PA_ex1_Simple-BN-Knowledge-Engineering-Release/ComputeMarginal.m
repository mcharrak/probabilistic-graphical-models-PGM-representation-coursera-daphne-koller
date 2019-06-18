%ComputeMarginal Computes the marginal over a set of given variables
%   M = ComputeMarginal(V, F, E) computes the marginal over variables V
%   in the distribution induced by the set of factors F, given evidence E
%
%   M is a factor containing the marginal over variables V
%   V is a vector containing the variables in the marginal e.g. [1 2 3] for
%     X_1, X_2 and X_3.
%   F is a vector of factors (struct array) containing the factors 
%     defining the distribution
%   E is an N-by-2 matrix, each row being a variable/value pair. 
%     Variables are in the first column and values are in the second column.
%     If there is no evidence, pass in the empty matrix [] for E.


function M = ComputeMarginal(V, F, E)

% Check for empty factor list
if (numel(F) == 0)
      warning('Warning: empty factor list');
      M = struct('var', [], 'card', [], 'val', []);      
      return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
% M should be a factor
% Remember to renormalize the entries of M!

% step1: calculate Joint distribution
Joint = ComputeJointDistribution(F);

% step2: include evidence in Joint distribution
Joint_E = ObserveEvidence(Joint,E);
% normalize values in Joint_E
Joint_E.val = Joint_E.val / sum(Joint_E.val);
% finally construct the correct factor after normalization
% NOTE: Joint_and_E_N: Joint Distribution which we applied ObserveEvidence
% on and finally normalized all probabilities
Joint_E_N = struct('var', Joint_E.var , 'card', Joint_E.card , 'val', Joint_E.val);

% step3: marginalization on Joint_E_N

% V_remove contains the variables which we need to sum out (marginalize)!
% NOTE: V above denotes variables remaining after marginalization
V_remove = setdiff(Joint_E_N.var,V);
M = FactorMarginalization(Joint_E_N,V_remove);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = struct('var', M.var , 'card', M.card , 'val', M.val); % Returns empty factor. Change this.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
