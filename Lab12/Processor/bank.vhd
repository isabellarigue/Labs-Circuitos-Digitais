LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY Processor;
USE Processor.Processor_pack.reg;

ENTITY bank IS
	GENERIC (
		WORDSIZE : NATURAL := 32; -- Tamanho da palavra de dados em bits
		ADDR_WIDTH : NATURAL := 5 -- Largura do endereço (nº de registradores = 2**ADDR_WIDTH)
	);
	PORT (
		WR_EN : IN STD_LOGIC; -- Permissao de escrita (ativo em nivel alto)
		RD_EN : IN STD_LOGIC; -- Permissao de leitura (ativo em nivel alto)
		clear : IN STD_LOGIC; -- Limpar todos os registradores (ativo em nivel alto)
		clock : IN STD_LOGIC; -- Clock
		WR_ADDR : IN STD_LOGIC_VECTOR (ADDR_WIDTH-1 DOWNTO 0); -- Registrador para escrita
		RD_ADDR1 : IN STD_LOGIC_VECTOR (ADDR_WIDTH-1 DOWNTO 0); -- Registrador para leitura 1
		RD_ADDR2 : IN STD_LOGIC_VECTOR (ADDR_WIDTH-1 DOWNTO 0); -- Registrador para leitura 2
		DATA_IN : IN STD_LOGIC_VECTOR (WORDSIZE-1 DOWNTO 0); -- Entrada de dados
		DATA_OUT1 : OUT STD_LOGIC_VECTOR (WORDSIZE-1 DOWNTO 0); -- Saida de dados 1
		DATA_OUT2 : OUT STD_LOGIC_VECTOR (WORDSIZE-1 DOWNTO 0) -- Saida de dados 2
	);
END ENTITY;

ARCHITECTURE Structural OF bank IS
	type reg_read_array is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector (WORDSIZE-1 downto 0);

	signal reg_read_data: reg_read_array;
	signal wr_select: std_logic_vector(2**ADDR_WIDTH-1 downto 0);
	signal rd1_select: std_logic_vector(2**ADDR_WIDTH-1 downto 0);
	signal rd2_select: std_logic_vector(2**ADDR_WIDTH-1 downto 0);
BEGIN
	-- 1 Registrador 'zero' e 31 general purpose
	reg_read_data(0) <= (others => '0');

	L1: for i in 1 to (2**ADDR_WIDTH-1) generate
		regs: entity work.reg
			generic map(WORDSIZE => WORDSIZE)
			port map(
				clock => clock,
				load => (wr_select(i) and WR_EN),
				clear	=> clear,
				datain => DATA_IN,
				dataout => reg_read_data(i)
			);
	end generate;

	L2: for i in 0 to (2**ADDR_WIDTH-1) generate
		DR1: entity work.zbuffer
			generic map(DATA_WIDTH => WORDSIZE)
			port map(
				x => reg_read_data(i),
				e => (rd1_select(i) and RD_EN),
				y => DATA_OUT1
			);

		DR2: entity work.zbuffer
			generic map(DATA_WIDTH => WORDSIZE)
			port map(
				x => reg_read_data(i),
				e => (rd2_select(i) and RD_EN),
				y => DATA_OUT2
			);
	end generate;

	reg_write_select: entity work.binary_decoder
		generic map(DATA_WIDTH => ADDR_WIDTH)
		port map(
			x => WR_ADDR,
			y => wr_select
		);

	reg1_read_select: entity work.binary_decoder
		generic map(DATA_WIDTH => ADDR_WIDTH)
		port map(
			x => RD_ADDR1,
			y => rd1_select
		);

	reg2_read_select: entity work.binary_decoder
		generic map(DATA_WIDTH => ADDR_WIDTH)
		port map(
			x => RD_ADDR2,
			y => rd2_select
		);
END ARCHITECTURE;