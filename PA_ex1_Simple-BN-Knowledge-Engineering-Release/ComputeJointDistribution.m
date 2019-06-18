%ComputeJointDistribution Computes the joint distribution defined by a set
% of given factors
%
%   Joint = ComputeJointDistribution(F) computes the joint distribution
%   defined by a set of given factors
%
%   Joint is a factor that encapsulates the joint distribution given by F
%   F is a vector of factors (struct array) containing the factors 
%   defining the distribution (i.e. the Bayesian Network (BN))
%

function Joint = ComputeJointDistribution(F)

  % Check for empty factor list
  if (numel(F) == 0)
      warning('Error: empty factor list');
      Joint = struct('var', [], 'card', [], 'val', []);      
      return;
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
% Compute the joint distribution defined by F
% You may assume that you are given legal CPDs so no input checking is required.

% determine how many factors we have in total
m = numel(F); 

% initialize Joint to be the first factor (because maybe the whole BN
% consists of only a single variable (->single factor)
Joint = F(1);

if m > 1
    for i = 2:m
        Joint = FactorProduct(Joint,F(i));
    end
end    
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
Joint = struct('var', Joint.var, 'card', Joint.card, 'val', Joint.val); % Returns empty factor. Change this.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end