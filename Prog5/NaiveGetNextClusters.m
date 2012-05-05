%NAIVEGETNEXTCLUSTERS Takes in a node adjacency matrix and returns the indices
%   of the nodes between which the m+1th message should be passed.
%
%   Output [i j]
%     i = the origin of the m+1th message
%     j = the destination of the m+1th message
%
%   This method should iterate over the messages in increasing order where
%   messages are sorted in ascending ordered by their destination index and 
%   ties are broken based on the origin index. (note: this differs from PA4's
%   ordering)
%
%   Thus, if m is 0, [i j] will be the pair of clusters with the lowest j value
%   and (of those pairs over this j) lowest i value as this is the 'first'
%   element in our ordering. (this difference is because matlab is 1-indexed)
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function [i, j] = NaiveGetNextClusters(P, m)

    i = size(P.clusterList,1);
    j = size(P.clusterList,1);
    
    [nrows,ncols]=size(P.edges);
    
    % this represents the number of edges [i,j] [j,i]
    iNumEdges =  sum (P.edges(:));
    
    if m > iNumEdges
          m = mod (m, iNumEdges);
    end
    
    display(m);
    total=0;
    for k=1:ncols
        %display(k);
        candidates=find(P.edges(:,k));
        display([candidates]);
        total=total+length(candidates);
        %display(total);
        if (m) < total
            display(k);
            display(candidates);
            display(total);
            display(m)
            idx=(total-m);
            display(idx);
            j=k;
            i=candidates(idx);
            return;
        end
        
            
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    % Find the indices between which to pass a cluster
    % The 'find' function may be useful
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

