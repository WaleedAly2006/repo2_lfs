--
-- VHDL Entity UART.control_operation.symbol
--
-- Created:
--          by - user.group (host.domain)
--          at - 13:04:20 27/02/2001
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2001.0
--
-- hds interface_start
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY control_operation IS
   PORT( 
      clk          : IN     std_logic;
      clr_int_en   : IN     std_logic;
      cs           : IN     std_logic;
      nrw          : IN     std_logic;
      rst          : IN     std_logic;
      xmitdt_en    : IN     std_logic;
      clear_flags  : OUT    std_logic;
      enable_write : OUT    std_logic;
      start_xmit   : OUT    std_logic
   );

-- Declarations

END control_operation ;

-- hds interface_end
--
-- VHDL Architecture UART.control_operation.fsm
--
-- Created:
--          by - user.group (host.domain)
--          at - 13:04:20 27/02/2001
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2001.0
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ARCHITECTURE fsm OF control_operation IS

   -- Architecture Declarations
   TYPE STATE_TYPE IS (
      waiting,
      reading_from_reg,
      clearing_flags,
      writing_to_reg,
      xmitting
   );

   -- State vector declaration
   ATTRIBUTE state_vector : string;
   ATTRIBUTE state_vector OF fsm : ARCHITECTURE IS "current_state" ;


   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE ;
   SIGNAL next_state : STATE_TYPE ;

BEGIN

   ----------------------------------------------------------------------------
   clocked : PROCESS(
      clk,
      rst
   )
   ----------------------------------------------------------------------------
   BEGIN
      IF (rst = '0') THEN
         current_state <= waiting;
         -- Reset Values
      ELSIF (clk'EVENT AND clk = '1') THEN
         current_state <= next_state;
         -- Default Assignment To Internals

      END IF;

   END PROCESS clocked;

   ----------------------------------------------------------------------------
   nextstate : PROCESS (
      clr_int_en,
      cs,
      current_state,
      nrw,
      xmitdt_en
   )
   ----------------------------------------------------------------------------
   BEGIN
      -- Default Assignment
      clear_flags <= '0';
      enable_write <= '0';
      start_xmit <= '0';
      -- Default Assignment To Internals

      -- State Actions
      CASE current_state IS
      WHEN clearing_flags =>
         clear_flags <= '1';
      WHEN writing_to_reg =>
         enable_write <= '1';
      WHEN xmitting =>
         start_xmit <= '1';
      WHEN OTHERS =>
         NULL;
      END CASE;

      CASE current_state IS
      WHEN waiting =>
         IF (nrw = '1' AND cs = '0') THEN
            next_state <= writing_to_reg;
         ELSIF (nrw = '0' AND cs = '0') THEN
            next_state <= reading_from_reg;
         ELSE
            next_state <= waiting;
         END IF;
      WHEN reading_from_reg =>
         IF (cs = '1') THEN
            next_state <= waiting;
         ELSIF (nrw = '0' AND clr_int_en = '1') THEN
            next_state <= clearing_flags;
         ELSE
            next_state <= reading_from_reg;
         END IF;
      WHEN clearing_flags =>
         IF (cs = '1') THEN
            next_state <= waiting;
         ELSE
            next_state <= clearing_flags;
         END IF;
      WHEN writing_to_reg =>
         IF (cs = '1') THEN
            next_state <= waiting;
         ELSIF (nrw = '1' AND xmitdt_en = '1') THEN
            next_state <= xmitting;
         ELSE
            next_state <= writing_to_reg;
         END IF;
      WHEN xmitting =>
         IF (cs = '1') THEN
            next_state <= waiting;
         ELSE
            next_state <= xmitting;
         END IF;
      WHEN OTHERS =>
         next_state <= waiting;
      END CASE;

   END PROCESS nextstate;

   -- Concurrent Statements

END fsm;
