% Copyright (C) Daphne Koller, Stanford University, 2012

function EUF = CalculateExpectedUtilityFactor( I )

% Inputs: An influence diagram I with a single decision node and a single utility node.
%         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
%              the child variable = D.var(1)
%         I.DecisionFactors = factor for the decision node.
%         I.UtilityFactors = list of factors representing conditional utilities.
% Return value: A factor over the scope of the decision rule D from I that
% gives the conditional utility given each assignment for D.var
%
% Note - We assume I has a single decision node and utility node.
EUF = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE...
% In this function, we assume there is only one utility node.
U = I.UtilityFactors(1);
% factors which make up the bayes net (i.e. RVs)
F = [I.RandomFactors, U];


% variables we would like to keep (i.e. scope of decision rule D and parents of D)
vars_decision_scope = I.DecisionFactors.var;

% all variables in graph
vars_all_graph = unique([F(:).var]);

% variables we need to eliminiate
elimination_vars = setdiff(vars_all_graph, vars_decision_scope);

% perform variables elimination
if ~isempty(elimination_vars)
    Fnew = VariableElimination(F,elimination_vars);
else
    Fnew=F;
end    

% count factors in Fnew
count_Factors = length(Fnew);

% finally get utility factor as product of all factors
EUF = Fnew(1);
% repeated used of FactorProduct() helper function
if count_Factors > 1
    for numFactors = 2:count_Factors
        EUF = FactorProduct(EUF,Fnew(numFactors));
    end
end    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



end
