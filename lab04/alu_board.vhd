library ieee;
use ieee.std_logic_1164.all;

entity alu_board is
  port (
    SW : in std_logic_vector(9 downto 0);
    HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : out std_logic_vector(6 downto 0);
    LEDR : out std_logic_vector(3 downto 0)
  );
end alu_board;

architecture behavioral of alu_board is
	signal result, flags: std_logic_vector(3 downto 0);
	signal display1, display1_s, display2, display2_s, display3, display3_s: std_logic_vector(6 downto 0);
begin
	alu: entity work.alu
	port map (
		a => SW(7 downto 4),
		b => SW(3 downto 0),
		F => result,
		s0 => SW(9),
		s1 => SW(8),
		Z => flags(3),
		C => flags(2),
		V => flags(1),
		N => flags(0)
	);

	LEDR <= not flags;

	-- Display 1
	HEX5(6) <= '1' when (SW(8) = '1' or (SW(8) = '0' and SW(7) = '0')) else '0'; -- sinal do parametro 1
	HEX5(5 downto 0) <= "111111";

   param1_display: entity work.bin2hex
	port map (SW(7 downto 4), display1);
	param1_display_signed: entity work.two_comp_to_7seg
	port map (SW(7 downto 4), display1_s);
	HEX4(6 downto 0) <= display1_s when SW(8) = '0' else display1;

	-- Display 2
	HEX3(6) <= '1' when (SW(8) = '1' or (SW(8) = '0' and SW(3) = '0')) else '0'; -- sinal do parametro 2
	HEX3(5 downto 0) <= "111111";

	param2_display: entity work.bin2hex
	port map (SW(3 downto 0), display2);
	param2_display_signed: entity work.two_comp_to_7seg
	port map (SW(3 downto 0), display2_s);
	HEX2(6 downto 0) <= display2_s when SW(8) = '0' else display2;

	-- Display 3
	HEX1(6) <= '1' when (SW(8) = '1' or (SW(8) = '0' and flags(0) = '0')) else '0'; -- sinal do resultado
	HEX1(5 downto 0) <= "111111";

	output_display: entity work.bin2hex
	port map (result(3 downto 0), display3);
	param3_display_signed: entity work.two_comp_to_7seg
	port map (result(3 downto 0), display3_s);
	HEX0(6 downto 0) <= display3_s when SW(8) = '0' else display3;

end behavioral;
