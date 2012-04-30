%COMPUTEINITIALPOTENTIALS Sets up the cliques in the clique tree that is
%passed in as a parameter.
%
%   P = COMPUTEINITIALPOTENTIALS(C) Takes the clique tree skeleton C which is a
%   struct with three fields:
%   - nodes: cell array representing the cliques in the tree.
%   - edges: represents the adjacency matrix of the tree.
%   - factorList: represents the list of factors that were used to build
%   the tree. 
%   
%   It returns the standard form of a clique tree P that we will use through 
%   the rest of the assigment. P is struct with two fields:
%   - cliqueList: represents an array of cliques with appropriate factors 
%   from factorList assigned to each clique. Where the .val of each clique
%   is initialized to the initial potential of that clique.
%   - edges: represents the adjacency matrix of the tree. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function P = ComputeInitialPotentials(C)

% number of cliques
N = length(C.nodes);

% initialize cluster potentials 
P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
P.edges = zeros(N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% First, compute an assignment of factors from factorList to cliques. 
% Then use that assignment to initialize the cliques in cliqueList to 
% their initial potentials. 

% C.nodes is a list of cliques.
% So in your code, you should start with: P.cliqueList(i).var = C.nodes{i};
% Print out C to get a better understanding of its structure.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%assign 

%display(C)
%N

factorused=zeros(1,length(C.factorList));  
for i=1:N
    P.cliqueList(i).var=C.nodes{i};
    P.cliqueList(i);
    
    %figure out which factors get assigned to a clique, based on the
    %variable scoe of the node in the clique tree
    F=cell(0);
    k=1;
   
    for j=1:length(C.factorList)
        
        %if length(intersect(A,B))
        %need to figure out how to fix this - putting in empty factor
        %structs
        if length(C.factorList(j).var) == length( intersect( P.cliqueList(i).var, C.factorList(j).var ) )
            if factorused(j) == 0
                F{k}=C.factorList(j);
                k=k+1;
                factorused(j)=1;
                %how do I ensure a factor is used only once when assigning
                %which factors go info a clique node?
            end%close factorused
        
        end%close intersect 
    
    end%close for loop iterating thru factor list
    
    %F should now contain the factors assigned to the clique node
    %now need to compute their product
    
    if length(F) > 1
        P.cliqueList(i)=ComputeJointDistribution( [F{1,:}] );
    elseif length(F)  == 1
        identityF=struct('var', F{1}.var, 'card', F{1}.card, 'val', ones(1,prod(F{1}.card)) );
        P.cliqueList(i)=FactorProduct(identityF, F{1});
    else
        continue
    end
    %P.cliqueList(i)=ComputeJointDistribution(factors);
    
end%close for loop itnerating through cliqueNodes

P.edges=C.edges;


%now n

end

