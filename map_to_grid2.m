function [i,x] = map_to_grid2(x)

	gp = (x + 1.0)*127.5;
	i = floor(gp);
    if (i > 254.0)
		i = 254.0;
    end
	x = gp - i;
	
end