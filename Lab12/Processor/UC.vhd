LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY Processor;
USE Processor.Processor_pack.ALL;

ENTITY UC IS
	PORT (
		clear,
		clock			: IN	STD_LOGIC;
		instruction		: IN	STD_LOGIC_VECTOR (5 DOWNTO 0);
		IR_Ld, PC_Inc, ALU_2_DBus, DM_Rd, DM_Wr, PC_Ld_En, Reg_2_IO, IO_2_Reg, Reg_Wr, Stat_Wr, ALU_Src,
		DM_2_DBus		: OUT	STD_LOGIC
	);
END ENTITY;

ARCHITECTURE Behavior OF UC IS
	SIGNAL current_state : states_UC := FETCH;
BEGIN
	StateMachine:
	PROCESS (clear, clock, instruction, current_state)
		variable halted : std_logic := '0';
	BEGIN
		IF (clear = '1') THEN
			IR_Ld		<= '0';
			PC_Inc		<= '0';
			ALU_2_DBus	<= '0';
			DM_Rd		<= '0';
			DM_Wr		<= '0';
			PC_Ld_En	<= '0';
			Reg_2_IO	<= '0';
			IO_2_Reg	<= '0';
			Reg_Wr		<= '0';
			Stat_Wr		<= '0';
			DM_2_DBus	<= '0';
			halted := '0';

			current_state <= FETCH;	
		ELSIF (clock'EVENT AND clock = '1') THEN
			IR_Ld <= '0';
			PC_Inc <= '0';
			ALU_2_DBus <= '0';
			DM_Rd <= '0';
			DM_Wr <= '0';
			PC_Ld_En <= '0';
			Reg_2_IO <= '0';
			IO_2_Reg <= '0';
			Reg_Wr <= '0';
			Stat_Wr <= '0';
			DM_2_DBus <= '0';
			ALU_Src <= '0';
			CASE current_state IS
				WHEN FETCH =>
					IR_ld		<= '1';
					PC_Inc		<= '1';
					current_state <= DECODE;
				WHEN DECODE =>
					current_state <= EX;
				WHEN EX =>
					CASE instruction IS
						WHEN "000111" =>
						-- LW
							DM_Rd <= '1';
							Reg_Wr <= '1';
							DM_2_DBus	<= '1';
						WHEN "001000" | "001100" | "001001" =>
						-- ADD, ADDI, SUB
							ALU_2_DBus	<= '1';
							Reg_Wr		<= '1';
							Stat_Wr		<= '1';
							IF (instruction = "001100") THEN
								-- ADDI carrega imediato em vez de rs2
								ALU_Src <= '1';
							END IF;
						WHEN "010111" =>
						-- SW
							DM_Wr		<= '1';
						WHEN "011000" =>
						-- HALT
							halted := '1';
						WHEN "100000" =>
							IO_2_Reg	<= '1';
							Reg_Wr		<= '1';
						WHEN "110000" =>
						-- OUT
							Reg_2_IO	<= '1';
						WHEN OTHERS =>
							PC_Ld_En	<= '1';
					END CASE;
					IF (halted = '0') THEN
						current_state <= FETCH;
					END IF;
			END CASE;
		END IF;
	END PROCESS;
END ARCHITECTURE;
