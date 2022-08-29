-- VHDL Test Bench for Fibonacci Sequencer Design

LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY fibgen_tb IS
-- Test bench has no external interface

END fibgen_tb ;

LIBRARY ieee ;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ARCHITECTURE struct OF fibgen_tb IS

-- Architecture declarations
-- Internal signal declarations
SIGNAL clock  : std_logic;
SIGNAL monitor : std_logic_vector(7 DOWNTO 0);
SIGNAL reset  : std_logic;

-- Component Declarations
COMPONENT fibgen
   PORT (
      clock  : IN     std_logic ;
      reset  : IN     std_logic ;
      fibout : OUT    std_logic_vector (7 DOWNTO 0)
   );
END COMPONENT;
COMPONENT fibgen_tester
   PORT (
      monitor : IN     std_logic_vector (7 DOWNTO 0);
      clock  : OUT    std_logic ;
      reset  : OUT    std_logic 
   );
END COMPONENT;


BEGIN
   UUT : fibgen
      PORT MAP (
         clock  => clock,
         reset  => reset,
         fibout => monitor
      );
   Checker: fibgen_tester
      PORT MAP (
         monitor => monitor,
         clock  => clock,
         reset  => reset
      );

END struct;



