function phenotypeFactor = phenotypeGivenGenotypeFactor(alphaList, genotypeVar, phenotypeVar)
% This function computes the probability of each phenotype given the 
% different genotypes for a trait. Genotypes (assignments to the genotype
% variable) are indexed from 1 to the number of genotypes, and the alphas
% are provided in the same order as the corresponding genotypes so that the
% alpha for genotype assignment i is alphaList(i).
%
% For the phenotypes, assignment 1 maps to having the physical trait, and 
% assignment 2 maps to not having the physical trait.
%
% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES
%
% Input:
%   alphaList: Vector of alpha values for each genotype (n x 1 vector,
%   where n is the number of genotypes) -- the alpha value for a genotype
%   is the probability that a person with that genotype will have the
%   physical trait 
%   genotypeVar: The variable number for the genotype variable (goes in the
%   .var part of the factor)
%   phenotypeVar: The variable number for the phenotype variable (goes in
%   the .var part of the factor)
%
% Output:
%   phenotypeFactor: Factor in which the val has the probability of having 
%   each phenotype for each genotype combination (note that this is the 
%   FULL CPD with no evidence observed)

phenotypeFactor = struct('var', [], 'card', [], 'val', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INSERT YOUR CODE HERE
% The number of genotypes is the length of alphaList.
% The number of phenotypes is 2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Fill in phenotypeFactor.var.  This should be a 1-D row vector.
phenotypeFactor.var = [phenotypeVar, genotypeVar];
% Fill in phenotypeFactor.card.  This should be a 1-D row vector.
% either person has Tay-Sachs disease or not -> binary
card_phenotype = 2;

% number of alleles for Cystic Fibrosis (CF)
n_allele = 2;

% there are (n over 2) + n different genotypes -> all combinations with
% replacement, order irrelevant expect 
card_genotype = nchoosek(n_allele,2) + n_allele;

phenotypeFactor.card = [card_phenotype, card_genotype];

phenotypeFactor.val = zeros(1, prod(phenotypeFactor.card));
% Replace the zeros in phentoypeFactor.val with the correct values.

% loop over each genotpye i, directly change both values of phenotype
for i = 1:card_genotype
    
    idx_neg = 2*i;
    idx_pos = idx_neg - 1;
    idx_alpha = idx_neg/2;
    
    %fetch assignments
    assignment_neg = IndexToAssignment(idx_neg, phenotypeFactor.card);
    assignment_pos = IndexToAssignment(idx_pos, phenotypeFactor.card);
    % fetch probability for having the trait given genotype i    
    alpha = alphaList(idx_alpha);
    prob_pos_trait = alpha;
    prob_neg_trait = 1 - alpha;
    
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor, assignment_neg, prob_neg_trait);
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor, assignment_pos, prob_pos_trait) ;   
%    phenotypeFactor.val(idx_neg) = prob_neg_trait;
%    phenotypeFactor.val(idx_pos) = prob_pos_trait;
    
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%