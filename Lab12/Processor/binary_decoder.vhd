library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

ENTITY binary_decoder IS
	GENERIC (
		DATA_WIDTH : NATURAL := 5
	);
	PORT (
		x  : IN	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0); -- Dado de entrada
		y : OUT	STD_LOGIC_VECTOR(2**DATA_WIDTH-1 DOWNTO 0) -- Dado de saida
	);
END ENTITY;

ARCHITECTURE Structural OF binary_decoder IS
	signal w : std_logic_vector(2**DATA_WIDTH-1 downto 0);
BEGIN
	w <= (0 => '1', others => '0');
	y <= std_logic_vector(shift_left(unsigned(w), to_integer(unsigned(x))));
END ARCHITECTURE;
