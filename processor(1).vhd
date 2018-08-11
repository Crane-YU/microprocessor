LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

ENTITY processor IS
generic(S : integer := 21;
        N : integer := 16);
PORT(SW   : IN std_logic_vector(17 downto 0);-- control reset and w
     KEY  : IN std_logic_vector(3 downto 0);-- control clock
		 LEDR : OUT std_logic_vector(17 downto 0);
		 HEX0 : OUT std_logic_vector(6 downto 0);
		 HEX1 : OUT std_logic_vector(6 downto 0);
		 HEX2 : OUT std_logic_vector(6 downto 0);
		 HEX3 : OUT std_logic_vector(6 downto 0);
		 HEX4 : OUT std_logic_vector(6 downto 0);
		 HEX5 : OUT std_logic_vector(6 downto 0);
		 HEX6 : OUT std_logic_vector(6 downto 0);
		 HEX7 : OUT std_logic_vector(6 downto 0));
END processor;


ARCHITECTURE Behavior OF processor IS

  COMPONENT hexdecode
  port ( A : IN std_logic_vector(3 downto 0);
         D : OUT std_logic_vector(6 downto 0));
  END COMPONENT;

  COMPONENT TriState
  PORT(
      Sig_in : in std_logic_vector(15 downto 0);
      enable : in std_logic;
      Sig_out : out std_logic_vector(15 downto 0));
  END COMPONENT;

  COMPONENT register_16
  PORT(
    clock        : in std_logic;
    bus_in       : in std_logic_vector (15 downto 0);
    enable       : in std_logic;
    data_out     : out std_logic_vector (15 downto 0));
  END COMPONENT;

  COMPONENT ALU_unit
  port( Ain, Bin : IN std_logic_vector(15 downto 0);
   funcSelector  : IN std_logic_vector(1 downto 0);
           Gout  : OUT std_logic_vector(15 downto 0));
  END COMPONENT;

  COMPONENT controlunit
  PORT( Clock : IN std_logic;
        Reset : IN std_logic;
           w  : IN std_logic;
  instruction : IN std_logic_vector(15 downto 0);
  		    RIN : OUT std_logic_vector(3 downto 0);
  		   ROUT : OUT std_logic_vector(3 downto 0);
  		    ALU : OUT std_logic_vector(1 downto 0);
  		    Ain : OUT std_logic;
  	Gin, Gout : OUT std_logic;
  PCin, PCout : OUT std_logic;--program counter
  nextaddress : OUT std_logic;--memory address
  	 	 Extern : OUT std_logic;
  		   done : OUT std_logic);
  END COMPONENT;

	COMPONENT progMem16
	  port( 	clock        : in std_logic;
				data         : in std_logic_vector (15 downto 0);
				write_addr   : in std_logic_vector (N-1 downto 0);
				read_addr    : in std_logic_vector (N-1 downto 0);
				write_enable : in std_logic;
				q            : out std_logic_vector (15 downto 0));
	END COMPONENT;

	COMPONENT programcounter IS
	port(
       clock        : in std_logic;
       reset        : in std_logic;
       done         : in std_logic_vector (15 downto 0);
       data_out     : out std_logic_vector (15 downto 0));
  END COMPONENT;
  --Data signal
  signal buswire    : std_logic_vector(15 downto 0);
  signal R1outtemp  : std_logic_vector(15 downto 0);
  signal R2outtemp  : std_logic_vector(15 downto 0);
  signal R3outtemp  : std_logic_vector(15 downto 0);
  signal R4outtemp  : std_logic_vector(15 downto 0);
  signal Aouttemp   : std_logic_vector(15 downto 0);
  signal RAMouttemp : std_logic_vector(15 downto 0);
  signal PCouttemp  : std_logic_vector(15 downto 0);
  signal read_addr  : std_logic_vector(15 downto 0);
  signal ALUoutput  : std_logic_vector(15 downto 0);
  signal Gouttemp   : std_logic_vector(15 downto 0);
  --control signal
  signal Rin : std_logic_vector(3 downto 0);
  signal Rout: std_logic_vector(3 downto 0);
  signal Ain, Gin, Gout : std_logic;
  signal ALU: std_logic_vector(1 downto 0);
  signal extern ,done : std_logic;
  signal nextaddress : std_logic;
  signal PCout, PCin : std_logic;
  --operation signal
  signal Clock, Reset, W : std_logic ;
  signal funcI : std_logic_vector(15 downto 0);
  --display signal
  signal Display : std_logic_vector(15 downto 0);
  signal Display1 : std_logic_vector (15 downto 0);

 BEGIN
  LEDR(15 downto 0) <= buswire;
	Clock <= KEY(0);
	Reset <= SW(17);
	W     <= SW(16);

	-- Display on HEX
	Display <= R1outtemp;
	Display1 <= R2outtemp;
	-- Decode data to 7segment
	d5:   hexdecode PORT MAP(Display(3 downto 0), HEX0);
	d6:   hexdecode PORT MAP(Display(7 downto 4), HEX1);
	d7:   hexdecode PORT MAP(Display(11 downto 8), HEX2);
	d8:   hexdecode PORT MAP(Display(15 downto 12), HEX3);
	d9:   hexdecode PORT MAP(Display1(3 downto 0), HEX4);
	d10:  hexdecode PORT MAP(Display1(7 downto 4), HEX5);
	d11:  hexdecode PORT MAP(Display1(11 downto 8), HEX6);
	d12:  hexdecode PORT MAP(Display1(15 downto 12), HEX7);

	-- Control Unit
  m0: controlunit PORT MAP(Clock,Reset,W,funcI,Rin,Rout,ALU,Ain,Gin,Gout,PCin,PCout,nextaddress,extern,done);
	-- First register
  r1: register_16 PORT MAP(Clock,buswire,Rin(0),R1outtemp);
	t1: TriState PORT MAP(R1outtemp,Rout(0),buswire);
	-- Second register
  r2: register_16 PORT MAP(Clock,buswire,Rin(1),R2outtemp);
	t2: TriState PORT MAP(R2outtemp,Rout(1),buswire);
	-- Third register
  r3: register_16 PORT MAP(Clock,buswire,Rin(2),R3outtemp);
	t3: TriState PORT MAP(R3outtemp,Rout(2),buswire);
	-- Fourth register
  r4: register_16 PORT MAP(Clock,buswire,Rin(3),R4outtemp);
	t4: TriState PORT MAP(R4outtemp,Rout(3),buswire);
  -- A register
	r5: register_16 PORT MAP(Clock, buswire,Ain, Aouttemp);
	-- G register
	r6: register_16 PORT MAP(Clock, ALUoutput,Gin,Gouttemp);
	t6: TriState PORT MAP(Gouttemp,Gout,buswire);
	-- ALU unit
	a0: ALU_unit PORT MAP(Aouttemp,buswire,ALU,ALUoutput);
	-- RAM
	p0: progMem16 PORT MAP (Clock,"0000000000000000","0000000000000000",read_addr,'0',RAMouttemp);
	t7: TriState PORT MAP (RAMouttemp, extern, buswire);
	-- instruction register
	r7: register_16 PORT MAP(Clock, RAMouttemp, done, funcI);
   -- program counter
	r8: programcounter PORT MAP(Clock,Reset,done,read_addr);
	t8: TriState PORT MAP(read_addr,PCout,buswire);
 END Behavior;
