LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

ENTITY FA IS
PORT ( a, b, cin : IN std_logic;
            c, s : OUT std_logic);
END;

ARCHITECTURE behaviour OF FA IS
SIGNAL m : std_logic;
BEGIN
m <= a xor b;
s <= m xor cin;
c <= (a and b) or (cin and a) or (cin and b);
END behaviour;
