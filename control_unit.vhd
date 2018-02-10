--	Entity:				computer/cpu/control_unit
--	Class/Project:			EELE 367 Logic Design
--	Author:				James Durtka
--	Initiated:			April 14, 2016


library IEEE;
use IEEE.std_logic_1164.all;

use work.constants.all;

entity control_unit is
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
		halted			:	out	std_logic
	);
end entity;

architecture control_unit_arch of control_unit is

	type state_type is (	S_FETCH_0, S_FETCH_1, S_FETCH_2,
				S_DECODE_3,

				S_LDA_IMM_4, S_LDA_IMM_5, S_LDA_IMM_6,
				S_LDB_IMM_4, S_LDB_IMM_5, S_LDB_IMM_6,

				S_LDA_DIR_4, S_LDA_DIR_5, S_LDA_DIR_6, S_LDA_DIR_7, S_LDA_DIR_8,
				S_LDB_DIR_4, S_LDB_DIR_5, S_LDB_DIR_6, S_LDB_DIR_7, S_LDB_DIR_8,

				S_STA_DIR_4, S_STA_DIR_5, S_STA_DIR_6, S_STA_DIR_7,
				S_STB_DIR_4, S_STB_DIR_5, S_STB_DIR_6, S_STB_DIR_7,

				S_ADD_AB_4,
				S_SUB_AB_4,
				S_AND_AB_4,
				S_OR_AB_4,

				S_INCA_4,
				S_INCB_4,
				S_DECA_4,
				S_DECB_4,

				--Branch states are the same for conditional or unconditional
				S_BRA_4, S_BRA_5, S_BRA_6,
				--Except there's an additional state for when the conditional is false
				S_BCONF_7,

				S_NOP_4,
				S_HALT_4

			);

	signal current_state, next_state : state_type;
	signal single_step	:	std_logic;

begin

	STATE_MEMORY : process (clock, reset)
	begin
		if (reset = '0') then
			current_state <= S_FETCH_0;
		elsif (rising_edge(clock)) then
			current_state <= next_state;
		end if;
	end process;



	NEXT_STATE_LOGIC : process (current_state, IR, CCR_Result)
	begin
		if (current_state = S_FETCH_0) then
			next_state <= S_FETCH_1;
		elsif (current_state = S_FETCH_1) then
			next_state <= S_FETCH_2;
		elsif (current_state = S_FETCH_2) then
			next_state <= S_DECODE_3;

		elsif (current_state = S_DECODE_3) then
			-- Loads
			if (IR = LDA_IMM) then
				next_state <= S_LDA_IMM_4;
			elsif (IR = LDB_IMM) then
				next_state <= S_LDB_IMM_4;
			elsif (IR = LDA_DIR) then
				next_state <= S_LDA_DIR_4;
			elsif (IR = LDB_DIR) then
				next_state <= S_LDB_DIR_4;

			-- Stores
			elsif (IR = STA_DIR) then
				next_state <= S_STA_DIR_4;
			elsif (IR = STB_DIR) then
				next_state <= S_STB_DIR_4;

			-- Basic ALU operations
			elsif (IR = ADD_AB) then
				next_state <= S_ADD_AB_4;
			elsif (IR = SUB_AB) then
				next_state <= S_SUB_AB_4;
			elsif (IR = AND_AB) then
				next_state <= S_AND_AB_4;
			elsif (IR = OR_AB) then
				next_state <= S_OR_AB_4;
			
			-- Increment/Decrement ALU operations
			elsif (IR = INCA) then
				next_state <= S_INCA_4;
			elsif (IR =INCB) then
				next_state <= S_INCB_4;
			elsif (IR = DECA) then
				next_state <= S_DECA_4;
			elsif (IR = DECB) then
				next_state <= S_DECB_4;


			elsif (IR = BRA) then
				next_state <= S_BRA_4;

			--Conditional branches
			elsif (IR = BEQ) then
				if (CCR_Result(2) = '0') then
					next_state <= S_BCONF_7;
				else
					next_state <= S_BRA_4;
				end if;
			elsif (IR = BNE) then
				if (CCR_Result(2) = '1') then
					next_state <= S_BCONF_7;
				else
					next_state <= S_BRA_4;
				end if;
			elsif (IR = BMI) then
				if (CCR_Result(3) = '0') then
					next_state <= S_BCONF_7;
				else
					next_state <= S_BRA_4;
				end if;
			elsif (IR = BPL) then
				if (CCR_Result(3) = '0') then
					next_state <= S_BCONF_7;
				else
					next_state <= S_BRA_4;
				end if;
			elsif (IR = BVS) then
				if (CCR_Result(1) = '0') then
					next_state <= S_BCONF_7;
				else
					next_state <= S_BRA_4;
				end if;
			elsif (IR = BVC) then
				if (CCR_Result(1) = '1') then
					next_state <= S_BCONF_7;
				else
					next_state <= S_BRA_4;
				end if;
			elsif (IR = BCS) then
				if (CCR_Result(0) = '0') then
					next_state <= S_BCONF_7;
				else
					next_state <= S_BRA_4;
				end if;
			elsif (IR = BCC) then
				if (CCR_Result(0) = '1') then
					next_state <= S_BCONF_7;
				else
					next_state <= S_BRA_4;
				end if;

			--Misc.
			elsif (IR = NOP) then
				next_state <= S_NOP_4;
			elsif (IR = HALT) then
				next_state <= S_HALT_4;
			else
					next_state <= S_FETCH_0;
			end if;
		
		elsif (current_state = S_LDA_IMM_4) then
			next_state <= S_LDA_IMM_5;
		elsif (current_state = S_LDA_IMM_5) then
			next_state <= S_LDA_IMM_6;
		elsif (current_state = S_LDB_IMM_4) then
			next_state <= S_LDB_IMM_5;
		elsif (current_state = S_LDB_IMM_5) then
			next_state <= S_LDB_IMM_6;

		elsif (current_state = S_LDA_DIR_4) then
			next_state <= S_LDA_DIR_5;
		elsif (current_state = S_LDA_DIR_5) then
			next_state <= S_LDA_DIR_6;
		elsif (current_state = S_LDA_DIR_6) then
			next_state <= S_LDA_DIR_7;
		elsif (current_state = S_LDA_DIR_7) then
			next_state <= S_LDA_DIR_8;
		elsif (current_state = S_LDB_DIR_4) then
			next_state <= S_LDB_DIR_5;
		elsif (current_state = S_LDB_DIR_5) then
			next_state <= S_LDB_DIR_6;
		elsif (current_state = S_LDB_DIR_6) then
			next_state <= S_LDB_DIR_7;
		elsif (current_state = S_LDB_DIR_7) then
			next_state <= S_LDB_DIR_8;

		elsif (current_state = S_STA_DIR_4) then
			next_state <= S_STA_DIR_5;
		elsif (current_state = S_STA_DIR_5) then
			next_state <= S_STA_DIR_6;
		elsif (current_state = S_STA_DIR_6) then
			next_state <= S_STA_DIR_7;
		elsif (current_state = S_STB_DIR_4) then
			next_state <= S_STB_DIR_5;
		elsif (current_state = S_STB_DIR_5) then
			next_state <= S_STB_DIR_6;
		elsif (current_state = S_STB_DIR_6) then
			next_state <= S_STB_DIR_7;

		elsif (current_state = S_BRA_4) then
			next_state <= S_BRA_5;
		elsif (current_state = S_BRA_5) then
			next_state <= S_BRA_6;

		-- HALT hangs forever
		elsif (current_state = S_HALT_4) then
			next_state <= S_HALT_4;

		-- default: always return to fetch state
		else
			next_state <= S_FETCH_0;
		end if;
	end process;



	OUTPUT_LOGIC : process (current_state)
	begin
		case (current_state) is

		--Put PC onto MAR to read Opcode/Operand
		when S_FETCH_0 | S_LDA_IMM_4 | S_LDB_IMM_4 | S_LDA_DIR_4 | S_LDB_DIR_4 | S_BRA_4 | S_STA_DIR_4 | S_STB_DIR_4 =>
			IR_Load <= '0';
			MAR_Load <= '1'; -- Load MAR
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '0';
			B_Load <= '0';
			ALU_Sel <= "000";
			CCR_Load <= '0';
			Bus1_Sel <= "00"; -- (00)PC	(01)A		(10)B
			Bus2_Sel <= "01"; -- (00)ALU	(01)Bus1	(10)from_memory
			write <= '0';
			halted <= '0';

		--Increment PC
		when S_FETCH_1 | S_LDA_IMM_5 | S_LDB_IMM_5 | S_LDA_DIR_5 | S_LDB_DIR_5 | S_STA_DIR_5 | S_STB_DIR_5 | S_BCONF_7 | S_NOP_4 =>
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '1'; -- Increment PC
			A_Load <= '0';
			B_Load <= '0';
			ALU_Sel <= "000";
			CCR_Load <= '0';
			Bus1_Sel <= "00"; -- doesn't matter
			Bus2_Sel <= "00"; -- doesn't matter
			write <= '0';
			halted <= '0';

		--Latch opcode from memory into IR
		when S_FETCH_2 =>
			IR_Load <= '1'; -- Load IR
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '0';
			B_Load <= '0';
			ALU_Sel <= "000";
			CCR_Load <= '0';
			Bus1_Sel <= "00"; -- doesn't matter
			Bus2_Sel <= "10"; -- (00)ALU	(01)Bus1	(10)from_memory
			write <= '0';
			halted <= '0';

		--Put from_memory onto register A
		when S_LDA_IMM_6 | S_LDA_DIR_8 => 
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '1';
			B_Load <= '0';
			ALU_Sel <= "000";
			CCR_Load <= '0';
			Bus1_Sel <= "00"; -- (00)PC	(01)A		(10)B
			Bus2_Sel <= "10"; -- (00)ALU	(01)Bus1	(10)from_memory
			write <= '0';
			halted <= '0';

		--Put from_memory onto register B
		when S_LDB_IMM_6 | S_LDB_DIR_8 =>
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '0';
			B_Load <= '1';
			ALU_Sel <= "000";
			CCR_Load <= '0';
			Bus1_Sel <= "00"; -- (00)PC	(01)A		(10)B
			Bus2_Sel <= "10"; -- (00)ALU	(01)Bus1	(10)from_memory
			write <= '0';
			halted <= '0';

		--Put from_memory into MAR
		when S_LDA_DIR_6 | S_LDB_DIR_6 | S_STA_DIR_6 | S_STB_DIR_6 =>
			IR_Load <= '0';
			MAR_Load <= '1';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '0';
			B_Load <= '0';
			ALU_Sel <= "000";
			CCR_Load <= '0';
			Bus1_Sel <= "00"; -- doesn't matter
			Bus2_Sel <= "10"; -- (00)ALU	(01)Bus1	(10)from_memory
			write <= '0';
			halted <= '0';

		--Put from_memory into PC
		when S_BRA_6 =>
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '1';
			PC_Inc <= '0';
			A_Load <= '0';
			B_Load <= '0';
			ALU_Sel <= "000";
			CCR_Load <= '0';
			Bus1_Sel <= "00"; -- doesn't matter
			Bus2_Sel <= "10"; -- (00)ALU	(01)Bus1	(10)from_memory
			write <= '0';
			halted <= '0';

		--Put register A to memory
		when S_STA_DIR_7 =>
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '0';
			B_Load <= '0';
			ALU_Sel <= "000";
			CCR_Load <= '0';
			Bus1_Sel <= "01"; -- (00)PC	(01)A		(10)B
			Bus2_Sel <= "00"; -- doesn't matter
			write <= '1';
			halted <= '0';

		--Put register B to memory
		when S_STB_DIR_7 => 
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '0';
			B_Load <= '0';
			ALU_Sel <= "000";
			CCR_Load <= '0';
			Bus1_Sel <= "10"; -- (00)PC	(01)A		(10)B
			Bus2_Sel <= "00"; -- doesn't matter
			write <= '1';
			halted <= '0';

		--Setup the ALU to add A and B and put the result in A
		when S_ADD_AB_4 =>
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '1';
			B_Load <= '0';
			ALU_Sel <= ALU_ADD;
			CCR_Load <= '1';
			Bus1_Sel <= "01"; -- (00)PC	(01)A		(10)B
			Bus2_Sel <= "00"; -- (00)ALU	(01)Bus1	(10)from_memory
			write <= '0';
			halted <= '0';
			
		--Setup the ALU to subtract B from A and put the result in A
		when S_SUB_AB_4 =>
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '1';
			B_Load <= '0';
			ALU_Sel <= ALU_SUB;
			CCR_Load <= '1';
			Bus1_Sel <= "01"; -- (00)PC	(01)A		(10)B
			Bus2_Sel <= "00"; -- (00)ALU	(01)Bus1	(10)from_memory
			write <= '0';
			halted <= '0';

		--Setup the ALU to logically AND A and B and put the result in A
		when S_AND_AB_4 =>
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '1';
			B_Load <= '0';
			ALU_Sel <= ALU_AND;
			CCR_Load <= '1';
			Bus1_Sel <= "01"; -- (00)PC	(01)A		(10)B
			Bus2_Sel <= "00"; -- (00)ALU	(01)Bus1	(10)from_memory
			write <= '0';
			halted <= '0';

		--Setup the ALU to logically OR A and B and put the result in A
		when S_OR_AB_4 =>
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '1';
			B_Load <= '0';
			ALU_Sel <= ALU_OR;
			CCR_Load <= '1';
			Bus1_Sel <= "01"; -- (00)PC	(01)A		(10)B
			Bus2_Sel <= "00"; -- (00)ALU	(01)Bus1	(10)from_memory
			write <= '0';
			halted <= '0';

		-- Increment A
		when S_INCA_4 =>
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '1';
			B_Load <= '0';
			ALU_Sel <= ALU_INCA;
			CCR_Load <= '1';
			Bus1_Sel <= "01"; -- (00)PC	(01)A		(10)B
			Bus2_Sel <= "00"; -- (00)ALU	(01)Bus1	(10)from_memory
			write <= '0';
			halted <= '0';

		-- Increment B
		when S_INCB_4 =>
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '0';
			B_Load <= '1';
			ALU_Sel <= ALU_INCB;
			CCR_Load <= '1';
			Bus1_Sel <= "01"; -- (00)PC	(01)A		(10)B
			Bus2_Sel <= "00"; -- (00)ALU	(01)Bus1	(10)from_memory
			write <= '0';
			halted <= '0';

		-- Decrement A
		when S_DECA_4 =>
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '1';
			B_Load <= '0';
			ALU_Sel <= ALU_DECA;
			CCR_Load <= '1';
			Bus1_Sel <= "01"; -- (00)PC	(01)A		(10)B
			Bus2_Sel <= "00"; -- (00)ALU	(01)Bus1	(10)from_memory
			write <= '0';
			halted <= '0';

		-- Decrement B
		when S_DECB_4 =>
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '0';
			B_Load <= '1';
			ALU_Sel <= ALU_DECB;
			CCR_Load <= '1';
			Bus1_Sel <= "01"; -- (00)PC	(01)A		(10)B
			Bus2_Sel <= "00"; -- (00)ALU	(01)Bus1	(10)from_memory
			write <= '0';
			halted <= '0';
		
		when	S_HALT_4	=>
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '0';
			B_Load <= '0';
			ALU_Sel <= "000";
			CCR_Load <= '0';
			Bus1_Sel <= "00"; -- doesn't matter
			Bus2_Sel <= "00"; -- doesn't matter
			write <= '0';
			halted <= '1';

		-- default behavior = do nothing
		-- This doesn't even increment the PC, so the program will hang if an unknown instruction is encountered
		when others =>
			IR_Load <= '0';
			MAR_Load <= '0';
			PC_Load <= '0';
			PC_Inc <= '0';
			A_Load <= '0';
			B_Load <= '0';
			ALU_Sel <= "000";
			CCR_Load <= '0';
			Bus1_Sel <= "00"; -- doesn't matter
			Bus2_Sel <= "00"; -- doesn't matter
			write <= '0';
		end case;
	end process;

end architecture;