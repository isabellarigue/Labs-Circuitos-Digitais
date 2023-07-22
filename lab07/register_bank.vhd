library ieee;
use ieee.std_logic_1164.all;

entity register_bank is
  port (
    clk : in std_logic;
    data_in : in std_logic_vector(3 downto 0);
    data_out : out std_logic_vector(3 downto 0);
    reg_rd : in std_logic_vector(2 downto 0);
    reg_wr : in std_logic_vector(2 downto 0);
    we : in std_logic;
    clear : in std_logic
  );
end register_bank;

architecture structural of register_bank is
	signal data_out_aux: std_logic_vector(31 downto 0);
	signal wr_select: std_logic_vector(7 downto 0);
	signal rd_select: std_logic_vector(7 downto 0);
begin
	dec3_to_8_wr: entity work.dec3_to_8
		port map(
			w => reg_wr,
			y => wr_select
		);
	
	dec3_to_8_rd: entity work.dec3_to_8
		port map(
			w => reg_rd,
			y => rd_select
		);

	loop1: for i in 0 to 7 generate
		reg: entity work.reg
			generic map (N => 4)
			port map(
				clk => clk,
				data_in => data_in,
				data_out => data_out_aux((i*4 + 3) downto (i*4)),
				load => (wr_select(i) and we),
				clear => clear
			);

		zbuffer: entity work.zbuffer
			port map(
				x => data_out_aux((i*4 + 3) downto (i*4)),
				e => rd_select(i),
				f => data_out
			);
	end generate;

end structural;
