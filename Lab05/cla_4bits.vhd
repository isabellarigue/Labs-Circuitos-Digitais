-- brief : lab05 - question 2

library ieee;
use ieee.std_logic_1164.all;

entity cla_4bits is
  port(
    x    : in  std_logic_vector(3 downto 0);
    y    : in  std_logic_vector(3 downto 0);
    cin  : in  std_logic;
    sum  : out std_logic_vector(3 downto 0);
    cout : out std_logic
  );
end cla_4bits;

architecture rtl of cla_4bits is
	signal g: std_logic_vector(3 downto 0);
	signal p: std_logic_vector(3 downto 0);
	signal c: std_logic_vector(4 downto 0);
begin

loop1: for i in 0 to 3 generate
	g(i) <= x(i) and y(i);
	p(i) <= x(i) or y(i);
end generate;

c(0) <= cin;

loop2: for i in 0 to 3 generate
	c(i+1) <= g(i) or (p(i) and c(i));
end generate;

cout <= c(4);

loop3: for i in 0 to 3 generate
	sum(i) <= x(i) xor y(i) xor c(i);
end generate;
  
end rtl;

