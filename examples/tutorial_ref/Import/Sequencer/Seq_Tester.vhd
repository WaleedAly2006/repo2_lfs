-- VHDL Entity fibgen_tester

LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY fibgen_tester IS
   PORT( 
      monitor : IN     std_logic_vector (7 DOWNTO 0) ;
      clock  : OUT    std_logic  ;
      reset  : OUT    std_logic 
   );

END fibgen_tester ;

-- VHDL Architecture fibgen_tester

ARCHITECTURE spec OF fibgen_tester IS

-- Architecture declarations
CONSTANT clk_prd : time := 100 ns ;
SIGNAL int_clock : std_logic := '0';

BEGIN

   process0 : PROCESS (monitor)
   BEGIN
      IF unsigned(monitor) > 128 THEN
         reset <= '1' ;
      ELSE
         reset <= '0' ;
      END IF;
   END PROCESS process0;


-- Architecture concurrent statements
-- Clock Generator
int_clock <= not int_clock AFTER clk_prd / 2;
clock <= int_clock;

END spec;

