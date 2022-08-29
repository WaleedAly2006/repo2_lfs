-- VHDL Entity uart.status_registers.interface
--
-- Created:
--          by - user.group (host.domain)
--          at - 09:12:52 02/18/03
--
-- Mentor Graphics' HDL Designer(TM)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY status_registers IS
   PORT( 
      clear_flags   : IN     std_logic;
      clk           : IN     std_logic;                      -- 10 MHz clock
      done_rcving   : IN     std_logic;
      done_xmitting : IN     std_logic;
      rcving        : IN     std_logic;
      rst           : IN     std_logic;                      -- reset(0)
      xmitting      : IN     std_logic;
      int           : OUT    std_logic;                      -- interrupt (1)
      status        : OUT    std_logic_vector (7 DOWNTO 0)
   );

-- Declarations

END status_registers ;

ARCHITECTURE spec OF status_registers IS

   SIGNAL xmitting_reg, done_xmitting_reg : std_logic := '0';
   SIGNAL rcving_reg, done_rcving_reg     : std_logic := '0';

BEGIN
	
   vhdl_status_registers_proc: PROCESS ( clk, rst)
   BEGIN
      IF (rst = '0') THEN
         -- Clear Registers
         xmitting_reg <= '0';
         done_xmitting_reg <= '0';
         rcving_reg <= '0';
         done_rcving_reg <= '0';
         
      ELSIF (clk'event AND clk = '1') THEN
         IF (clear_flags = '1') THEN
            -- Clear Status Flags
            xmitting_reg <= '0';
            done_xmitting_reg <= '0';
            rcving_reg <= '0';
            done_rcving_reg <= '0';
         ELSE
            -- Register signals
            xmitting_reg <= xmitting;
            rcving_reg <= rcving;
            IF  done_xmitting = '1' THEN
                done_xmitting_reg <= done_xmitting;
            END IF;
            IF done_rcving <= '1' THEN
                done_rcving_reg <= done_rcving;
            END IF;
         END IF;
      END IF;
   END PROCESS vhdl_status_registers_proc;
   
   -- Assert interrupt if transmitting or receiving completed
   int <= done_xmitting_reg OR done_rcving_reg;
   -- Compose status register
   status <= "0000" & done_rcving_reg & done_xmitting_reg 
                    & rcving_reg & xmitting_reg;
	
END spec;
