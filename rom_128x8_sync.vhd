--	Entity:				computer/memory/rom_128x8_sync
--	Class/Project:			EELE 367 Logic Design
--	Author:				James Durtka
--	Initiated:			April 14, 2016

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;

use work.constants.all;

entity rom_128x8_sync is
	port	(			clock		:	in	std_logic;
					address		:	in	std_logic_vector (7 downto 0);
					data_out	:	out	std_logic_vector (7 downto 0)
	);
end entity;

architecture rom_128x8_sync_arch of rom_128x8_sync is

	type ROM_type is array (0 to 127) of std_logic_vector(7 downto 0);
	
	signal EN : std_logic;


	--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	--	ROM LISTING
	--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	--constant ROM : ROM_type := (	0	=> LDA_IMM,
	--				1	=> x"00",
	--				2	=> LDB_IMM,
	--				3	=> x"20",
	--				4	=> INCA,
	--				5 	=> STA_DIR,
	--				6	=> x"80",
	--				7	=> SUB_AB,
	--				8	=> BEQ,
	--				9	=> x"0E",
	--				10	=> LDA_DIR,
	--				11	=> x"80",
	--				12	=> BRA,
	--				13	=> x"04",
	--				14	=> HALT,

	--constant ROM : ROM_type := (	0	=> LDA_IMM,
	--				1	=> x"23",
	--				2	=> STA_DIR,
	--				3	=> x"08",
	--				4	=> LDA_DIR,
	--				5	=> x"08",
	--				6	=> BRA,
	--				7	=> x"00",
	--				others	=> x"00");
--		constant ROM : ROM_type := (
--				0 	=> LDA_DIR,
--				1 	=> x"F0",
--				2 	=> STA_DIR,
--				3 	=> x"E0",
--				4 	=> STA_DIR,
--				5 	=> x"E1",
--				6 	=> STA_DIR,
--				7 	=> x"E2",
--				8 	=> STA_DIR,
--				9 	=> x"E3",
--				10 => BRA,
--				11 => x"00",
--				others => x"00");

	--Test program: should run repeatedly and not halt.
	constant ROM : ROM_type := (
	
					-- James Durtka
					-- TEST PROGRAM: tests *all* the additional instructions
					-- 	What it should do:
					--			The program loops repeatedly, displaying in the leftmost hex display the number of times it has run
					--			The first operation adds 0+0, which should obviously be 00, and puts it in the rightmost display.
					--			Next, we use test patterns AA and 0F. AND goes to middle display (should be 0A) and OR goes to
					--			rightmost display (should be AF). Finally, we do a subtraction, 0xAF-0x30 which should result in 0x7F.
					--			This is displayed in the middle display again. Then we loop through again, incrementing the leftmost display.
					--
					--			Throughout operation, we are doing the conditional branching. If the flags are incorrect, we will either HALT
					--			or end up in an infinite loop. Therefore, as long as the program keeps running, we know that the flags we are
					--			testing are set correctly (i.e. the program is correct and, as well, the branch instructions are working correctly).
					--
					--			Thus: the fact that the program keeps running forever is proof that the branch instructions work.
					--					The fact that the displayed values are as they should be is proof that the arithmetic/logic instructions work.
	
					-- Store 0 to 0x84 at the beginning of the program.
					--	This is our counter for how many times the program has run all the way through.
					0	=> STA_DIR,
					1	=> x"84",
	
	
					-- Initially all four NZVC should be zero, so the first four branches should pass right through
					-- (infinite loop if this test fails)
					
					2	=> BEQ,
					3	=> x"00",
					4	=> BCS,
					5	=> x"00",
					6	=> BVS,
					7	=> x"00",
					8	=> BMI,
					9	=> x"00",

					-- Now we're sure none of the branches go anywhere when they shouldn't. Let's test arithmetic/logic instructions
					10	=> DECA,
					11	=> INCB,
					12	=> ADD_AB,
					
					--Display result - should be 00
					13	=> STA_DIR,
					14 => x"E1",

					-- This should result in 0xFF + 0x01 == 0x00 + carry: NZVC = "0101"
					-- Both of these instructions should definitely branch
					-- (We will return to the other two flags later)
					15	=> BEQ,
					16	=> x"12",
						--HALT instruction is a non-standard extension that freezes the processor forever.
						--This program is written such that if the processor is working correctly, no HALT should ever take place.
					17	=> HALT,
					18	=> BCS,
					19	=> x"15",
					20	=> HALT,

					-- Make sure the other two (INCA and DECB) work correctly:
					-- A should be 1 and B should be zero.
					21	=> INCA,
					22	=> DECB,

					-- Now let's load some nice test patterns for the logical operators
					-- Also: test the LDB_IMM, STB_DIR, LDB_DIR
					23	=> LDA_IMM,
					24	=> x"AA",	-- "10101010"
					25	=> LDB_IMM,
					26	=> x"0F",	-- "00001111"
					27	=> STB_DIR,
					28	=> x"80",
					29	=> DECB,
					30	=> LDB_DIR,
					31	=> x"80",
					32	=> STA_DIR,
					33	=> x"81",

					-- Now test the logical operators (reload A after the first test)
					-- These display to the two LCDs: the results should be 0A and AF, respectively.
					34	=> AND_AB,	-- should be "00001010" or 0x0A
					35 => STA_DIR,
					36 => x"E2",
					37	=> LDA_DIR,
					38	=> x"81",
					39	=> OR_AB,	-- should be "10101111", or 0xAF
					40 => STA_DIR,
					41 => x"E1",
					
					-- Test subtraction
					42	=> LDA_IMM,
					43	=> x"AF",
					44	=> LDB_IMM,
					45	=> x"30",
					46	=> SUB_AB,
					-- Display the result = should be 0x80
					47	=> STA_DIR,
					48	=> x"E2",

					-- Finally, test the other two flags (Negative and Overflow)
					49	=> INCA,
					-->Should result in both NZVC = "1010"
					
					
					50	=> BMI,
					51	=> x"35",
					52	=> HALT,
					53	=> BVS,
					54	=> x"38",
					55	=> HALT,
					
					-- Keep track of how many times this program has been run before running through it again
					56	=> LDA_DIR,
					57	=> x"84",
					58	=> INCA,
					59 => STA_DIR,
					60 => x"84",
					61	=> STA_DIR,
					62	=> x"E3",
					
					-- Everything has been tested. Return registers and flags to pristine state and start over
					63	=> LDA_IMM,
					64	=> x"00",
					65	=> LDB_IMM,
					66	=> x"01",
					67	=> ADD_AB,	----> NZVC = "0000"
					68	=> LDA_IMM,
					69	=> x"00",
					70	=> LDB_IMM,
					71	=> x"00",
					
					72	=> BRA,
					73	=> x"02",

					others	=> HALT);
	--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
				
	--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


begin

	ENABLE : process(address)
	begin
		if ((to_integer(unsigned(address)) >= 0) and (to_integer(unsigned(address)) <= 127)) then
			EN <= '1';
		else
			EN <= '0';
		end if;
	end process;


	MEMORY : process (clock)
	begin
		if (rising_edge(clock)) then
			if (EN='1') then
				data_out <= ROM(to_integer(unsigned(address)));
			end if;
		end if;
	end process;

end architecture;