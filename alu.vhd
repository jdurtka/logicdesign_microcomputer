--	Entity:					computer/memory/rom_128x8_sync
--	Class/Project:	EELE 367 Logic Design
--	Author:					James Durtka
--	Initiated:			April 14, 2016

library IEEE;
use IEEE.std_logic_1164.all; 

entity alu is
	port(
		ALU_Sel					:	in	std_logic_vector(2 downto 0);
		A								:	in	std_logic_vector(7 downto 0);
		B								:	in	std_logic_vector(7 downto 0);
		NZVC						:	out	std_logic_vector(3 downto 0);
		result					:	out	std_logic_vector(7 downto 0)
	);
end entity;

architecture alu_arch of alu is

begin

end architecture;