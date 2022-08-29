--
-- VHDL Entity Sequencer_vhd.accumulator.symbol
--
-- Created:
--          by - user.group (host.domain)
--          at - 13:38:01 03/15/02
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY accumulator IS
   PORT( 
      clock : IN     std_logic;
      clr   : IN     std_logic;
      inc   : IN     std_logic;
      ip    : IN     std_logic_vector (7 DOWNTO 0);
      ld    : IN     std_logic;
      op    : BUFFER std_logic_vector (7 DOWNTO 0)
   );

-- Declarations

END accumulator ;

--
-- VHDL Architecture Sequencer_vhd.accumulator.spec
--
-- Created:
--          by - user.group (host.domain)
--          at - 12:08:45 08/11/99
--

ARCHITECTURE spec OF accumulator IS

BEGIN

   ---------------------------------------------------------------------------
   truth_process: PROCESS(clock)
   ---------------------------------------------------------------------------
   BEGIN
      IF (clock'EVENT AND clock = '1') THEN
         -- Synchronous Reset
         IF (clr = '1') THEN
            -- Reset Actions
            op <= "00000000";
         ELSE
            -- Block 1
            IF (ld = '1') THEN 
               op <= ip;
            ELSIF (inc = '1') THEN 
               op <= unsigned(op)+1;
            ELSE
               op <= op;
            END IF;

         END IF;
      END IF;
   END PROCESS truth_process;

END spec;
