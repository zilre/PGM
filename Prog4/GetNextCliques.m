%GETNEXTCLIQUES Find a pair of cliques ready for message passing
%   [i, j] = GETNEXTCLIQUES(P, messages) finds ready cliques in a given
%   clique tree, P, and a matrix of current messages. Returns indices i and j
%   such that clique i is ready to transmit a message to clique j.
%
%   We are doing clique tree message passing, so
%   do not return (i,j) if clique i has already passed a message to clique j.
%
%	 messages is a n x n matrix of passed messages, where messages(i,j)
% 	 represents the message going from clique i to clique j. 
%   This matrix is initialized in CliqueTreeCalibrate as such:
%      MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);
%
%   If more than one message is ready to be transmitted, return 
%   the pair (i,j) that is numerically smallest. If you use an outer
%   for loop over i and an inner for loop over j, breaking when you find a 
%   ready pair of cliques, you will get the right answer.
%
%   If no such cliques exist, returns i = j = 0.
%
%   See also CLIQUETREECALIBRATE
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function [i, j] = GetNextCliques(P, messages)

% initialization
% you should set them to the correct values in your code
i = 0;
j = 0;

[nrow,ncol]=size(P.edges);

for r=1:nrow
    rowvector=P.edges(r,:);
    if sum(rowvector) == 1
        continue
    end
    
    foundmatch=0;
    
    for c=1:ncol
        if P.edges(r,c) ==1 && isempty(messages(r,c).var) ==1 % if there is an edge betwn r & c, and it hasn't sent a msg already
            %display ([r,c])
            %now check if all r's neighbors (execpt j) have sent their
            %messages to r
            Nbs=find(P.edges(:,r)); %column vector of r's neighbors
            Nbs=Nbs(find(Nbs~=c));  %find the index of all of r's neighbors except c
            %Nbs
            allnbmp=1; %neighbors messages passed?
            for z=1:length(Nbs)     %find all of r's neighbors have sent messages *to* r
                if isempty( messages(Nbs(z),r).var ) == 1
                    allnbmp=0;
                end
            end
           if allnbmp == 1
                foundmatch=1;
                break;
           end
        end%close if P.edges(r,c) ==1 && isempty(messages(r,c).var) 
    end%closes forc=1:ncol
    if foundmatch==1
        i=r;
        j=c;
        break;
    end
end%closes  for r=1:nrow
return;