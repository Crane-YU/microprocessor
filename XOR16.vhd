-- This is a 16 bit XOR circuit
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
entity XOR16 is
  port( x, y : IN std_logic_vector(15 downto 0);
           r : OUT std_logic_vector(15 downto 0));
end;

ARCHITECTURE behaviour of XOR16 IS
begin
 r <= x XOR y;
end;
