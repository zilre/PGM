% this is the sum/product algorithm!
P=GetNextC.INPUT1;
messages=GetNextC.INPUT2;
while (1)
    %this is the next message factor, the message from cliqueNode i to
    %cliqueNode j
    [i,j]=GetNextCliques(P, messages); 
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
    Nbsfactors=messages(Nbs,i);
    %we compute the product
    if length(Nbsproduct) == 1
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
    messages(i,j)=CliqueMarginal;
    
end