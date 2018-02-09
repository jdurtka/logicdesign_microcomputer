--	Entity:					computer/cpu/control_unit
--	Class/Project:	EELE 367 Logic Design
--	Author:					James Durtka
--	Initiated:			April 14, 2016


library IEEE;
use IEEE.std_logic_1164.all; 

entity control_unit is
	port (	clock				:	in	std_logic;
					reset				:	in	std_logic;
					write				:	out	std_logic;
					IR_Load			:	out	std_logic;
					IR					:	in	std_logic_vector (7 downto 0);
					MAR_Load		:	out	std_logic;
					PC_Load			:	out	std_logic;
					PC_Inc			:	out	std_logic;
					A_Load			:	out	std_logic;
					B_Load			:	out	std_logic;
					ALU_Sel			:	out	std_logic_vector (2 downto 0);
					CCR_Result	:	in	std_logic_vector(3 downto 0);
					CCR_Load		:	out	std_logic;
					Bus2_Sel		:	out	std_logic_vector(1 downto 0);
					Bus1_Sel		:	out	std_logic_vector(1 downto 0)
	);
end entity;

architecture control_unit_arch of control_unit is

begin

end architecture;