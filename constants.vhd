library IEEE;
use IEEE.std_logic_1164.all; 

package constants is
	--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	--	OPCODE MNEMONIC DEFINITIONS
	--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	constant  LDA_IMM	: std_logic_vector(7 downto 0) :=  x"86";
	constant  LDA_DIR	: std_logic_vector(7 downto 0) :=  x"87";
	constant  LDB_IMM	: std_logic_vector(7 downto 0) :=  x"88";
	constant  LDB_DIR	: std_logic_vector(7 downto 0) :=  x"89";

	constant  STA_DIR	: std_logic_vector(7 downto 0) :=  x"96";
	constant  STB_DIR	: std_logic_vector(7 downto 0) :=  x"97";

	constant  ADD_AB	: std_logic_vector(7 downto 0) :=  x"42";
	constant  SUB_AB	: std_logic_vector(7 downto 0) :=  x"43";
	constant  AND_AB	: std_logic_vector(7 downto 0) :=  x"44";
	constant  OR_AB		: std_logic_vector(7 downto 0) :=  x"45";
	constant  INCA		: std_logic_vector(7 downto 0) :=  x"46";
	constant  INCB		: std_logic_vector(7 downto 0) :=  x"47";
	constant  DECA		: std_logic_vector(7 downto 0) :=  x"48";
	constant  DECB		: std_logic_vector(7 downto 0) :=  x"49";

	constant  BRA		: std_logic_vector(7 downto 0) :=  x"20";
	constant  BMI		: std_logic_vector(7 downto 0) :=  x"21";
	constant  BPL		: std_logic_vector(7 downto 0) :=  x"22";
	constant  BEQ		: std_logic_vector(7 downto 0) :=  x"23";
	constant  BNE		: std_logic_vector(7 downto 0) :=  x"24";
	constant  BVS		: std_logic_vector(7 downto 0) :=  x"25";
	constant  BVC		: std_logic_vector(7 downto 0) :=  x"26";
	constant  BCS		: std_logic_vector(7 downto 0) :=  x"27";
	constant  BCC		: std_logic_vector(7 downto 0) :=  x"28";

	constant  NOP		: std_logic_vector(7 downto 0) :=  x"00";
	constant  HALT		: std_logic_vector(7 downto 0) :=  x"FF";
	--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx



	--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	--	ALU OPERATIONS
	--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	constant ALU_ADD	: std_logic_vector(2 downto 0) := "000";
	constant ALU_SUB	: std_logic_vector(2 downto 0) := "001";
	constant ALU_AND	: std_logic_vector(2 downto 0) := "010";
	constant ALU_OR		: std_logic_vector(2 downto 0) := "011";
	constant ALU_INCA	: std_logic_vector(2 downto 0) := "100";
	constant ALU_INCB	: std_logic_vector(2 downto 0) := "101";
	constant ALU_DECA	: std_logic_vector(2 downto 0) := "110";
	constant ALU_DECB	: std_logic_vector(2 downto 0) := "111";

	constant ZERO_8BIT	: std_logic_vector(7 downto 0) := "00000000"; 
	constant ONE_8BIT	: std_logic_vector(7 downto 0) := "00000001";

end package;