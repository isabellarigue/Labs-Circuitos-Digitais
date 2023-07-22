Library IEEE;
use IEEE.std_logic_1164.all;

Entity xbar_v2 IS
	Port (x1, x2, S:  IN std_logic;
			y1, y2 : OUT std_logic);
End xbar_v2;

Architecture estrutural OF xbar_v2 IS
Begin
	y1 <= x1 WHEN S = '0' ELSE x2;
   y2 <= x2 WHEN S = '0' ELSE x1;
End estrutural;
