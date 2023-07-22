library ieee;
use ieee.std_logic_1164.all;

entity clk_div is
	port (
		clk : in std_logic;
		clk_hz : out std_logic
	);
end clk_div;

architecture behavioral of clk_div is
	constant clk_div_factor: positive := 50000000;
	constant bit_width: positive := 26;		-- Deve ser tal que 2^(bit_width) >= clk_div_factor
begin
	clk_counter: entity work.modulus_counter
		generic map(
			bit_width => bit_width,
			modulus => clk_div_factor
		)
		port map(
			clk => clk,
			reset => '0',
			enable => '1',
			data => (others => '0'),
			load => '0',
			count => open,
			terminal_count => clk_hz
		);
end behavioral;
