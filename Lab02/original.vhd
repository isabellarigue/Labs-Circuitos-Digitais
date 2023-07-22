Library IEEE;
use IEEE.std_logic_1164.all;

Entity original IS
	Port (a, b, c, d, e:  IN std_logic;
			f : OUT std_logic);
End original;

Architecture estrutural OF original IS
	signal g, h, i, j, k, l, m, n, o, p, q : std_logic;
Begin
	f <= g or h or i or j or k or l or m or n or o or p or q;
	g <= (not a) and (not b) and (not c) and (not d) and (not e);
	h <= (not a) and (not b) and (not c) and d and (not e);
	i <= (not a) and (not b) and c and (not d) and e;
	j <= (not a) and b and (not c) and (not d) and (not e);
	k <= (not a) and b and c and (not d) and e;
	l <= (not a) and b and c and d and e;
	m <= a and (not b) and (not c) and d and (not e);
	n <= a and (not b) and c and (not d) and e;
	o <= a and b and (not c) and (not d) and (not e);
	p <= a and b and c and (not d) and e;
	q <= a and b and c and d and e;
End estrutural;
