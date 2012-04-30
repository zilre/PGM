function factor = ComputeSimilarityFactor (images, K, i, j)
% This function computes the similarity factor between two character images
% in one word --- which characters is given by indices i and j (a
% description of how the factor should be computed is given below).
%
% Input:
%   images: A struct array of character images from one word.
%   K: The alphabet size.
%   i,j: The scope of that factor. That is, you should construct a factor
%     between characters i and j in the images array.
%
% Output:
%   factor: The similarity factor between these two characters. For any
%     assignment C_i != C_j, the factor value should be one. For any
%     assignment C_i == C_j, the factor value should be
%     ImageSimilarity(I_i, I_j) --- ie, the computed value given by
%     ImageSimilarity.m on the two images.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

factor = struct('var', [], 'card', [], 'val', []);
% this was a very helpful thread!
%https://class.coursera.org/pgm/forum/thread?thread_id=836

% Your code here:
factor.var=[i j];
factor.card= [ K K ];
factor.val= repmat( 1, prod([K K]), 1);

im1=images(i).img;
im2=images(j).img;
sim = ImageSimilarity (im1, im2);

for z=1:prod([K K] )
    ass=IndexToAssignment(z, [ K K ]);
    if ass(1) == ass(2)
        index=AssignmentToIndex(ass, [K K] );
        factor.val(index)=sim;
    end

end
end

