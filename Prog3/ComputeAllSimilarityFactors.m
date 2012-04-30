function factors = ComputeAllSimilarityFactors (images, K)
% This function computes all of the similarity factors for the images in
% one word.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word.
%   K: The alphabet size (accessible in imageModel.K for the provided
%     imageModel).
%
% Output:
%   factors: Every similarity factor in the word. You should use
%     ComputeSimilarityFactor to compute these.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

n = length(images);
nFactors = nchoosek (n, 2);

factors = repmat(struct('var', [], 'card', [], 'val', []), nFactors, 1);

% Your code here:
v=1:prod(n);
%see this on getting the actual binomial coefficients
%http://www.mathworks.com/help/techdoc/ref/nchoosek.html
binomcoeff=nchoosek(v,2);

for k=1:length(binomcoeff)
    index=binomcoeff(k,:);
    factors(k)=ComputeSimilarityFactor (images, K, index(1),index(2));
end

end
     


