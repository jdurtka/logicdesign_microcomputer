--	Entity:				computer/cpu
--	Class/Project:			EELE 367 Logic Design
--	Author:				James Durtka
--	Initiated:			April 14, 2016


library IEEE;
use IEEE.std_logic_1164.all; 


entity cpu is
	port (	clock				:	in	std_logic;
					reset				:	in	std_logic;
					address			:	out	std_logic_vector(7 downto 0);
					write				:	out	std_logic;
					to_memory		:	out	std_logic_vector(7 downto 0);
					from_memory	:	in	std_logic_vector(7 downto 0);
					halted			:	out	std_logic
	);
end entity;

architecture cpu_arch of cpu is

	component control_unit is
		port (	clock			:	in	std_logic;
			reset			:	in	std_logic;
			write			:	out	std_logic;

			IR_Load			:	out	std_logic;
			IR			:	in	std_logic_vector (7 downto 0);
			MAR_Load		:	out	std_logic;
			PC_Load			:	out	std_logic;
			PC_Inc			:	out	std_logic;
			A_Load			:	out	std_logic;
			B_Load			:	out	std_logic;
			ALU_Sel			:	out	std_logic_vector (2 downto 0);
			CCR_Result		:	in	std_logic_vector(3 downto 0);
			CCR_Load		:	out	std_logic;
			Bus2_Sel		:	out	std_logic_vector(1 downto 0);
			Bus1_Sel		:	out	std_logic_vector(1 downto 0);
			halted		:	out	std_logic
		);
	end component;

	component data_path is
		port (	clock			:	in	std_logic;
			reset			:	in	std_logic;

			address			:	out	std_logic_vector (7 downto 0);
			to_memory		:	out	std_logic_vector (7 downto 0);
			from_memory		:	in	std_logic_vector (7 downto 0);

			IR_Load			:	in	std_logic;
			IR			:	out	std_logic_vector(7 downto 0);
			MAR_Load		:	in	std_logic;
			PC_Load			:	in	std_logic;
			PC_Inc			:	in	std_logic;
			A_Load			:	in	std_logic;
			B_Load			:	in	std_logic;
			ALU_Sel			:	in	std_logic_vector(2 downto 0);
			CCR_Result		:	out	std_logic_vector(3 downto 0);
			CCR_Load		:	in	std_logic;
			Bus2_Sel		:	in 	std_logic_vector(1 downto 0);
			Bus1_Sel		:	in	std_logic_vector(1 downto 0)
		);
	end component;


	signal IR_Load			:	std_logic;
	signal 	IR			:	std_logic_vector(7 downto 0);
	signal 	MAR_Load		:	std_logic;
	signal 	PC_Load			:	std_logic;
	signal 	PC_Inc			:	std_logic;
	signal 	A_Load			:	std_logic;
	signal 	B_Load			:	std_logic;
	signal 	ALU_Sel			:	std_logic_vector(2 downto 0);
	signal 	CCR_Result		:	std_logic_vector(3 downto 0);
	signal 	CCR_Load		:	std_logic;
	signal 	Bus2_Sel		:	std_logic_vector(1 downto 0);
	signal 	Bus1_Sel		:	std_logic_vector(1 downto 0);


begin
	CU_INST	:	control_unit	port map (clock,reset,write,IR_Load,IR,MAR_Load,PC_Load,PC_Inc,A_Load,B_Load,ALU_Sel,CCR_Result,CCR_Load,Bus2_Sel,Bus1_Sel,halted);
	DP_INST	:	data_path	port map (clock,reset,address,to_memory,from_memory,IR_Load,IR,MAR_Load,PC_Load,PC_Inc,A_Load,B_Load,ALU_Sel,CCR_Result,CCR_Load,Bus2_Sel,Bus1_Sel);
end architecture;
