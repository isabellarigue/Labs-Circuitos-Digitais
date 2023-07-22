Library IEEE;
use IEEE.std_logic_1164.all;

Entity minimizado IS
	Port (a, b, c, d, e:  IN std_logic;
			f : OUT std_logic);
End minimizado;

Architecture estrutural OF minimizado IS
	signal g, h, i, j, k : std_logic;
Begin
	f <= g or h or i or j or k;
	g <= c and (not d) and e;
	h <= b and c and e;
	i <= (not a) and (not b) and (not c) and (not e);
	j <= (not b) and (not c) and d and (not e);
	k <= b and (not c) and (not d) and (not e);
End estrutural;
