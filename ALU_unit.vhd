LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

ENTITY ALU_unit is
  port( Ain,Bin : IN std_logic_vector(15 downto 0);
   funcSelector : IN std_logic_vector(1 downto 0);
		       Gout : OUT std_logic_vector(15 downto 0));
end;

ARCHITECTURE behaviour of ALU_unit is
  COMPONENT add16 is
    PORT( c_in : IN std_logic;
          x, y : IN std_logic_vector(15 downto 0);
             s : OUT std_logic_vector(15 downto 0);
    		 c_out : OUT std_logic);
  END COMPONENT;

  COMPONENT XOR16 is
    port( x, y : IN std_logic_vector(15 downto 0);
	           r : OUT std_logic_vector(15 downto 0));
  END COMPONENT;

  signal add_result : std_logic_vector(15 downto 0);
  signal xor_result : std_logic_vector(15 downto 0);
  signal result : std_logic_vector(15 downto 0);
  signal carry: std_logic;

BEGIN
  f0: add16 PORT MAP ('0', Ain, Bin, add_result, carry);-- carry in is 0
  f1: XOR16 PORT MAP (Ain, Bin, xor_result);

  PROCESS(funcSelector)
  begin
  if(funcSelector = "01") THEN
    Gout <= add_result;
  END IF;
  IF(funcSelector = "10") THEN
    Gout <= xor_result;
  END IF;
  IF(funcSelector = "00") THEN
    Gout <= "0000000000000000";
  END IF;
  IF(funcSelector = "11")
    Gout <= "0000000000000000";
  END IF;

  END PROCESS;
end behaviour;
