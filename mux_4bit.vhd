-- This is a 4bit width 2 to 1 multiplexer
library ieee;
use ieee.std_logic_1164.all;

entity mux_4bit is
	port ( x,y : IN std_logic_vector(3 downto 0);
	       s   : IN std_logic;
			   m   : OUT std_logic_vector(3 downto 0));
end;

ARCHITECTURE behaviour of mux_4bit IS
begin
  Process(s)
  begin
  IF s = '1' THEN
    m <= y;
  ELSE
    m <= x;
  END IF;
  END PROCESS;

END;
