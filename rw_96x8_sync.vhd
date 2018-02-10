--	Entity:				computer/memory/rw_96x8_sync
--	Class/Project:			EELE 367 Logic Design
--	Author:				James Durtka
--	Initiated:			April 14, 2016

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity rw_96x8_sync is
	port	(	clock		:	in	std_logic;
			address		:	in	std_logic_vector (7 downto 0);
			data_in		:	in	std_logic_vector (7 downto 0);
			write		:	in	std_logic;
			data_out	:	out	std_logic_vector (7 downto 0)
	);
end entity;

architecture rw_96x8_sync_arch of rw_96x8_sync is
	
	type rw_type is array (128 to 223) of std_logic_vector(7 downto 0);

	signal	RW	:	rw_type;

	signal	EN	:	std_logic;

begin
	ENABLE : process(address)
	begin
		if ((to_integer(unsigned(address)) >= 128) and (to_integer(unsigned(address)) <= 223)) then
			EN <= '1';
		else
			EN <= '0';
		end if;
	end process;

	MEMORY : process (clock)
	begin
		if (rising_edge(clock)) then
			if (EN='1') then
				if (write='0') then
					data_out <= RW(to_integer(unsigned(address)));
				else
					RW(to_integer(unsigned(address))) <= data_in;
				end if;
			end if;
		end if;
	end process;
end architecture;