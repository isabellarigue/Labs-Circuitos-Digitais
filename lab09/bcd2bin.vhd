library ieee;
use ieee.std_logic_1164.all;

entity bcd2bin is
	-- Converte um decimal BCD para binario (8-bits).
	-- Formula: bin = 10*dec + un = ((dec + dec<<2) << 1) + un
	port (
		dec, un:	in std_logic_vector(3 downto 0);
		bin:		out std_logic_vector(7 downto 0)
	);
end;

architecture rtl of bcd2bin is
	signal tmp:  std_logic_vector(7 downto 0);
	signal tmp0, tmp1, tmp2, tmp3: std_logic_vector(7 downto 0);
begin
	tmp0 <= "0000" & dec;
	tmp1 <= "00" & dec & "00";
	tmp2 <= tmp(6 downto 0) & "0";
	tmp3 <= "0000" & un;

	soma1: entity work.cla_8bits
		port map(
			x => tmp0,
			y => tmp1,
			cin => '0',
			sum => tmp,
			cout => open
		);

	soma2: entity work.cla_8bits
		port map(
			x => tmp2,
			y => tmp3,
			cin => '0',
			sum => bin,
			cout => open
		);
end;