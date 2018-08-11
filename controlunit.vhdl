LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

ENTITY controlunit IS
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
END;

ARCHITECTURE behaviour OF controlunit IS

 COMPONENT regdecode
  PORT ( Rin : IN std_logic_vector(3 downto 0);
         Rout: OUT std_logic_vector(3 downto 0));
	END COMPONENT;

	COMPONENT mux_3to1_4bit
  port ( x, y, z : IN std_logic_vector(3 downto 0);
          s1, s2 : IN std_logic;
               m : OUT std_logic_vector(3 downto 0));
	END COMPONENT;

	TYPE State_type IS (Load1_State, Load2_State, Move, Add1_state, Add2_state, Add3_state,
                      ldpc_state, XOR1_state, XOR2_state, XOR3_state, branch_state, Rest_state);
	SIGNAL present_state, next_state : State_type;
	signal Rxtemp, Rytemp : std_logic_vector(3 downto 0);
	signal func_name : std_logic_vector(2 downto 0);
	signal Rx : std_logic_vector(3 downto 0);
	signal Ry : std_logic_vector(3 downto 0);
	signal R1in_Selector,R1out_Selector : std_logic;
	signal R2in_Selector,R2out_Selector : std_logic;

BEGIN
   func_name <= instruction(14 downto 12);-- using 3 bits as the function input
	 Rx <= instruction(11 downto 8);
	 Ry <= instruction(7 downto 4);
   -- choose which two registers to implement the function
   r0: regdecode PORT MAP(Rx, Rxtemp);
   r1: regdecode PORT MAP(Ry, Rytemp);
	 m0: mux_3to1_4bit PORT MAP("0000", Rxtemp, Rytemp, R1in_Selector, R2in_Selector, RIN);
	 m1: mux_3to1_4bit PORT MAP("0000", Rxtemp, Rytemp, R1out_Selector, R2out_Selector, ROUT);

PROCESS(Clock, Reset)
	 BEGIN
	 IF Reset = '1' THEN
	     present_state <= Rest_state;
	 ELSIF (Clock'EVENT AND Clock = '1') THEN
	     present_state <= next_state;
	 END IF;
END PROCESS;

PROCESS (present_state, w, func_name) -- finite state table
		BEGIN
		CASE present_state IS

		WHEN Rest_state => -- everything is off, set to 0
				R1in_Selector  <= '0';
				R2in_Selector  <= '0';
				R1out_Selector <= '0';
				R2out_Selector <= '0';
				ALU <= "00";
				Ain <= '0';
				Gin <= '0';
				Gout <= '0';
				PCin <= '0';
				PCout <= '0';
				Extern <= '0';
		    done <= '0' ;
				IF (  w = '1' and func_name = "000") THEN
						next_state <= Load1_State ;
						nextaddress <= '1';
				ELSIF(  w = '1' and func_name = "001" )THEN
					   next_state <= Move ;
						nextaddress <= '1';
				ELSIF( w = '1' and func_name = "010" ) THEN
						next_state <= Add1_state ;
						nextaddress <= '1';
				ELSIF( w = '1' and func_name = "011" )THEN
					   next_state <= XOR1_state ;
						nextaddress <= '1';
				ELSIF( w = '1' and func_name = "100" )THEN
					   next_state <= ldpc_state ;
						nextaddress <= '0';
				ELSIF( w = '1' and func_name = "101" )THEN
					   next_state <= branch_state ;
						nextaddress <= '0';
				ELSE
					next_state <= Rest_state;
					nextaddress <= '0';
				END IF;

-- load data into Rx
		WHEN Load1_State =>
				PCin <= '0';
				PCout <= '0';
		    nextaddress <= '0';
		    R1in_Selector <= '1' ;
				R2in_Selector  <= '0';
				R1out_Selector <= '0';
				R2out_Selector <= '0';
				ALU <= "00";
				Ain <= '0';
				Gin <= '0';
				Gout <= '0';
			  Extern <= '1';
				next_state <= Load2_State;
        done <= '0' ;

-- changde address memory
		WHEN Load2_State =>
        R1in_Selector  <= '0';
				R2in_Selector  <= '0';
				R1out_Selector <= '0';
				R2out_Selector <= '0';
				ALU <= "00";
				Ain <= '0';
				Gin <= '0';
				Gout <= '0';
			  Extern <= '0';
        done <= '1' ;
		    nextaddress <= '1';
				PCin <= '0';
				PCout <= '0';
				next_state <= Rest_state;
-- move R2 into R1
		WHEN Move =>
		    R1in_Selector  <= '1';
				R2in_Selector  <= '0';
				R1out_Selector <= '0';
				R2out_Selector <= '1';
				ALU <= "00";
				Ain <= '0';
				Gin <= '0';
				Gout <= '0';
				PCin <= '0';
				PCout <= '0';
			  Extern <= '0';
			  next_state <= Rest_state;
				done <= '1';
				nextaddress <= '0';
-- save R1 value into Register A
    WHEN Add1_state =>
		    R1in_Selector  <= '0';
				R2in_Selector  <= '0';
		    R1out_Selector <= '1';
				R2out_Selector <= '0';
				Ain <= '1';
				Gin <= '0';
				Gout <= '0';
				PCin <= '0';
				PCout <= '0';
				ALU <= "00";
			  Extern <= '0';
				next_state <= Add2_state;
				done <= '0';
				nextaddress <= '0';
-- do the addition and save the value into Register G
		WHEN Add2_state =>
		    R1in_Selector <= '0' ;
				R2in_Selector <= '0';
		    R1out_Selector <= '0';
		    R2out_Selector <= '1';
				Ain <= '0';
				Gin <= '1';
				Gout <= '0';
				PCin <= '0';
				PCout <= '0';
				ALU <= "01";
				Extern <= '0';
			  next_state <= Add3_state;
				done <= '0';
				nextaddress <= '0';
-- lead the value of G into bus wire and store the value into R1
		WHEN Add3_state =>
		    R1in_Selector <= '1' ;
				R2in_Selector <= '0';
		    R1out_Selector <= '0';
		    R2out_Selector <= '0';
				Ain <= '0';
				Gin <= '0';
		    Gout <= '1';
				PCin <= '0';
				PCout <= '0';
				ALU <= "00";
				Extern <= '0';
			  next_state <= Rest_state ;
				done <= '1';
				nextaddress <= '0';

		WHEN XOR1_state =>
		    R1in_Selector <= '0' ;
				R2in_Selector <= '0';
		    R1out_Selector <= '1';
		    R2out_Selector <= '0';
				Ain <= '1';
				Gin <= '0';
				Gout <= '0';
				PCin <= '0';
				PCout <= '0';
				ALU <= "00";
				Extern <= '0';
			  next_state <= XOR2_state;
				nextaddress <= '0';
				done <= '0';

		WHEN XOR2_state =>
		    R1in_Selector <= '0' ;
				R2in_Selector <= '0';
		    R1out_Selector <= '0';
		    R2out_Selector <= '1';
				Ain <= '0';
				Gin <= '1';
				Gout <= '0';
				PCin <= '0';
				PCout <= '0';
				ALU <= "10";
				Extern <= '0';
			  next_state <= XOR3_state;
				nextaddress <= '0';
				done <= '0';

		WHEN XOR3_state =>
				R1in_Selector <='1';
				R2in_Selector <= '0';
		    R1out_Selector <= '0';
		    R2out_Selector <= '0';
				Ain <= '0';
				Gin <= '0';
				Gout <= '1' ;
				PCin <= '0';
				PCout <= '0';
				ALU <= "00";
				Extern <= '0';
				next_state <= Rest_state;
				done <= '1';
				nextaddress <= '0';
-- store the value into Register R1
		WHEN ldpc_state =>
		    R1in_Selector <='1';
				R2in_Selector <= '0';
		    R1out_Selector <= '0';
		    R2out_Selector <= '0';
				Ain <= '0';
				Gin <= '0';
				Gout <= '0' ;
				PCin <= '0';
				PCout <= '1';
				ALU <= "00";
				Extern <= '0';
				next_state <= Rest_state;
				done <= '1';
				nextaddress <= '0';

		WHEN branch_state =>
		      R1in_Selector <='0';
				R2in_Selector <= '0';
		      R1out_Selector <= '1';
		      R2out_Selector <= '0';
				Ain <= '0';
				Gin <= '0';
				Gout <= '0' ;
				PCin <= '1';
				PCout <= '0';
				ALU <= "00";
				Extern <= '0';
				next_state <= Rest_state;
				done <= '1';
				nextaddress <= '0';

	END CASE;
 END PROCESS;
END behaviour;
