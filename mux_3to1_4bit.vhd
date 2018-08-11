-- This is a 4 bit width  3 to 1 multiplexer.
-- It is a combination of two 2 to 1 multiplexer
library ieee;
use ieee.std_logic_1164.all;

entity mux_3to1_4bit is
	port ( x, y, z : IN std_logic_vector(3 downto 0);
	        s1, s2 : IN std_logic;
			         m : OUT std_logic_vector(3 downto 0));
end;

ARCHITECTURE behaviour of mux_3to1_4bit IS
  COMPONENT mux_4bit
  port ( x,y : IN std_logic_vector(3 downto 0);
         s   : IN std_logic;
         m   : OUT std_logic_vector(3 downto 0));
	END COMPONENT;

signal temp : std_logic_vector(3 downto 0);

BEGIN
m0: mux_4bit PORT MAP(x,y,s1,temp);
m1: mux_4bit PORT MAP(temp,z,s2,m);
END behaviour;
