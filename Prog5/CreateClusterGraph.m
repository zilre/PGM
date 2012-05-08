%CREATECLUSTERGRAPH Takes in a list of factors and returns a Bethe cluster
%   graph. It also returns an assignment of factors to cliques.
%
%   C = CREATECLUSTERGRAPH(F) Takes a list of factors and creates a Bethe
%   cluster graph with nodes representing single variable clusters and
%   pairwise clusters. The value of the clusters should be initialized to 
%   the initial potential. 
%   It returns a cluster graph that has the following fields:
%   - .clusterList: a list of the cluster beliefs in this graph. These entries
%                   have the following subfields:
%     - .var:  indices of variables in the specified cluster
%     - .card: cardinality of variables in the specified cluster
%     - .val:  the cluster's beliefs about these variables
%   - .edges: A cluster adjacency matrix where edges(i,j)=1 implies clusters i
%             and j share an edge.
%  
%   NOTE: The index of the cluster for each factor should be the same within the
%   clusterList as it is within the initial list of factors.  Thus, the cluster
%   for factor F(i) should be found in P.clusterList(i) 
%
% Copyright (C) Daphne Koller, Stanford University, 2012

% make a Bethe Cluster graph
% see Koller and Friedman 11.3.5.2 pg 405
function P = CreateClusterGraph(F, Evidence)
P.clusterList = [];
P.edges = [];
for j = 1:length(Evidence),
    if (Evidence(j) > 0),
        F = ObserveEvidence(F, [j, Evidence(j)]);
    end;
end;

P.clusterList=F;
P.edges=zeros(length(F), length(F) );

%keep track of what position in cluster list are the univariate clusters
univariateFidx=[];
%keep track of what position in cluster list are the factor clusters
factorLayeridx=[];
for j=1:length(P.clusterList)
    if length(P.clusterList(j).var) == 1
        univariateFidx=[univariateFidx j];
    else
        factorLayeridx=[factorLayeridx j ];
    end
end

%given the node abouve that the factor in F(i) is the same as the one in
%P.cluserList(i) we use the information from the above for loop that kept
%track of the indices of the univarate and non-univariate clusters
%we iterate thru the indixces of where the univariate factors live,
%checking to see which one of the factor clusters contain them
%if its non-empty, initiaize the P.edges to be 1 in the (i,j) and (j,i)
%entry

for j=1:length(univariateFidx)
    uni_idx=univariateFidx(j);
    for k=1:length(factorLayeridx)
        fac_idx=factorLayeridx(k);
        result=find(P.clusterList(fac_idx).var == P.clusterList(uni_idx).var);
        if isempty(result) == 0
            P.edges(uni_idx,fac_idx)=1;
            P.edges(fac_idx, uni_idx)=1;
        end
    end
end


return





