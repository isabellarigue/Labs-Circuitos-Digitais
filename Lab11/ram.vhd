library ieee;
use ieee.std_logic_1164.all;

entity ram is
  port (
    Clock : in std_logic;
    Address : in std_logic_vector(9 downto 0);
    DataIn : in std_logic_vector(31 downto 0);
    DataOut : out std_logic_vector(31 downto 0);
    WrEn : in std_logic
  );
end ram;

architecture rtl of ram is
	signal address1: std_logic_vector (6 downto 0);
	signal data: std_logic_vector(31 downto 0);
	signal data_out: std_logic_vector(63 downto 0);
	signal DataOutAux1: std_logic_vector(31 downto 0);
	signal DataOutAux2: std_logic_vector(31 downto 0);
	signal wrenAux1: std_logic;
	signal wrenAux2: std_logic;
	
	component ram_block is 
		port(
		Clock: in std_logic;
		Address: in std_logic_vector(6 downto 0); 
		Data : in std_logic_vector(7 downto 0);
		Q : out std_logic_vector(7 downto 0);
		WrEn : in std_logic
		);
	end component;
	begin
		wrenAux1 <= ((not Address(9) and not Address(8)) and not Address(7) and WrEn);
		wrenAux2 <= ((not Address(9) and not Address(8)) and Address(7) and WrEn);
		address1 <= Address(6 downto 0);
		data <= DataIn;

		
		ram0: ram_block port map(
			Clock => Clock,
			Address => address1,
			Data => data(31 downto 24),
			Q => data_out(63 downto 56),
			WrEn => wrenAux1
			);
		ram1: ram_block port map(
			Clock => Clock,
			Address => address1,
			Data => data(23 downto 16),
			Q => data_out(55 downto 48),
			WrEn => wrenAux1
			);
		ram2: ram_block port map(
			Clock => Clock,
			Address => address1,
			Data => data(15 downto 8),
			Q => data_out(47 downto 40),
			WrEn => wrenAux1
			);
		ram3: ram_block port map(
			Clock => Clock,
			Address => address1,
			Data => data(7 downto 0),
			Q => data_out(39 downto 32),
			WrEn => wrenAux1
			);
		ram4: ram_block port map(
			Clock => Clock,
			Address => address1,
			Data => data(31 downto 24),
			Q => data_out(31 downto 24),
			WrEn => wrenAux2
			);
		ram5: ram_block port map(
			Clock => Clock,
			Address => address1,
			Data => data(23 downto 16),
			Q => data_out(23 downto 16),
			WrEn => wrenAux2
			);
		ram6: ram_block port map(
			Clock => Clock,
			Address => address1,
			Data => data(15 downto 8),
			Q => data_out(15 downto 8),
			WrEn => wrenAux2
			);
		ram7: ram_block port map(
			Clock => Clock,
			Address => address1,
			Data => data(7 downto 0),
			Q => data_out(7 downto 0),
			WrEn => wrenAux2
			);
			
		DataOutAux1 <= data_out(63 downto 56) & data_out(55 downto 48) & data_out(47 downto 40) & data_out(39 downto 32);
		DataOutAux2 <= data_out(31 downto 24) & data_out(23 downto 16) & data_out(15 downto 8) & data_out(7 downto 0);
		
		process(DataOutAux1, DataOutAux2)
		begin
			if Address(9) = '1' or Address(8) = '1' then
				DataOut <= (others => 'Z'); --Endereço invalido
			else
				if Address(7) = '0' then -- linha 1
					DataOut <= DataOutAux1;
				else -- linha 2
					DataOut <= DataOutAux2;
				end if;
			end if;
		end process;
end rtl;			