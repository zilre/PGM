function Summation = ComputeSummation(F)

  % Check for empty factor list
  assert(numel(F) ~= 0, 'Error: empty factor list');


if (length(F) == 0)
	% There are no factors, so create an empty factor list
    Summation = struct('var', [], 'card', [], 'val', []);
else    
	Summation = F(1);
	for i = 2:length(F)
		% Iterate through factors and incorporate them into the joint distribution
		Summation = FactorSum(Summation, F(i));
	end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
