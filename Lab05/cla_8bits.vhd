-- brief : lab05 - question 2

library ieee;
use ieee.std_logic_1164.all;

entity cla_8bits is
  port(
    x    : in  std_logic_vector(7 downto 0);
    y    : in  std_logic_vector(7 downto 0);
    cin  : in  std_logic;
    sum  : out std_logic_vector(7 downto 0);
    cout : out std_logic
  );
end cla_8bits;

architecture rtl of cla_8bits is
	signal g: std_logic_vector(7 downto 0);
	signal p: std_logic_vector(7 downto 0);
	signal c: std_logic_vector(8 downto 0);
begin
	

loop1: for i in 0 to 7 generate
	g(i) <= x(i) and y(i);
	p(i) <= x(i) or y(i);
end generate;

c(0) <= cin;

loop2: for i in 0 to 7 generate
	c(i+1) <= g(i) or (p(i) and c(i));
end generate;

cout <= c(8);

loop3: for i in 0 to 7 generate
	sum(i) <= x(i) xor y(i) xor c(i);
end generate;
  
end rtl;

