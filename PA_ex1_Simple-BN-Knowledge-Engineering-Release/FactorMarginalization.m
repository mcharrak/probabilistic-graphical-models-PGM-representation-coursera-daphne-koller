% FactorMarginalization Sums given variables out of a factor.
%   B = FactorMarginalization(A,V) computes the factor with the variables
%   in V summed out. The factor data structure has the following fields:
%       .var    Vector of variables in the factor, e.g. [1 2 3]
%       .card   Vector of cardinalities corresponding to .var, e.g. [2 2 2]
%       .val    Value table of size prod(.card)
%
%   The resultant factor should have at least one variable remaining or this
%   function will throw an error.
% 
%   See also FactorProduct.m, IndexToAssignment.m, and AssignmentToIndex.m

function B = FactorMarginalization(A, V)

% Check for empty factor or variable list
if (isempty(A.var) || isempty(V)), B = A; return; end;

% Construct the output factor over A.var \ V (the variables in A.var that are not in V)
% and mapping between variables in A and B
% B.var will be the remaining variable after marginalization
% mapB is the index (within B.var) of the remaining variable
% e.g. A.var = [2,1] V = [2] then B.var = [1] and Bmap = [2]
[B.var, mapB] = setdiff(A.var, V);

% Check for empty resultant factor
if isempty(B.var)
  error('Error: Resultant factor has empty scope');
end;

% Initialize B.card and B.val
% A.card contains cardinalities of factor A and we only fetch the ones
% which remains in B using the index vector mapB
B.card = A.card(mapB);
% create buffer to hold the new values of factor B, which contains
% prod(B.card) (i.g. for any factor F we have prod(F.card)
% entries/rows/probabiliy values in our table
B.val = zeros(1, prod(B.card));

% Compute some helper indices
% These will be very useful for calculating B.val
% so make sure you understand what these lines are doing
assignments = IndexToAssignment(1:length(A.val), A.card);
indxB = AssignmentToIndex(assignments(:, mapB), B.card);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Correctly populate the factor values of B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(B.val)
    % find rows of remaining var where assignemnts are all i
    idx = find(indxB == i);
    values = A.val(idx);
    B.val(i) = sum(values);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
