function phenotypeFactor = phenotypeGivenCopiesFactor(alphaList, numAlleles, geneCopyVarOne, geneCopyVarTwo, phenotypeVar)
% This function makes a factor whose values are the probabilities of 
% a phenotype given an allele combination.  Note that a person has one
% copy of the gene from each parent.

% In the factor, each assignment maps to the allele at the corresponding
% location on the allele list, so allele assignment 1 maps to
% alleleList{1}, allele assignment 2 maps to alleleList{2}, ....  For the
% phenotypes, assignment 1 maps to having the physical trait, and
% assignment 2 maps to not having the physical trait.

% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES

% Input:
%   alphaList: m x 1 vector of alpha values for the different genotypes,
%   where m is the number of genotypes -- the alpha value for a genotype
%   is the probability that a person with that genotype will have the
%   physical trait

%   numAlleles: int that is the number of alleles

%   geneCopyVarOne: Variable number corresponding to the variable for
%   the first copy of the gene (goes in the .var part of the factor)
%   geneCopyVarTwo: Variable number corresponding to the variable for
%   the second copy of the gene (goes in the .var part of the factor)
%   phenotypeVar: Variable number corresponding to the variable for the 
%   phenotype (goes in the .var part of the factor)

%
% Output:
%   phenotypeFactor: Factor in which the values are the probabilities of 
%   having each phenotype for each allele combination (note that this is 
%   the FULL CPD with no evidence observed)

phenotypeFactor = struct('var', [], 'card', [], 'val', []);

% Each allele has an ID. Each genotype also has an ID, which is the index 
% of its alpha in the list of alphas.  There is a mapping from a pair of 
% allele IDs to genotype IDs and from genotype IDs to a pair of allele IDs 
% below; we compute this mapping using 
% generateAlleleGenotypeMappers(numAlleles). (A genotype consists of 2 
% alleles.)

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
% The number of phenotypes is 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Fill in phenotypeFactor.var.  This should be a 1-D row vector.
phenotypeFactor.var = [phenotypeVar, geneCopyVarOne, geneCopyVarTwo];
% Fill in phenotypeFactor.card.  This should be a 1-D row vector.
% cardinality of alleles (i.e. number of alleles)
card_alleles = numAlleles;
% as always either we have trait or not (-> cardinality of 2)
card_phenotype = 2;
phenotypeFactor.card = [card_phenotype, card_alleles, card_alleles];

phenotypeFactor.val = zeros(1, prod(phenotypeFactor.card));
% Replace the zeros in phentoypeFactor.val with the correct values.

%%% NOW CALCUALTE p(child phenotype | allele mother , allele father) %%%

assignments = IndexToAssignment(1:prod(phenotypeFactor.card),phenotypeFactor.card);

for i = 1:length(assignments)
    curr_assignment = assignments(i,:);
    alleles = curr_assignment(2:end);
    genotype = allelesToGenotypes(alleles(1),alleles(2));
    prob_i = alphaList(genotype);
    % cases either X3=1 'has trait' // or X3=2 'has no trait'
    curr_X3 = curr_assignment(1);
    if curr_X3 == 1 % means has trait
        phenotypeFactor = SetValueOfAssignment(phenotypeFactor,curr_assignment,prob_i); 
%        phenotypeFactor.val(i) = prob_i;
    else % else person has no trait
        prob_i = 1 - prob_i;
        phenotypeFactor = SetValueOfAssignment(phenotypeFactor,curr_assignment,prob_i);
%        phenotypeFactor.val(i) = prob_i;
    end 
end    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%