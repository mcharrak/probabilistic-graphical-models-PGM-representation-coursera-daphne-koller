% Copyright (C) Daphne Koller, Stanford University, 2012

function EU = SimpleCalcExpectedUtility(I)

% Inputs: An influence diagram, I (as described in the writeup).
%         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
%              the child variable = D.var(1)
%         I.DecisionFactors = factor for the decision node.
%         I.UtilityFactors = list of factors representing conditional utilities.
% Return Value: the expected utility of I
% Given a fully instantiated influence diagram with a single utility node and decision node,
% calculate and return the expected utility.  Note - assumes that the decision rule for the
% decision node is fully assigned.

% In this function, we assume there is only one utility node.
F = [I.RandomFactors I.DecisionFactors];
U = I.UtilityFactors(1);

% decision var is by convention the first variable in DecisionFactors
decision_var = I.DecisionFactors(1).var;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% variables we we wish to keep in marginal prob. dist.
vars_utility_parents = U.var;
% all variables in graph
vars_all_graph = unique([F(:).var]);

% variables we need to eliminiate
elimination_vars = setdiff(vars_all_graph, vars_utility_parents);

% perform variables elimination
if ~isempty(elimination_vars)
    Fnew = VariableElimination(F,elimination_vars);
else
    Fnew=F;
end    

% count factors in Fnew
count_Factors = length(Fnew);

% get final joint distribution over U's parents
joint_temp = Fnew(1);
% repeated used of FactorProduct() helper function
if count_Factors > 1
    for numFactors = 2:count_Factors
        joint_temp = FactorProduct(joint_temp,Fnew(numFactors));
    end
end    
    
joint = joint_temp; 

% final factor product of joint and utility U
prod = FactorProduct(joint,U);

EU = sum(prod.val);

end
