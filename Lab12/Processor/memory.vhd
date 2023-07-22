LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY memory IS
	GENERIC (
		WORDSIZE : NATURAL := 32; -- Tamanho da palavra de dados
		BITS_OF_ADDR : NATURAL := 10; -- Tamanho da palavra de endereços
		MIF_FILE : STRING := "fibonacci_halt.mif" -- Arquivo com a imagem (conteudo) da memoria
	);
	PORT (
		clock   : IN	STD_LOGIC; -- Clock
		we      : IN	STD_LOGIC; -- Permissao de escrita
		address : IN	STD_LOGIC_VECTOR(BITS_OF_ADDR-1 DOWNTO 0); -- Endereço
		datain  : IN	STD_LOGIC_VECTOR(WORDSIZE-1 DOWNTO 0); -- Dado de entrada
		dataout : OUT	STD_LOGIC_VECTOR(WORDSIZE-1 DOWNTO 0) -- Dado de saida
	);
END ENTITY;

ARCHITECTURE RTL OF memory IS
-- me complete e descomente!
	type ram_type is array (0 to 2**BITS_OF_ADDR-1) of std_logic_vector (WORDSIZE-1 downto 0);
	signal ram			: ram_type;
	attribute ram_init_file			: string;
	attribute ram_init_file of ram	: signal is MIF_FILE;	
BEGIN
	process(clock)
	begin
		if clock'event and clock = '1' then
			if we = '1' then
				ram(to_integer(unsigned(address))) <= datain;
			end if;
			dataout <= ram(to_integer(unsigned(address)));
		end if;
	end process;
end architecture RTL;
