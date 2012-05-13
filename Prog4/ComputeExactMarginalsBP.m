%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1). 
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the 
%   network where M(i) represents the ith variable and M(i).val represents 
%   the marginals of the ith variable. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function M = ComputeExactMarginalsBP(F, E, isMax)

% initialization
% you should set it to the correct value in your code
M = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Implement Exact and MAP Inference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%create the clique tree and calibrate it
P=CreateCliqueTree(F,E);
P=CliqueTreeCalibrate(P,isMax);



%now get the variables in the clique tree
V = unique([F(:).var]);

%now iterate thru the variables
for i = 1 : length(V),
    %now iterater thru teh cliques in the calibrated tree
    for j = 1 : length(P.cliqueList)
        if (~isempty(find(P.cliqueList(j).var == i)))
            marginalize=setdiff(P.cliqueList(j).var, i);
            if isempty(marginalize)
                M{i}=P.cliqueList(j); %do we need to normalize? 
            else
                if isMax == 0
                    %we do sum-product
                    mfactor=FactorMarginalization(P.cliqueList(j), marginalize);
                    mfactor.val=mfactor.val/sum(mfactor.val);
                    M{i}=mfactor;
                else
                    %we do max-sum
                    mfactor=FactorMaxMarginalization(P.cliqueList(j),marginalize);
                    M{i}=mfactor;
                end
            end
            break;
        end
    end 
end

M=[M{1:end}];
end


