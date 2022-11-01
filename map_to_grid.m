function [i,x] = map_to_grid(x, gridSize)

	gp = ((x + 1.0)*0.5)*(gridSize - 1.0);
	i = min(gridSize - 2.0, floor(gp));
	x = gp - i;
	
end