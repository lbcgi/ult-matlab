function y = LLRevBits(x,bits)
    y = 0;
	while bits
	
        bits = bits - 1;
		y = (y + y) + (x & 1);
		x = x/2;
    end

end