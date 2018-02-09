--	Entity:					computer/cpu/data_path
--	Class/Project:	EELE 367 Logic Design
--	Author:					James Durtka
--	Initiated:			April 14, 2016

library IEEE;
use IEEE.std_logic_1164.all; 

entity data_path is
	port (	clock				:	in	std_logic;
					reset				:	in	std_logic;
					address			:	out	std_logic_vector (7 downto 0);
					to_memory		:	out	std_logic_vector (7 downto 0);
					from_memory	:	in	std_logic_vector (7 downto 0);

					IR_Load			:	in	std_logic;
					IR					:	out	std_logic_vector(7 downto 0);
					MAR_Load		:	in	std_logic;
					PC_Load			:	in	std_logic;
					PC_Inc			:	in	std_logic;
					A_Load			:	in	std_logic;
					B_Load			:	in	std_logic;
					ALU_Sel			:	in	std_logic_vector(2 downto 0);
					CCR_Result	:	out	std_logic_vector(3 downto 0);
					CCR_Load		:	in	std_logic;
					Bus2_Sel		:	out	std_logic_vector(1 downto 0);
					Bus1_Sel		:	out	std_logic_vector(1 downto 0)
	);
end entity;

architecture data_path_arch of data_path is

	component alu is
		port(
			ALU_Sel					:	in	std_logic_vector(2 downto 0);
			A								:	in	std_logic_vector(7 downto 0);
			B								:	in	std_logic_vector(7 downto 0);
			NZVC						:	out	std_logic_vector(3 downto 0);
			result					:	out	std_logic_vector(7 downto 0)
		);
	end component;

	signal	NZVC				:	std_logic_vector(3 downto 0);
	signal	ALU_Result	:	std_logic_vector(7 downto 0);
	signal	Breg				:	std_logic_vector(7 downto 0);
	signal	BUS1				:	std_logic_vector(7 downto 0);
	signal	BUS2				:	std_logic_vector(7 downto 0);

begin

	ALU_INST :	alu port map (ALU_Sel,Breg,BUS1,NZVC,ALU_Result);

end architecture;