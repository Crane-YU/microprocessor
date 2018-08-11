LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY progMem16 IS
GENERIC ( S : INTEGER := 21;
          N : INTEGER := 16 );
	-- S is the memory size (number of words, must be less than or equal to 2^N),
        -- N is the address size (number of bits)
        -- number of data (q) bits is fixed at 16
port(
  clock        : in std_logic;
  data         : in std_logic_vector (15 downto 0);
  write_addr   : in std_logic_vector (N-1 downto 0);
  read_addr    : in std_logic_vector (N-1 downto 0);
  write_enable : in std_logic;
  q            : out std_logic_vector (15 downto 0));
END;

ARCHITECTURE behavioral OF progMem16  IS
  TYPE mem IS ARRAY (S-1 downto 0) OF std_logic_vector(15 downto 0);

  FUNCTION initialize_ram RETURN mem IS
  VARIABLE result : mem;
  BEGIN

		result(0) := "0000000000000000"; -- Load R0, data
		result(1) := "0010101000000000"; -- data(2A00)
		result(2) := "0000000100000000"; -- Load R1, data
		result(3) := "1000100000110001"; -- data(8831)
		result(4) := "0100001100000000"; --ldpc R3
		result(5) := "0010000000010000"; -- Add R0, R1
		result(6) := "0101001100000000"; --branch R3
    return result;
  END initialize_ram;

  SIGNAL raMem : mem := initialize_ram;
BEGIN
  PROCESS (clock)
  BEGIN
    IF clock'event and clock = '1' THEN
      IF write_enable = '1' THEN
        raMem(to_integer(unsigned(write_addr))) <= data;
      END IF;
      q <= raMem(to_integer(unsigned(read_addr)));
    END IF;
  END PROCESS;
END behavioral;
