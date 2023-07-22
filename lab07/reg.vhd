library ieee;
use ieee.std_logic_1164.all;

entity reg is
  generic (
    N : integer := 4
  );
  port (
    clk : in std_logic;
    data_in : in std_logic_vector(N-1 downto 0);
    data_out : out std_logic_vector(N-1 downto 0);
    load : in std_logic; -- Write enable
    clear : in std_logic
  );
end reg;

architecture rtl of reg is
	signal aux: std_logic_vector(N-1 downto 0);
begin
	process(clk)
	begin
		if clk'EVENT and clk = '1' then
			if clear = '1' then
				aux <= (others => '0');
			elsif load = '1' then
				aux <= data_in;
			end if;
		end if;
	end process;

	data_out <= aux;
end rtl;
