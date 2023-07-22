library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_block is
	generic(
		depth : integer range 1 to 7 := 7;
		width: integer range 1 to 8 := 8
	);
  port (
    Clock : in std_logic;
    Address : in std_logic_vector(6 downto 0);
    Data : in std_logic_vector(7 downto 0);
    Q : out std_logic_vector(7 downto 0);
    WrEn : in std_logic -- Permissao de escrita
  );
end ram_block;

architecture direct of ram_block is
	type ram_vector is array (0 to 2**depth-1) of std_logic_vector (width-1 downto 0);
	signal ram_signal: ram_vector := (others => (others => '0'));
begin
  process(Clock)
  begin
		if Clock'event and Clock = '1' then
			if WrEn = '1' then
				ram_signal(to_integer(unsigned(Address))) <= Data;
			end if;
			Q <= ram_signal(to_integer(unsigned(Address)));
		end if;
	end process;
end direct;
