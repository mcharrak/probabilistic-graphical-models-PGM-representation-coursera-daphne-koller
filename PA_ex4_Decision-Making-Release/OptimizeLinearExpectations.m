% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU, OptimalDecisionRule] = OptimizeLinearExpectations( I )
% Inputs: An influence diagram I with a single decision node and one or more utility nodes.
%         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
%              the child variable = D.var(1)
%         I.DecisionFactors = factor for the decision node.
%         I.UtilityFactors = list of factors representing conditional utilities.
% Return value: the maximum expected utility of I and an optimal decision rule
% (represented again as a factor) that yields that expected utility.
% You may assume that there is a unique optimal decision.
%
% This is similar to OptimizeMEU except that we will have to account for
% multiple utility factors.  We will do this by calculating the expected
% utility factors and combining them, then optimizing with respect to that
% combined expected utility factor.

% make copies of influence diagram and keep only one utility node
n_utility_nodes = length(I.UtilityFactors);

if n_utility_nodes == 1
    utility_factor = CalculateExpectedUtilityFactor(I);
else    
    % buffer to save EUFs
    EUFs = [];
    for i = 1:n_utility_nodes
        I_temp = I;
        I_temp.UtilityFactors = I.UtilityFactors(i);
        euf = CalculateExpectedUtilityFactor(I_temp);
        EUFs = [EUFs, euf];
    end
    
    n_EUF = length(EUFs);    
    utility_factor = EUFs(1);
    for j = 2:n_EUF
        utility_factor = FactorSum(utility_factor,EUFs(j));
    end
end


% We assume I has a single decision node.
% You may assume that there is a unique optimal decision.
D = I.DecisionFactors(1);

% get decision node variable number
D_var = D.var(1);

% caculate utility factor
%disp("This is the utlity factor result:");
%disp(utility_factor);

% get column indx and variables of all vars in utility_factor which are not D_var
not_D_var = setdiff(utility_factor.var,D_var);
idx_not_D_var = find(D_var ~= utility_factor.var); 
% find index of D variable in variables of 
idx_D_var = find(D_var == utility_factor.var);

% count rows in utility factor table
num_U_values = prod(utility_factor.card);

% get assignments of utilityfactor
assignments = IndexToAssignment(1:num_U_values, utility_factor.card);
%disp("These are the assignments:")
%disp(assignments)
% get relevant assigments which do not contain decision node D as column
rel_assignments = assignments(:,idx_not_D_var);

disp("Utiity_Factor")
disp(utility_factor)

% count number of scenarios we have to make a decision
n_decisions = prod(utility_factor.card);

step_size = prod(utility_factor.card(idx_not_D_var));

% case when decision node has no children
if length(utility_factor.var) == 1
    [~,max_idx] = max(utility_factor.val);
    [~,min_idx] = min(utility_factor.val);
    D = SetValueOfAssignment(D,max_idx,1);
    D = SetValueOfAssignment(D,min_idx,0);

% case when decision node has no children    
else
    for i=1:step_size:n_decisions
        % get assignment of current decision scenario without decision node D
        % itself
        curr_assignment = IndexToAssignment(i,D.card);
        disp("current assignment")
        disp(curr_assignment)
        rel_curr_assignment = curr_assignment(idx_not_D_var);
        
        % find indices of rows where curr_assignment is contained
        rel_idxs = find(ismember(rel_assignments, rel_curr_assignment,'rows') == 1);
        disp("relevant rows this time")
        disp(rel_idxs)
        
        % get competing assignments in utility factor
        competing_assignments = IndexToAssignment(rel_idxs,utility_factor.card);
        disp("competing assignments this time")
        disp(competing_assignments)
        % get competing values in utility factor
        competing_utilities = GetValueOfAssignment(utility_factor,competing_assignments);
        disp("competing utilities this time")
        disp(competing_utilities)
        
        % select winning assignemnt and its value
        [winner_utility, idx_winner] = max(competing_utilities);
        disp("winner utility")
        disp(winner_utility)
        
        % assignment of decision i
        winning_assignment = competing_assignments(idx_winner,:);
        disp("winning_assignment")
        disp(winning_assignment)
        loosing_assigments = competing_assignments;
        loosing_assigments(idx_winner,:) = [];
        disp("loosing_assignments")
        disp(loosing_assigments)
        
        % update decisions for this scenario decision
        D = SetValueOfAssignment(D,winning_assignment,1);
        D = SetValueOfAssignment(D,loosing_assigments,0);
        
    end
end    


OptimalDecisionRule = D;
% Factor.val entries have dim: 1xN, therfore use x*y'
MEU = OptimalDecisionRule.val * utility_factor.val';    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
%
% A decision rule for D assigns, for each joint assignment to D's parents,
% probability 1 to the best option from the EUF for that joint assignment
% to D's parents, and 0 otherwise.  Note that when D has no parents, it is
% a degenerate case we can handle separately for convenience.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
