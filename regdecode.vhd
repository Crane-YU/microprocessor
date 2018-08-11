-- This is a operand decoder which convert binary encode
-- to one hot encode
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY regdecode IS
PORT ( Rin : IN std_logic_vector(3 downto 0);
       Rout: OUT std_logic_vector(3 downto 0));
END;
ARCHITECTURE behaviour OF regdecode IS
BEGIN
	process(Rin)
	begin
	case Rin is
	WHEN  "0000" =>
		Rout<="0001";
	WHEN  "0001" =>
		Rout <= "0010";
	WHEN "0010" =>
		Rout<="0100";
	WHEN  "0011" =>
		Rout <= "1000";
	WHEN OTHERS =>
	   Rout <= "0000";
	END CASE;
end process;

END behaviour;
