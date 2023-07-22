library ieee;
use ieee.std_logic_1164.all;

entity ripple_carry_board is
	port (
		SW : in std_logic_vector(7 downto 0);
		HEX4 : out std_logic_vector(6 downto 0);
		HEX2 : out std_logic_vector(6 downto 0);
		HEX0 : out std_logic_vector(6 downto 0);
		LEDR : out std_logic_vector(0 downto 0)
	);
end ripple_carry_board;

architecture rtl of ripple_carry_board is
signal sum: std_logic_vector(3 downto 0);
signal cout: std_logic;
signal led_overflow: std_logic;
begin
	adder: entity work.ripple_carry
	generic map (N => 4)
	port map (SW(7 downto 4), SW(3 downto 0), sum(3 downto 0), '0', cout, led_overflow);
	LEDR(0) <= not led_overflow;

	param1_display: entity work.bin2hex
	port map (SW(7 downto 4), HEX4(6 downto 0));

	param2_display: entity work.bin2hex
	port map (SW(3 downto 0), HEX2(6 downto 0));

	output_display: entity work.bin2hex
	port map (sum(3 downto 0), HEX0(6 downto 0));

end rtl;
