library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity clock is
	port (
		-- Entradas
		clk : in std_logic;
		decimal : in std_logic_vector(3 downto 0);
		unity : in std_logic_vector(3 downto 0);
		set_hour : in std_logic;
		set_minute : in std_logic;
		set_second : in std_logic;

		-- Saidas
		hour_dec, hour_un : out std_logic_vector(6 downto 0);
		min_dec, min_un : out std_logic_vector(6 downto 0);
		sec_dec, sec_un : out std_logic_vector(6 downto 0)
	);
end clock;

architecture rtl of clock is
	component clk_div is
		port (
			clk : in std_logic;
			clk_hz : out std_logic
		);
	end component;

	signal clk_hz, clk_min, clk_hr : std_logic;									-- sinais para incrementar cada contador
	signal seconds_count, minutes_count : std_logic_vector(5 downto 0);	-- valor dos contadores (segundo, minuto)
	signal hours_count : std_logic_vector(4 downto 0); 						-- valor dos contadores (hora)
	
	signal set_h, set_m, set_s : std_logic;			-- ativa se tentar setar o contador respectivo, e o valor for valido
	signal new_value: std_logic_vector(7 downto 0);	-- valor a ser setado
	signal hour_dec_bcd, hour_un_bcd, min_dec_bcd, min_un_bcd, sec_dec_bcd, sec_un_bcd: std_logic_vector(3 downto 0);
	signal tmp0, tmp1, tmp2, soma_menor_60, soma_menor_24: std_logic_vector(7 downto 0);
	signal lixo: std_logic_vector(1 downto 0);
	signal init: std_logic := '1';
begin
	clock_divider : clk_div
		port map(
			clk => clk,
			clk_hz => clk_hz
		);

	counter: process(clk) begin
		if (clk'event and clk = '1' and init = '1') then
			init <= '0';
		end if;
	end process;

	-- Encadear contadores de hora, minuto, segundo
	seconds_counter: entity work.modulus_counter
		generic map(
			bit_width => 6,
			modulus => 60
		)
		port map(
			clk => clk,
			reset => init,
			enable => clk_hz,
			data => new_value(5 downto 0),
			load => set_s,
			count => seconds_count,
			terminal_count => clk_min
		);

	minutes_counter: entity work.modulus_counter
		generic map(
			bit_width => 6,
			modulus => 60
		)
		port map(
			clk => clk,
			reset => init,
			enable => clk_min,
			data => new_value(5 downto 0),
			load => set_m,
			count => minutes_count,
			terminal_count => clk_hr
		);

	hours_counter: entity work.modulus_counter
		generic map(
			bit_width => 5,
			modulus => 24
		)
		port map(
			clk => clk,
			reset => init,
			enable => clk_hr,
			data => new_value(4 downto 0),
			load => set_h,
			count => hours_count,
			terminal_count => open
		);

	-- Implementar DEC2BIN usando formula: 10*dec + un = ((dec + dec<<2) << 1) + un
	-- Jogar direto a saida de DEC2BIN em new_value
	conv_bcd2bin: entity work.bcd2bin
		port map(
			dec => decimal,
			un => unity,
			bin => new_value
		);

	-- ---- --
	-- Implementar circuito de controle com 2 ALU de subtracao (x-60) e (x-24).
	-- set_s <= (FLAGS negativo do (x-60) ativado) AND set_second
	-- set_m <= (FLAGS negativo do (x-60) ativado) AND set_minute
	-- set_h <= (FLAGS negativo do (x-24) ativado) AND set_hour
	menor_60: entity work.cla_8bits
		port map(
			x    => new_value,
			y    => "11000100", -- (-60)
			cin  => '0',
			sum  => soma_menor_60,
			cout => open
	  );

	menor_24: entity work.cla_8bits
		port map(
			x    => new_value,
			y    => "11101000", -- (-24)
			cin  => '0',
			sum  => soma_menor_24,
			cout => open
	  );

	set_s <= set_second and soma_menor_60(7); -- and (unsigned(new_value) < 60)
	set_m <= set_minute and soma_menor_60(7); -- and (unsigned(new_value) < 60)
	set_h <= set_hour and soma_menor_24(7); -- and (unsigned(new_value) < 24)

	-- Implementar BIN2BCD (6 bits) e instanciar 3 vezes.
	-- Passar os hours_count, minutes_count, seconds_count para os decodificadores BIN2BCD.
	-- Mapear saidas dos BIN2BCD: (hour_dec_bcd, hour_un_bcd), (min_dec_bcd, min_un_bcd), (sec_dec_bcd, sec_un_bcd)
	tmp0 <= "00" & seconds_count;
	sec_bin2bcd: entity work.bin2bcd
		port map(
			bin => tmp0,
			dec => sec_dec_bcd,
			un => sec_un_bcd
		);

	tmp1 <= "00" & minutes_count;
	min_bin2bcd: entity work.bin2bcd
		port map(
			bin => tmp1,
			dec => min_dec_bcd,
			un => min_un_bcd
		);

	tmp2 <= "000" & hours_count;
	hour_bin2bcd: entity work.bin2bcd
		port map(
			bin => tmp2,
			dec => hour_dec_bcd,
			un => hour_un_bcd
		);
	
	-- Cada caractere ja eh garantido de ser <10, nao tem problema usar o conversor pra hexadecimal.
	-- segundos
	sec_dec_7seg: entity work.bin2hex
		port map(
			bin => sec_dec_bcd,
			hex => sec_dec
		);

	sec_un_7seg: entity work.bin2hex
		port map(
			bin => sec_un_bcd,
			hex => sec_un
		);
	
	min_dec_7seg: entity work.bin2hex
		port map(
			bin => min_dec_bcd,
			hex => min_dec
		);

	min_un_7seg: entity work.bin2hex
		port map(
			bin => min_un_bcd,
			hex => min_un
		);
	
	hour_dec_7seg: entity work.bin2hex
		port map(
			bin => hour_dec_bcd,
			hex => hour_dec
		);

	hour_un_7seg: entity work.bin2hex
		port map(
			bin => hour_un_bcd,
			hex => hour_un
		);

end rtl;
