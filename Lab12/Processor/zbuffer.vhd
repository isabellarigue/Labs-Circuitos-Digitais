library ieee;
use ieee.std_logic_1164.all;

entity zbuffer is
  generic (
    DATA_WIDTH : integer := 1
  );
  port (
    x : in std_logic_vector(DATA_WIDTH-1 downto 0);
    e : in std_logic;
    y : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end zbuffer;

architecture Behavioral of zbuffer is
begin
	y <= (others => 'Z') when e = '0' else x;
end Behavioral;
