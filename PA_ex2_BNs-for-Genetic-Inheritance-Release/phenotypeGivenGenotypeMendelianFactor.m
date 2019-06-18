function phenotypeFactor = phenotypeGivenGenotypeMendelianFactor(isDominant, genotypeVar, phenotypeVar)
% This function computes the probability of each phenotype given the
% different genotypes for a trait.  It assumes that there is 1 dominant
% allele and 1 recessive allele.
%

% MENDELIAN MODEL: 
% A trait/phenotype is only controlled by a single gene. Each gene consist
% of two alleles one is dominant, the other is Recessive

% If you do not have much background in genetics, you should read the
% on-line Appendix or watch the Khan Academy Introduction to Heredity Video
% (http://www.khanacademy.org/video/introduction-to-heredity?playlist=Biology)
% before you start coding.
%
% For the genotypes, assignment 1 maps to homozygous dominant, assignment 2
% maps to heterozygous, and assignment 3 maps to homozygous recessive.  For
% example, say that there is a gene with two alleles, dominant allele A and
% recessive allele a.  Assignment 1 would map to AA, assignment 2 would
% make to Aa, and assignment 3 would map to aa.  For the phenotypes, 
% assignment 1 maps to having the physical trait, and assignment 2 maps to 
% not having the physical trait.
%
% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES
%
% Input:
%   isDominant: 1 if the trait is caused by the dominant allele (trait 
%   would be caused by A in example above) and 0 if the trait is caused by
%   the recessive allele (trait would be caused by a in the example above)

%   genotypeVar: The variable number for the genotype variable (goes in the
%   .var part of the factor)

%   phenotypeVar: The variable number for the phenotype variable (goes in
%   the .var part of the factor)
%
% Output:
%   phenotypeFactor: Factor denoting the probability of having each 
%   phenotype for each genotype

phenotypeFactor = struct('var', [], 'card', [], 'val', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INSERT YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


% Fill in phenotypeFactor.var.  This should be a 1-D row vector.
phenotypeFactor.var = [phenotypeVar, genotypeVar];

% Fill in phenotypeFactor.card.  This should be a 1-D row vector.

% either person has Tay-Sachs disease or not -> binary
card_phenotype = 2;

% number of alleles in Medelian model is 2
n_allele = 2;

% there are (n over 2) + n different genotypes -> all combinations with
% replacement, order irrelevant expect 
card_genotype = nchoosek(n_allele,2) + n_allele;

phenotypeFactor.card = [card_phenotype, card_genotype];

phenotypeFactor.val = zeros(1, prod(phenotypeFactor.card));
% Replace the zeros in phentoypeFactor.val with the correct values.

  % for X1 we have : 1 is homozygous dominant, 2 is heterozygous, 3 is homozygous recessive.
  % for X3 we have : 1 is does have phenotype, 2 does not have phenotype.

% X1 = 1 means: TT homozygous dominant
% X1 = 2 means: Tt (or tT, this is ambiguous) heterozygous
% X1 = 3 means: tt homozygous recessive

% X3 = 1 means: has disease/trait
% X3 = 2 means: has no-disease/no-trait

% fetch assignments
A = IndexToAssignment(1:prod(phenotypeFactor.card),phenotypeFactor.card);
V = [1, 0, 1, 0, 0, 1];

if isDominant
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor, A, V);
else
    % convert logical vector into type vector
    V_not = double(not(V));
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor, A, V_not);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
