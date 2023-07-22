library ieee;
use ieee.std_logic_1164.all;

entity sign_extender is
  generic (
    DATA_IN_WIDTH : integer := 16;
	 DATA_OUT_WIDTH : integer := 32
  );
  port (
    x : in std_logic_vector(DATA_IN_WIDTH-1 downto 0);
    y : out std_logic_vector(DATA_OUT_WIDTH-1 downto 0)
  );
end sign_extender;

architecture Structural of sign_extender is
begin
	y(DATA_IN_WIDTH-1 downto 0) <= x;
	y(DATA_OUT_WIDTH-1 downto DATA_IN_WIDTH) <= (others => x(DATA_IN_WIDTH - 1));
end Structural;
