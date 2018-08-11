LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY TriState IS
PORT(
     Sig_in : in std_logic_vector(15 downto 0);
     enable : in std_logic;
		Sig_out : out std_logic_vector(15 downto 0));
END TriState;

ARCHITECTURE BEHAVIOUR of TriState IS
	BEGIN
	PROCESS (Sig_in, enable)
	BEGIN
	IF (enable = '1') THEN
      Sig_out <= Sig_in;
	ELSE
			Sig_out <= (OTHERS => 'Z');
	END IF;
	END PROCESS;
END BEHAVIOUR;
