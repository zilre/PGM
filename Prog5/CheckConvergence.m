% CHECKCONVERGENCE Ascertain whether the messages indicate that we have converged
%   converged = CHECKCONVERGENCE(MNEW,MOLD) compares lists of messages MNEW
%   and MOLD.  If the values listed in any message differs by more than the 
%   value 'thresh' then we determine that convergence has not occured and 
%   return converged=0, otherwise we have converged and converged=1
%
%   The 'message' data structure is an array of structs with the following 3 fields:
%     -.var:  the variables covered in this message
%     -.card: the cardinalities of those variables
%     -.val:  the value of the message w.r.t. the message's variables
%
%   MNEW and MOLD are the message where M(i,j).val gives the values associated
%   with the message from cluster i to cluster j.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

%call the function as CheckConvergence(exampleINPUT.t3a1{1}, exampleINPUT.t3a1{2}) with the test
%input

function converged = CheckConvergence(mNew, mOld);
converged = true;
thresh = 1.0e-6;
%converged should be 1 if converged, 0 otherwise.

[nrow ncol] = size(mNew);

for i=1:nrow
    for j=1:ncol
        if sum( abs(mNew(i,j).val-mOld(i,j).val) > thresh ) ~=0
            converged=false;
        end
        
    end
end



return;
