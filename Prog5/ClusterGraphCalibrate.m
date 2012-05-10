% CLUSTERGRAPHCALIBRATE Loopy belief propagation for cluster graph calibration.
%   P = CLUSTERGRAPHCALIBRATE(P, useSmart) calibrates a given cluster graph, G,
%   and set of of factors, F. The function returns the final potentials for
%   each cluster. 
%   The cluster graph data structure has the following fields:
%   - .clusterList: a list of the cluster beliefs in this graph. These entries
%                   have the following subfields:
%     - .var:  indices of variables in the specified cluster
%     - .card: cardinality of variables in the specified cluster
%     - .val:  the cluster's beliefs about these variables
%   - .edges: A cluster adjacency matrix where edges(i,j)=1 implies clusters i
%             and j share an edge.
%  
%   UseSmart is an indicator variable that tells us whether to use the Naive or Smart
%   implementation of GetNextClusters for our message ordering
%
%   See also FACTORPRODUCT, FACTORMARGINALIZATION
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function [P MESSAGES] = ClusterGraphCalibrate(P,useSmartMP)

if(~exist('useSmartMP','var'))
  useSmartMP = 0;
end

N = length(P.clusterList);

MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);
[edgeFromIndx, edgeToIndx] = find(P.edges ~= 0);

for m = 1:length(edgeFromIndx),
    i = edgeFromIndx(m);
    j = edgeToIndx(m);

    
    % Set the initial message values
    % MESSAGES(i,j) should be set to the initial value for the
    % message from cluster i to cluster j
    %
    % The matlab/octave functions 'intersect' and 'find' may
    % be useful here (for making your code faster)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sepset=intersect(P.clusterList(i).var, P.clusterList(j).var);
    marginalize=setdiff(P.clusterList(i).var, P.clusterList(j).var);
    factorM=FactorMarginalization(P.clusterList(i), marginalize);
    factorM.val=ones(1:prod(factorM.card));
    MESSAGES(i,j)=factorM;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end;



% perform loopy belief propagation
tic;
iteration = 0;

lastMESSAGES = MESSAGES;

while (1),
    iteration = iteration + 1;
    [i, j] = GetNextClusters(P, MESSAGES,lastMESSAGES, iteration, useSmartMP); 
    prevMessage = MESSAGES(i,j);
    %display([i, j]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    % We have already selected a message to pass, \delta_ij.
    % Compute the message from clique i to clique j and put it
    % in MESSAGES(i,j)
    % Finally, normalize the message to prevent overflow
    %
    % The function 'setdiff' may be useful to help you
    % obtain some speedup in this function
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %get the variabls to marginalize over
    marginalize=setdiff(P.clusterList(i).var, P.clusterList(j).var);
    %get the sepset variabel
    sepset=intersect(P.clusterList(i).var, P.clusterList(j).var);
    
    %find all the in-coming neighbors messages, except j
    Nbs=find(P.edges(:,i));
    Nbs=Nbs(find(Nbs~=j));
    
    Nbsfactors=MESSAGES(Nbs,i);
    if (length(Nbsfactors) == 0)
	% There are no factors, so create an empty factor list
        jointNbsFactor = struct('var', [], 'card', [], 'val', []);
    else
        jointNbsFactor = Nbsfactors(1);
        for z = 2:length(Nbsfactors)
            % Iterate through factors and incorporate them into the joint distribution
            jointNbsFactor = FactorProduct(jointNbsFactor, Nbsfactors(z));
        end
    end
    %multiply them by the clique factor
    CliqueNbsProduct= FactorProduct(jointNbsFactor, P.clusterList(i) );
    
    %marginalize out variables not in sepst between cluster nodes i and j
    CliqueMarginal=FactorMarginalization ( CliqueNbsProduct,marginalize );
    %normalize
    CliqueMarginal.val= CliqueMarginal.val  /  sum( CliqueMarginal.val);
    MESSAGES(i,j)=CliqueMarginal;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if(useSmartMP==1)
      lastMESSAGES(i,j)=prevMessage;
    end
    
    % Check for convergence every m iterations
    if mod(iteration, length(edgeFromIndx)) == 0
        if (CheckConvergence(MESSAGES, lastMESSAGES))
            break;
        end
        disp(['LBP Messages Passed: ', int2str(iteration), '...']);
        if(useSmartMP~=1)
          lastMESSAGES=MESSAGES;
        end
    end
    
end;
toc;
disp(['Total number of messages passed: ', num2str(iteration)]);


% Compute final potentials and place them in P
for m = 1:length(edgeFromIndx),
    j = edgeFromIndx(m);
    i = edgeToIndx(m);
    P.clusterList(i) = FactorProduct(P.clusterList(i), MESSAGES(j, i));
end


% Get the max difference between the marginal entries of 2 messages -------
function delta = MessageDelta(Mes1, Mes2)
delta = max(abs(Mes1.val - Mes2.val));
return;


