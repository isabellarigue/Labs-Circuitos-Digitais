library ieee;
use ieee.std_logic_1164.all;

entity multiplier is
generic (N : integer := 4);
port (
	a, b : in std_logic_vector(N-1 downto 0);
	-- Operandos (multiplicador e multiplicando)
	r : out std_logic_vector(2*N-1 downto 0);
	-- Resultado (produto)
	clk : in std_logic;
	-- Clock
	set : in std_logic
	-- Operandos foram alterados
	);
end multiplier;

architecture rtl of multiplier is
	signal multiplicando_mode: std_logic_vector(1 downto 0);
	signal multiplicador_mode: std_logic_vector(1 downto 0);
	signal multiplicando_aux: std_logic_vector(2*N-1 downto 0);
	signal multiplicador_aux: std_logic_vector(N-1 downto 0);
	signal sum_aux: std_logic_vector(2*N-1 downto 0);
	signal par_in_aux: std_logic_vector(2*N-1 downto 0);
	signal produto: std_logic_vector(2*N-1 downto 0);

begin
	par_in_aux(N-1 downto 0) <= b;
	par_in_aux(2*N-1 downto N) <= (others => '0');

	with set select
		multiplicador_mode <= "11" when '1',		-- carga paralela
								    "10" when others;	-- shift right

	with set select
		multiplicando_mode <= "11" when '1',		-- carga paralela
		                      "01" when others;	-- shift left

	multiplicando: entity work.shift_register
	generic map (N => 2*N)
	port map(
		 clk => "not"(clk),
		 mode => multiplicando_mode,
		 ser_in => '0',
		 par_in => par_in_aux,
		 par_out => multiplicando_aux
	  );

	multiplicador: entity work.shift_register generic map (N => N)
	port map(
		 clk => "not"(clk),
		 mode => multiplicador_mode,
		 ser_in => '0',
		 par_in => a,
		 par_out => multiplicador_aux
	  );

	alu: entity work.alu generic map (N => 2*N)
	port map(
		a => produto,
		b => multiplicando_aux,
		control => multiplicador_aux(0),
		sum => sum_aux
	);

	r <= produto;

	process
	begin
		wait until clk'EVENT and clk = '1';
			if set = '1' then
				produto <= (others => '0');
			else
				produto <= sum_aux;
			end if;
	end process;
end rtl;
