library ieee;
use ieee.std_logic_1164.all;

entity alu is
	generic(
		N :integer := 8
	);
	port (
		a, b : in std_logic_vector(N-1 downto 0);
		control : in std_logic;
		sum : out std_logic_vector(N-1 downto 0)
	);
end alu;

architecture behavioral of alu is
	signal input_b : std_logic_vector(N-1 downto 0);
begin
	with control select
		input_b <= b when '1',
					(others => '0') when others;

	adder: entity work.ripple_carry generic map (N => N)
	port map(
		x => a,
		y => input_b,
		r => sum,
		cin => '0'
	);
end behavioral;
