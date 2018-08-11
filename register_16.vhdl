LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY register_16 IS
port(
  clock        : in std_logic;
  bus_in       : in std_logic_vector (15 downto 0);
  enable: in std_logic;
  data_out     : out std_logic_vector (15 downto 0));
END;

ARCHITECTURE  behaviour OF register_16 IS
BEGIN
  PROCESS (clock)
  BEGIN
    IF clock'event and clock = '1' THEN
      IF enable = '1' THEN
         data_out<= bus_in;
      END IF;
    END IF;
  END PROCESS;
END behaviour;
