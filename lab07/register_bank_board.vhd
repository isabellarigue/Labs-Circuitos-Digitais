library ieee;
use ieee.std_logic_1164.all;

entity register_bank_board is
	port (
	KEY: in std_logic_vector(3 downto 0); -- clk
	SW : in std_logic_vector(9 downto 0); -- data_in(3 a 0), reg_rd(6 a 4), reg_wr(9 a 7)
	HEX2, HEX0 : out std_logic_vector(6 downto 0); -- data_in, data_out
	-- we = const(1)
	-- clear = const(0)
	LEDR : out std_logic_vector(9 downto 0) -- debug
	);
end register_bank_board;

architecture structural of register_bank_board is
	signal data_in_aux: std_logic_vector(3 downto 0);
	signal data_out_aux: std_logic_vector(3 downto 0);
	signal clock: std_logic;
begin
	clock <= KEY(0);
	LEDR(9 downto 0) <= (0 => clock, others => '0');
	data_in_aux <= SW(3 downto 0);

	reg_bank: entity work.register_bank
		port map(
			clk => clock,
			data_in => data_in_aux,
			data_out => data_out_aux,
			reg_rd => SW(6 downto 4),
			reg_wr => SW(9 downto 7),
			we => '1',
			clear => '0'
		);

	bin2hex_in: entity work.bin2hex
		port map(
			bin => data_in_aux,
			hex => HEX2(6 downto 0)
		);

	bin2hex_out: entity work.bin2hex
		port map(
			bin => data_out_aux,
			hex => HEX0(6 downto 0)
		);

end structural;
