

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
%   factor) -- Note that both copies of each gene are from the same person,
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

% Pr(phenotypeVar | genotypeVar(s)
phenotypeFactor.var=[phenotypeVar, geneCopyVarOneList', geneCopyVarTwoList'];

% Fill in phenotypeFactor.card.  This should be a 1-D row vector.
[nrow, numAlleles1]=size(alleleWeights{1});
[nrow, numAlleles2]=size(alleleWeights{1});
[nrow, numGenes]= size(geneCopyVarOneList');

phenotypeFactor.card=[2, numAlleles1, numAlleles1, numAlleles2, numAlleles2 ];

phenotypeFactor.val = zeros(1, prod(phenotypeFactor.card));
% Replace the zeros in phentoypeFactor.val with the correct values.

for k=1:prod(phenotypeFactor.card)
    assignments=IndexToAssignment(k, phenotypeFactor.card);
    
    values=[];
    for j=1:numGenes
        [row, numAlleles]=size(alleleWeights{j});
        jgenes=[assignments(j+1), assignments(j+3)]; % get the jth gene for parent1 and parent2
        X_j=0;
        Y_j=0;
        for i=1:numAlleles
            if jgenes(1) == i
                X_j=1;
            else
                X_j=0;
            end
            if jgenes(2) == i
                Y_j=1;
            else
                Y_j=0;
            end
            values(j,i)=alleleWeights{j}(i)*(X_j+Y_j);
        end
    values;
    sigmoid=exp(1)^sum(sum(values')) / (1 + exp(1)^sum(sum(values')) );
    if assignments(1) == 1
        phenotypeFactor.val(k)=exp(1)^sum(sum(values')) / (1 + exp(1)^sum(sum(values')) );
    else
        phenotypeFactor.val(k)= 1 - ( exp(1)^sum(sum(values')) / (1 + exp(1)^sum(sum(values')) ) );
    end
end %end 1:prod(phenotypeFactor.card

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%