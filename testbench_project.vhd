LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
library STD;
use STD.textio.all;  

-- entity declaration for your testbench.Dont declare any ports here
ENTITY testbench_project IS 
END testbench_project;

ARCHITECTURE behavior OF testbench_project IS

	-- ------------------ Add Componenets ------------------
	-- Add your components here
COMPONENT processor 
PORT ( 
			
			w, clk,ret : IN STD_LOGIC;
			R0, R1, R2: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			BusWires: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
END COMPONENT;
	-- ------------------ Add Componenets ------------------
	
	-- cnt is for the testbench only, use to set test values for every clock cycle
	signal cnt: integer:= 0;
	
	-- Internal Signals
	-- Your circuit will need clk and reset signals.
	signal  reset_in,w_in  : STD_LOGIC;
	signal  clk_in: STD_LOGIC:= '0';
	-- For the initial part, it will also need an assembly code input
	signal R0,R1,R2,BusWires			: std_logic_vector(15 downto 0);
	
	-- For the testbench, the assembly code is 23 bits of the following form
	-- Load: 3 bit operation code (000), 4-bit destination register  (note x"" 
	-- means hex, so for example, x"A" would mean register 10), then 16-bit data 
	-- value (note once again this is defined using hex. e.g x"12AB" would equal
	-- "0001 0010 1010 1011")
	-- mov: 3 bit operation code (001), 4-bit destination register, 4-bit input register, 12 unused bits
	-- add: 3 bit operation code (010), 4-bit input and destination register, 4-bit input register, 12 unused bits
	-- add: 3 bit operation code (011), 4-bit input and destination register, 4-bit input register, 12 unused bits
	-- ldpc: 3 bit operation code (100), 4-bit destination register, 16 unused bits
	-- branch: 3 bit operation code (101), 4-bit destination register, 16 unused bits
	-- Feel free to create your own assembly code
	
	-- ------------------ Add Your Internal Signals (if needed) ------------------
	-- You may not need anything, you can design your processor to only
	-- use clk_in, reset_in and (assembly) code signals.
	-- If you instatiate multiple modules, you may need them
	-- ------------------ Add Your Internal Signals (if needed) ------------------
	
BEGIN
	
	-- ------------------ Instantiate modules ------------------
	-- Instantiate your processor here
	-- ------------------ Instantiate modules ------------------
	
	utt: processor port map(w=>w_in, clk=>clk_in, ret=>reset_in, R0=>R0, R1=>R1, R2=>R2, BusWires=>BusWires);
	-- Create a clk
	stim_proc: process 
	begin         
		wait for 50 ns;
		clk_in <= not(clk_in);
	end process;
	
	-- cnt is for the testbench only, use to set test values for every clock cycle
	stim_proc2: process(clk_in) 
	begin
		if rising_edge(clk_in) then
			cnt <= cnt+1;
		end if;
	end process;

	
	-- This is the 'program'. It loads 4 values into r0 to r3. 
	-- It then stores the current address location in r4
	-- It then branches to the 'sum' procedure, located at 50 in memory
	-- To do this, the value 50 is loaded into r5, then you branch to r5.
	-- After returning from branch, store the value in r6
	
	-- (IMPORTANT: you can use this testbench irrespective of the branching, 
	-- just do nothing for these commands)
	
	-- It then loads another 4 values into r0 to r3
	-- Performs the sum of these values and returns
	-- Finally it computes the xor of the two sums
	process (cnt)
	begin  
		case cnt is 
			-- Reset
			when 0 to 4		=> 	reset_in <= '1'; w_in <= '1';
			
			-- load 		r0 x"0001"
			when 5 to 9		=> 	reset_in <= '0'; w_in <= '1';
			--	load 		r1 x"0001"
			when 10 to 14	=> 	reset_in <= '0'; w_in <= '1';
			-- load 		r2 x"0020"
			when 15 to 19	=> 	reset_in <= '0'; w_in <= '1';
			--	load 		r3 x"0020"
			when 20 to 24	=> 	reset_in <= '0'; w_in <= '1';
			--	load 		r5 x"0050"
			when 25 to 29	=> 	reset_in <= '0'; w_in <= '1';
			--	ldpc 		r4 
			when 30 to 34	=> 	reset_in <= '0'; w_in <= '1';
			--	branch	r5
			when 35 to 39	=> 	reset_in <= '0'; w_in <= '1';
			
			-- add		r0	r1
			when 40 to 44	=> 	reset_in <= '0'; w_in <= '1';
			--	add		r0	r2
			when 45 to 49	=> reset_in <= '0'; w_in <= '1';
			-- add		r0	r3

			
			when others		=> 	reset_in <= '0'; w_in <= '0';
		end case;
	end process;	

  
END;
