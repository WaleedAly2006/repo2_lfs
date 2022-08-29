--
-- VHDL Entity Sequencer_vhd.fibgen_tester.interface
--
-- Created:
--          by - user.group (host.domain)
--          at - 13:38:01 03/15/02
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY fibgen_tester IS
   PORT( 
      monitor : IN     std_logic_vector (7 DOWNTO 0);
      clock   : OUT    std_logic;
      reset   : OUT    std_logic
   );

-- Declarations

END fibgen_tester ;

--
-- VHDL Architecture Sequencer_vhd.fibgen_tester.spec
--
-- Created:
--          by - user.group (host.domain) 
--			at - 11:59:18 08/11/99
--
ARCHITECTURE spec OF fibgen_tester IS

-- Architecture declarations
CONSTANT clk_prd : time := 100 ns ;
SIGNAL int_clock : std_logic := '0';

BEGIN

     ---------------------------------------------------------------------------
   process0 : PROCESS (monitor)
   ---------------------------------------------------------------------------
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
