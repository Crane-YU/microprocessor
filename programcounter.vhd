-- This is a program counter is a special register which record
-- the address of memory pointer, and can be modify by Control
-- unit directly
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use ieee.std_logic_signed.all;
ENTITY programcounter IS
port(
  clock        : in std_logic;
  reset        : in std_logic;
  done         : in std_logic_vector (15 downto 0);
  data_out     : out std_logic_vector (15 downto 0));
END;

ARCHITECTURE  behaviour OF programcounter IS
signal tempout : std_logic_vector (15 downto 0);
BEGIN
  data_out <= tempout;
  PROCESS (clock,reset,nextaddress,busin_enable)
  BEGIN
  IF Reset = '1' THEN
		  tempout <= "0000000000000000";
  ELSIF clock'event and clock = '1' THEN
      IF done = '1' THEN
         tempout<= tempout+1;
      END IF;
  END IF;
  END PROCESS;
  data_out <= tempout;
END behaviour;
