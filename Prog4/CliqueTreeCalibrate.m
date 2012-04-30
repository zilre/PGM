%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for 
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P 
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function 
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CliqueTreeCalibrate(P, isMax)


% Number of cliques in the tree.
N = length(P.cliqueList);

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j. 
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We have split the coding part for this function in two chunks with
% specific comments. This will make implementation much easier.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %leave nodes are ready to pass messages immediately!
 %leaves are rows with sum == 1
 for row=1:N
     rowsum=sum(P.edges(row,:));
     if rowsum == 1
        leafnode=find(P.edges(row,:) );
        %display ([row,leafnode]);
        marginalize=setdiff(P.cliqueList(row).var, P.cliqueList(leafnode).var);
        sepset=intersect(P.cliqueList(row).var, P.cliqueList(leafnode).var);
        %display([sepset, marginalize]);
        MESSAGES(row,leafnode)=FactorMarginalization(P.cliqueList(row),marginalize);
        if sum( MESSAGES(row,leafnode).val ) ~=1
            MESSAGES(row,leafnode).val= MESSAGES(row,leafnode).val  /  sum( MESSAGES(row,leafnode).val);
        end
        %display([ MESSAGES(row,leafnode) ]);
        
     end
     
 end

 MESSAGES;

 
 while (1)
    %this is the next message factor, the message from cliqueNode i to
    %cliqueNode j
    [i,j]=GetNextCliques(P, MESSAGES); 
    %no more messages to pass
    if sum ( [i,j] == 0 )
        break
    end
    
    %get the variabls to marginalize over
    marginalize=setdiff(P.cliqueList(i).var, P.cliqueList(j).var);
    %get the sepset variabel
    sepset=intersect(P.cliqueList(i).var, P.cliqueList(j).var);
    
    %display([i,j]);
    %display(sepset);
    %display(marginalize);
    
    %find all the in-coming neighbors messages, except j
    Nbs=find(P.edges(:,i));
    Nbs=Nbs(find(Nbs~=j));
    %display(Nbs);
    %these are the  neighbor factors
    Nbsfactors=MESSAGES(Nbs,i);
    %we compute the product
    if length(Nbsfactors) == 1
        identityF=struct('var', Nbsfactors(1).var, 'card', Nbsfactors(1).card, 'val', ones(1,prod(Nbsfactors(1).card)) );
        Nbsproduct=FactorProduct(identityF, Nbsfactors(1));
    else
        Nbsproduct=ComputeJointDistribution( Nbsfactors );
    end
    
    %multiply them by the clique factor
    CliqueNbsProduct= FactorProduct(Nbsproduct, P.cliqueList(i) );
    %marginalize to get a message factor over the sepset
    %and normailze for good measure
    CliqueMarginal=FactorMarginalization ( CliqueNbsProduct,marginalize );
    CliqueMarginal.val= CliqueMarginal.val  /  sum( CliqueMarginal.val);
    %set the value of the message factor from i to j
    MESSAGES(i,j)=CliqueMarginal;
    
end

%now after doing a single pass of sum product message passing
%compute the final beliefs


  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Now the clique tree has been calibrated. 
% Compute the final potentials for the cliques and place them in P.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(P.cliqueList)
    P.edges(:,i);
    Nbs=find(P.edges(:,i));
    %display(i);
    
    Nbsfactors=MESSAGES(Nbs,i);
    if length(Nbsfactors) == 1
        identityF=struct('var', Nbsfactors(1).var, 'card', Nbsfactors(1).card, 'val', ones(1,prod(Nbsfactors(1).card)) );
        Nbsproduct=FactorProduct(identityF, Nbsfactors(1));
    else
        Nbsproduct=ComputeJointDistribution( Nbsfactors );
    end
    CliqueNbsProduct= FactorProduct(Nbsproduct, P.cliqueList(i) );
    P.cliqueList(i).val=CliqueNbsProduct.val;
        
end


return;
