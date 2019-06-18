function phenotypeFactor = constructSigmoidPhenotypeFactor(alleleWeights, geneCopyVarOneList, geneCopyVarTwoList, phenotypeVar)
% This function takes a cell array of alleles' weights and constructs a 
% factor expressing a sigmoid CPD.
%
% You can assume that there are only 2 genes involved in the CPD.
%
% In the factor, for each gene, each allele assignment maps to the allele
% whose weight is at the corresponding location.  For example, for gene 1,
% allele assignment 1 maps to the allele whose weight is at
% alleleWeights{1}(1) (same as w_1^1), allele assignment 2 maps to the
% allele whose weight is at alleleWeights{1}(2) (same as w_2^1),....  
% 
% You may assume that there are 2 possible phenotypes.
% For the phenotypes, assignment 1 maps to having the physical trait, and
% assignment 2 maps to not having the physical trait.
%
% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES
%
% Input:
%   alleleWeights: Cell array of weights, where each entry is an 1 x n 
%   of weights for the alleles for a gene (n is the number of alleles for
%   the gene)
%   geneCopyVarOneList: m x 1 vector (m is the number of genes) of variable 
%   numbers that are the variable numbers for each of the first parent's 
%   copy of each gene (numbers in this list go in the .var part of the
%   factor)
%   geneCopyVarTwoList: m x 1 vector (m is the number of genes) of variable 
%   numbers that are the variable numbers for each of the second parent's 
%   copy of each gene (numbers in this list go in the .var part of the
%   factor) 

%   NOTE that both copies of each gene are from the same person,
%   but each copy originally came from a different parent
%   phenotypeVar: Variable number corresponding to the variable for the 
%   phenotype (goes in the .var part of the factor)
%
% Output:
%   phenotypeFactor: Factor in which the values are the probabilities of 
%   having each phenotype for each allele combination (note that this is 
%   the FULL CPD with no evidence observed)

phenotypeFactor = struct('var', [], 'card', [], 'val', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INSERT YOUR CODE HERE
% Note that computeSigmoid.m will be useful for this function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Fill in phenotypeFactor.var.  This should be a 1-D row vector.
% transpose ' because geneCopyVarOneList are nx1 instead of 1xn
phenotypeFactor.var = [phenotypeVar, geneCopyVarOneList', geneCopyVarTwoList'];
% Fill in phenotypeFactor.card.  This should be a 1-D row vector.
card_phenotype = 2;
% length of vector within allelesWeights cell equals number of alleles
numAlleles = length(alleleWeights{1});
card_genotype_copies = numAlleles;
numPhenNodes = 1;
numGeneNodes = length([geneCopyVarOneList',geneCopyVarTwoList']);
phenotypeFactor.card = [card_phenotype, repmat(card_genotype_copies,1,numGeneNodes)];

phenotypeFactor.val = zeros(1, prod(phenotypeFactor.card));
% Replace the zeros in phentoypeFactor.val with the correct values.

% number of parameters of phentotype sigmoid CPD for 1 phenotype (binary) 
% with 4 genes (à 2 alleles)
n_parameters = card_phenotype^(numPhenNodes) * card_genotype_copies^(numGeneNodes);

% fetch variables assignment table
assignments = IndexToAssignment(1:n_parameters,phenotypeFactor.card);

% number of unique genes
n_genes = length(alleleWeights);
% number of genotype copies per parent
%n_genotype_copies = numGeneNodes / n_unique_genes;

for i = 1:n_genes:n_parameters
    
    curr_assignment= assignments(i,:);
    genotype_copy_vars = curr_assignment(2:end);

%     curr_X1 = curr_assignment(1); % var of gene 1 copy 1 (mother)
%     curr_X2 = curr_assignment(2); % var of gene 2 copy 1 (father)
%     curr_X4 = curr_assignment(3); % var of gene 1 copy 2 (mother)
%     curr_X5 = curr_assignment(4); % var of gene 2 copy 2 (father)
    
    weighted_sum = 0;
    % loop over each gene j
    for j = 1: n_genes        
        
        % j=1 -> {1,2} and j=2 -> {3,4}
        allele_idx1 = genotype_copy_vars(j);
        allele_idx2 = genotype_copy_vars(j+2);


        weighted_sum = weighted_sum + alleleWeights{j}(allele_idx1) ...
                        + alleleWeights{j}(allele_idx2);
        
    end
    pos_prob_i = computeSigmoid(weighted_sum);
    neg_prob_i = 1- pos_prob_i;
    phenotypeFactor.val(i) = pos_prob_i;
    phenotypeFactor.val(i+1) = neg_prob_i;    
end 


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%