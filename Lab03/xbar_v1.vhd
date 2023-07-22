Library IEEE;
use IEEE.std_logic_1164.all;

Entity xbar_v1 IS
	Port (x1, x2, S:  IN std_logic;
			y1, y2 : OUT std_logic);
End xbar_v1;

Architecture estrutural OF xbar_v1 IS
Begin
	WITH S SELECT
		y1 <= x1 WHEN '0',
				x2 WHEN OTHERS;

	WITH S SELECT
		y2 <= x2 WHEN '0',
				x1 WHEN OTHERS;

End estrutural;
