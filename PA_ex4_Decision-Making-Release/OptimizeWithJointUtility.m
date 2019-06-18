% Copyright (C) Daphne Koller, Stanford University, 2012
function [MEU, OptimalDecisionRule] = OptimizeWithJointUtility( I )
% Inputs: An influence diagram I with a single decision node and one or more utility nodes.
%         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
%              the child variable = D.var(1)
%         I.DecisionFactors = factor for the decision node.
%         I.UtilityFactors = list of factors representing conditional utilities.
% Return value: the maximum expected utility of I and an optimal decision rule
% (represented again as a factor) that yields that expected utility.
% You may assume that there is a unique optimal decision.

% This is similar to OptimizeMEU except that we must find a way to
% combine the multiple utility factors.  Note: This can be done with very
% little code.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_utility_factors = length(I.UtilityFactors);

% disp("First utility factor")
% disp(I.UtilityFactors(1))
% disp("Second utility factor")
% disp(I.UtilityFactors(2))

if n_utility_factors == 1
    U_joint = I.UtilityFactors(1);
else
    U_joint = I.UtilityFactors(1);
    for i = 2:n_utility_factors
        U_joint = FactorSum(U_joint,I.UtilityFactors(i));
    end
end

%replace field with 2 utility factors by joint utility factor
I.UtilityFactors = U_joint;

[MEU, OptimalDecisionRule] = OptimizeMEU(I);

end
