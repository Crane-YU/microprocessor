LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

--This is a hexadecimal decoder which converting 4 bit binary code
--to 7 segment hexadecimal number
ENTITY add16 IS
PORT (  c_in : IN std_logic;
        x, y : IN std_logic_vector(15 downto 0);
           s : OUT std_logic_vector(15 downto 0);
		   c_out : OUT std_logic);
END;

ARCHITECTURE behaviour OF add16 IS
COMPONENT FA IS
  PORT ( a, b, cin : IN std_logic;
              c, s : OUT std_logic);
END COMPONENT;
	signal temp: std_logic_vector(15 downto 0);
BEGIN
temp(0) <= c_in;

m0: FA PORT MAP(x(0),y(0),temp(0),temp(1),s(0));
m1: FA PORT MAP(x(1),y(1),temp(1),temp(2),s(1));
m2: FA PORT MAP(x(2),y(2),temp(2),temp(3),s(2));
m3: FA PORT MAP(x(3),y(3),temp(3),temp(4),s(3));
m4: FA PORT MAP(x(4),y(4),temp(4),temp(5),s(4));
m5: FA PORT MAP(x(5),y(5),temp(5),temp(6),s(5));
m6: FA PORT MAP(x(6),y(6),temp(6),temp(7),s(6));
m7: FA PORT MAP(x(7),y(7),temp(7),temp(8),s(7));
m8: FA PORT MAP(x(8),y(8),temp(8),temp(9),s(8));
m9: FA PORT MAP(x(9),y(9),temp(9),temp(10),s(9));
m10: FA PORT MAP(x(10),y(10),temp(10),temp(11),s(10));
m11: FA PORT MAP(x(11 ),y(11),temp(11),temp(12),s(11));
m12: FA PORT MAP(x(12),y(12),temp(12),temp(13),s(12));
m13: FA PORT MAP(x(13),y(13),temp(13),temp(14),s(13));
m14: FA PORT MAP(x(14),y(14),temp(14),temp(15),s(14));
m15: FA PORT MAP(x(15),y(15),temp(15),c_out,s(15));

END behaviour;
