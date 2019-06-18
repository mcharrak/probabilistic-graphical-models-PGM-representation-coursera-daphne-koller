function genotypeFactor = genotypeGivenParentsGenotypesFactor(numAlleles, genotypeVarChild, genotypeVarParentOne, genotypeVarParentTwo)
% This function computes a factor representing the CPD for the genotype of
% a child given the parents' genotypes.

% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES

% When writing this function, make sure to consider all possible genotypes 
% from both parents and all possible genotypes for the child.

% Input:
%   numAlleles: int that is the number of alleles
%   genotypeVarChild: Variable number corresponding to the variable for the
%   child's genotype (goes in the .var part of the factor)
%   genotypeVarParentOne: Variable number corresponding to the variable for
%   the first parent's genotype (goes in the .var part of the factor)
%   genotypeVarParentTwo: Variable number corresponding to the variable for
%   the second parent's genotype (goes in the .var part of the factor)
%
% Output:
%   genotypeFactor: Factor in which val is probability of the child having 
%   each genotype (note that this is the FULL CPD with no evidence 
%   observed)

% The number of genotypes is (number of alleles choose 2) + number of 
% alleles -- need to add number of alleles at the end to account for homozygotes

genotypeFactor = struct('var', [], 'card', [], 'val', []);

% Each allele has an ID.  Each genotype also has an ID.  We need allele and
% genotype IDs so that we know what genotype and alleles correspond to each
% probability in the .val part of the factor.  For example, the first entry
% in .val corresponds to the probability of having the genotype with
% genotype ID 1, which consists of having two copies of the allele with
% allele ID 1, given that both parents also have the genotype with genotype
% ID 1.  There is a mapping from a pair of allele IDs to genotype IDs and 
% from genotype IDs to a pair of allele IDs below; we compute this mapping 
% using generateAlleleGenotypeMappers(numAlleles). (A genotype consists of 
% 2 alleles.)

[allelesToGenotypes, genotypesToAlleles] = generateAlleleGenotypeMappers(numAlleles);

% One or both of these matrices might be useful.
%
%   1.  allelesToGenotypes: n x n matrix that maps pairs of allele IDs to 
%   genotype IDs, where n is the number of alleles -- if 
%   allelesToGenotypes(i, j) = k, then the genotype with ID k comprises of 
%   the alleles with IDs i and j
%
%   2.  genotypesToAlleles: m x 2 matrix of allele IDs, where m is the 
%   number of genotypes -- if genotypesToAlleles(k, :) = [i, j], then the 
%   genotype with ID k is comprised of the allele with ID i and the allele 
%   with ID j

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INSERT YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Fill in genotypeFactor.var.  This should be a 1-D row vector.
genotypeFactor.var = [genotypeVarChild, genotypeVarParentOne, genotypeVarParentTwo];
% Fill in genotypeFactor.card.  This should be a 1-D row vector.
% cardinality of genotypes (i.e. number of genotypes)
card_genotype = nchoosek(numAlleles,2) + numAlleles;
genotypeFactor.card = [card_genotype,card_genotype,card_genotype];

genotypeFactor.val = zeros(1, prod(genotypeFactor.card));
% Replace the zeros in genotypeFactor.val with the correct values.

% Fetch table of assignments of X1,X2,X3
assignments = IndexToAssignment(1:prod(genotypeFactor.card),genotypeFactor.card);
for i = 1:length(assignments)
    
    % step 0: assignements of X1,X2,X3
    curr_assignment = assignments(i,:);
%    disp(curr_assignment);
    X3 = curr_assignment(1);
    X1 = curr_assignment(2);    
    X2 = curr_assignment(3);
    
    % step 1: convert genotype assignments of X1, X2 into alleles
    alleles_X1 = genotypesToAlleles(X1,:); 
    alleles_X2 = genotypesToAlleles(X2,:);
    
    % step 2: cartesian product of alleles_X1 and alleles_X1
    % transpose because combvec returns 2x4 (but we need 4x2)
    alleles_combs = combvec(alleles_X1,alleles_X2)';
    
    % step 3: convert cartesian product result back into genotypes
    % convert vector of index pairs into linear indices to access 2D array
    % values with scalar indices instead of tuples -> removes looping
    LinIdx = sub2ind(size(allelesToGenotypes), alleles_combs(:,1), alleles_combs(:,2));
    genotypes = allelesToGenotypes(LinIdx);
    
    % step 4: compare how many entries correspond to assignment of X3 in
    % order to calculate probability of the i-th entry
    X3_counts = sum(genotypes == X3);
    prob_i = X3_counts/length(genotypes);
    
    % step 5: set value of current row to prob_i
    genotypeFactor = SetValueOfAssignment(genotypeFactor,curr_assignment,prob_i);    
end    
 
end    
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%