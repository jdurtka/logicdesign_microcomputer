--	Entity:				computer/memory/rom_128x8_sync
--	Class/Project:			EELE 367 Logic Design
--	Author:				James Durtka
--	Initiated:			April 14, 2016

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.constants.all;

entity alu is
	port(
		ALU_Sel				:	in	std_logic_vector(2 downto 0);
		B				:	in	std_logic_vector(7 downto 0);
		BUS1				:	in	std_logic_vector(7 downto 0);
		NZVC				:	out	std_logic_vector(3 downto 0);
		result				:	out	std_logic_vector(7 downto 0)
	);
end entity;

architecture alu_arch of alu is

begin

	ALU_PROCESS : process (BUS1, B, ALU_Sel)
		variable Sum_uns : unsigned (8 downto 0);
	begin
		--Sum
		if (ALU_Sel = ALU_ADD) then
			Sum_uns := unsigned('0' & BUS1) + unsigned('0' & B);
			Result <= std_logic_vector(Sum_uns(7 downto 0));

			--NZVC flags
			--N
			NZVC(3) <= Sum_uns(7);
			

			--Z
			if (Sum_uns(7 downto 0) = x"00") then
				NZVC(2) <= '1';
			else
				NZVC(2) <= '0';
			end if;

			--V
			if ((BUS1(7)='0' and B(7)='0' and Sum_uns(7)='1') or (BUS1(7)='1' and B(7)='1' and Sum_uns(7)='0')) then
				NZVC(1) <= '1';
			else
				NZVC(1) <= '0';
			end if;

			--C
			NZVC(0) <= Sum_uns(8);

		--Difference
		elsif (ALU_Sel = ALU_SUB) then
			Sum_uns := unsigned('0' & BUS1) - unsigned('0' & B);
			Result <= std_logic_vector(Sum_uns(7 downto 0));

			--NZVC flags
			--N
			NZVC(3) <= Sum_uns(7);
			

			--Z
			if (Sum_uns(7 downto 0) = x"00") then
				NZVC(2) <= '1';
			else
				NZVC(2) <= '0';
			end if;

			--V
			if ((BUS1(7)='0' and B(7)='1' and Sum_uns(7)='1') or (BUS1(7)='1' and B(7)='0' and Sum_uns(7)='0')) then
				NZVC(1) <= '1';
			else
				NZVC(1) <= '0';
			end if;

			--C
			NZVC(0) <= Sum_uns(8);

		--Logic AND
		elsif (ALU_Sel = ALU_AND) then
			Sum_uns := unsigned('0' & BUS1) and unsigned('0' & B);
			Result <= std_logic_vector(Sum_uns(7 downto 0));

			--NZVC flags
			--N
			NZVC(3) <= Sum_uns(7);
			

			--Z
			if (Sum_uns(7 downto 0) = x"00") then
				NZVC(2) <= '1';
			else
				NZVC(2) <= '0';
			end if;

			--V
			NZVC(1) <= '0';

			--C
			NZVC(0) <= '0';

		--Logic OR
		elsif (ALU_Sel = ALU_OR) then
			Sum_uns := unsigned('0' & BUS1) or unsigned('0' & B);
			Result <= std_logic_vector(Sum_uns(7 downto 0));

			--NZVC flags
			--N
			NZVC(3) <= Sum_uns(7);
			

			--Z
			if (Sum_uns(7 downto 0) = x"00") then
				NZVC(2) <= '1';
			else
				NZVC(2) <= '0';
			end if;

			--V
			NZVC(1) <= '0';

			--C
			NZVC(0) <= '0';

		--Increment A register
		elsif (ALU_Sel = ALU_INCA) then
			Sum_uns := unsigned('0' & BUS1) + unsigned('0' & ONE_8BIT);
			Result <= std_logic_vector(Sum_uns(7 downto 0));

			--NZVC flags
			--N
			NZVC(3) <= Sum_uns(7);
			

			--Z
			if (Sum_uns(7 downto 0) = x"00") then
				NZVC(2) <= '1';
			else
				NZVC(2) <= '0';
			end if;

			--V
			if ((BUS1(7)='0' and Sum_uns(7)='1')) then
				NZVC(1) <= '1';
			else
				NZVC(1) <= '0';
			end if;

			--C
			NZVC(0) <= Sum_uns(8);

		--Increment B register
		elsif (ALU_Sel = ALU_INCB) then
			Sum_uns := unsigned('0' & B) + unsigned('0' & ONE_8BIT);
			Result <= std_logic_vector(Sum_uns(7 downto 0));

			--NZVC flags
			--N
			NZVC(3) <= Sum_uns(7);
			

			--Z
			if (Sum_uns(7 downto 0) = x"00") then
				NZVC(2) <= '1';
			else
				NZVC(2) <= '0';
			end if;

			--V
			if ((B(7)='0' and Sum_uns(7)='1')) then
				NZVC(1) <= '1';
			else
				NZVC(1) <= '0';
			end if;

			--C
			NZVC(0) <= Sum_uns(8);

		elsif (ALU_Sel = ALU_DECA) then
			Sum_uns := unsigned('0' & BUS1) - unsigned('0' & ONE_8BIT);
			Result <= std_logic_vector(Sum_uns(7 downto 0));

			--NZVC flags
			--N
			NZVC(3) <= Sum_uns(7);
			

			--Z
			if (Sum_uns(7 downto 0) = x"00") then
				NZVC(2) <= '1';
			else
				NZVC(2) <= '0';
			end if;

			--V
			if ((BUS1(7)='1' and Sum_uns(7)='1')) then
				NZVC(1) <= '1';
			else
				NZVC(1) <= '0';
			end if;

			--C
			NZVC(0) <= Sum_uns(8);

		elsif (ALU_Sel = ALU_DECB) then
			Sum_uns := unsigned('0' & B) - unsigned('0' & ONE_8BIT);
			Result <= std_logic_vector(Sum_uns(7 downto 0));

			--NZVC flags
			--N
			NZVC(3) <= Sum_uns(7);
			

			--Z
			if (Sum_uns(7 downto 0) = x"00") then
				NZVC(2) <= '1';
			else
				NZVC(2) <= '0';
			end if;

			--V
			if ((B(7)='1' and Sum_uns(7)='1')) then
				NZVC(1) <= '1';
			else
				NZVC(1) <= '0';
			end if;

			--C
			NZVC(0) <= Sum_uns(8);



		end if;
	end process;

end architecture;