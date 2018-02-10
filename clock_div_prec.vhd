library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity clock_div_prec is
		port (Clock_in		:		in		std_logic;
				Reset 		: 		in		std_logic;
				Sel			: 		in		std_logic_vector (1 downto 0);
				Clock_out	:		out	std_logic);
end entity;

architecture clock_div_prec_arch of clock_div_prec is
	signal	counter_max	:		unsigned(31 downto 0);
	signal	counter		:		unsigned(31 downto 0);

	signal	current_Clock	:	std_logic;
begin

	CLK_SEL	:	process (Reset, Sel)
	begin
		if (Reset = '0') then
			counter_max <= to_unsigned(25000000,32);
		else
			case (Sel) is
				when "00" => counter_max <= to_unsigned(25000000,32);
				when "01" => counter_max <= to_unsigned(2500000,32);
				when "10" => counter_max <= to_unsigned(250000,32);
				when "11" => counter_max <= to_unsigned(25000,32);
				when others => counter_max <= to_unsigned(25000000,32);
			end case;
		end if;
	end process;

	COUNTING	:	process (Reset, Clock_in)
	begin
		if (Reset = '0') then
			counter <= to_unsigned(0,32);
			Clock_out <= '0';
			current_Clock <= '0';
		elsif (rising_edge(Clock_in)) then
			counter <= counter + to_unsigned(1,32);
			if (counter >= counter_max) then
				counter <= to_unsigned(0,32);
				Clock_out <= not current_Clock;
				current_Clock <= not current_Clock;
			end if;
		end if;
	end process;

end architecture;