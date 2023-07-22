library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modulus_counter is
	-- Contador sincrono de modulo configuravel

	generic (
		bit_width 	: positive	:= 4;		-- quantos bits tem o contador
		modulus		: positive	:= 16	-- modulo do contador (valor maximo + 1)
	);

	port (
	-- Entradas --
		clk:		in std_logic;	-- clock
		reset:	in std_logic;	-- resetar o contador a partir de 0
		enable:	in std_logic;	-- habilitar contagem
		data:		in std_logic_vector(bit_width-1 downto 0);	-- entrada de dados paralela
		load:		in std_logic;	-- carregar 'data' no contador

	-- Saidas --
		count:				out std_logic_vector(bit_width-1 downto 0);	-- contagem atual
		terminal_count:	out std_logic	-- habilitado por 1 periodo de clock cada vez que o contador termina um ciclo de contagem
	);
end;

architecture behavioral of modulus_counter is
	signal i_count: unsigned(bit_width-1 downto 0) := to_unsigned(0, bit_width);
begin
	count <= std_logic_vector(i_count);

	counter: process(clk, reset, load) begin
		if (reset = '1') then
			i_count <= (others => '0');
			terminal_count <= '0';
		elsif (load = '1') then
			i_count <= unsigned(data);
			terminal_count <= '0';
		elsif (clk'event and clk = '1') then
			terminal_count <= '0';
			if (enable = '1') then
				if (i_count = modulus - 1) then
					i_count <= (others => '0');
					terminal_count <= '1';
				else
					i_count <= i_count + 1;
				end if;
			end if;
		end if;
	end process;
end;
