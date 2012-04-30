function ngenos = numbergenotypes( numAlleles )
% for numAlleles there are n choose 2 + n possible genotyeps
ngenos= nchoosek(numAlleles,2) + numAlleles;

end

