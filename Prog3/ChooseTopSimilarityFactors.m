function factors = ChooseTopSimilarityFactors (allFactors, F)
% This function chooses the similarity factors with the highest similarity
% out of all the possibilities.
%
% Input:
%   allFactors: An array of all the similarity factors.
%   F: The number of factors to select.
%
% Output:
%   factors: The F factors out of allFactors for which the similarity score
%     is highest.
%
% Hint: Recall that the similarity score for two images will be in every
%   factor table entry (for those two images' factor) where they are
%   assigned the same character value.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

% If there are fewer than F factors total, just return all of them.
if (length(allFactors) <= F)
    factors = allFactors;
    return;
end

% Your code here:
%factors = allFactors; %%% REMOVE THIS LINE

n=length(allFactors);
topfactors=ones(n,2);
for i=1:n
    topfactors(i,1)= max(allFactors(i).val);
    topfactors(i,2)=i;
    
end


%[B, indx] =sort(L, 'descend') is also worth your attention. It yields a
%sorted list and the indices of each element in the original list.
[B, indx]=sort(topfactors, 'descend');



for j=1:F
    factors(j)=allFactors( indx(j) );
end


end

