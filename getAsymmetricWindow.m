function [analysisWnd,synthesisWnd] = getAsymmetricWindow(k,  m,  p)
    global M_PI
    freq_temporal = 1;
	if ((k / m) < 4)
		freq_temporal = 1.0;
    end
	if (freq_temporal > 9.0)
		freq_temporal = 9.0;
    end
	synthesisWnd = zeros(k,1);
    analysisWnd = synthesisWnd;
	n = ((k - m) *2) + 2;
	for i = 0:k-m-1
		analysisWnd(i+1) = 0.5 * (1.0 - cos(2.0 * M_PI * (i + 1.0) /n));
    end
    n = (m *2 ) + 2;
% 	if (freq_temporal > 1.02)
% 		freq_temporal = 1.02;
%     end
	for i = k - m : k-1
		analysisWnd(i+1) = sqrt(0.5 * (1.0 - cos(2.0 * M_PI * ((m + i - (k - m)) + 1.0) / n)));
    end
    n = m *2;
	for i = k - (m *2 ):k-1
		synthesisWnd(i+1) = (0.5 * (1.0 - cos(2.0 * M_PI * (i - (k - (m *2 ))) / n))) / analysisWnd(i+1);
	end
        % Pre-shift window function
	for i = 0:k-p-1
		synthesisWnd(i+1) = synthesisWnd(1+i + p);
    end
