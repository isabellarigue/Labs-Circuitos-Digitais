library ieee;
use ieee.std_logic_1164.all;

entity alu is
	port (
		a, b : in std_logic_vector(3 downto 0);
		F : out std_logic_vector(3 downto 0);
		s0, s1 : in std_logic;
		Z, C, V, N : out std_logic
	);
end alu;

architecture behavioral of alu is
	signal b_compl, adder_output: std_logic_vector(3 downto 0);
	signal aux_F: std_logic_vector(3 downto 0);
	signal cout_aux, overflow_aux: std_logic;
begin
	-- note que s1 = '1' nao eh necessario pq a saida do somador seria descartada de todo jeito
	b_compl <= b when s0 = '0' else not b;

	adder: entity work.ripple_carry
	port map(
		x => a,
		y => b_compl,
		r => adder_output,
		cin => s0,
		cout => cout_aux,
		overflow => overflow_aux
	);

	aux_F <= (a and b) when (s1 = '1' and s0 = '0') else
				(a or b) when (s1 = '1' and s0 = '1') else
				adder_output;

	C <= cout_aux 		when s1 = '0' else '0';
	V <= overflow_aux when s1 = '0' else '0';
	N <= aux_F(3) 		when s1 = '0' else '0';
	Z <= '1' 			when aux_F = "0000" else '0';

	F <= aux_F;

end behavioral;
