-- VHDL Fibonacci Sequencer Design

-- VHDL Entity control

LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY control IS
   PORT( 
      clock  : IN     std_logic  ;
      reset  : IN     std_logic  ;
      clr    : OUT    std_logic  ;
      inc    : OUT    std_logic  ;
      ld_A_B : OUT    std_logic  ;
      ld_sum : OUT    std_logic 
   );

END control ;

-- VHDL Architecture control

LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ARCHITECTURE fsm OF control IS

   -- Architecture Declarations
   TYPE state_type IS (
      clr_regs,
      inc_accb,
      load_acc_sum,
      load_acc_A_B
   );

   -- State vector declaration
   ATTRIBUTE state_vector : string;
   ATTRIBUTE state_vector OF fsm : architecture IS "current_state" ;

   -- Declare current and next state signals
   SIGNAL current_state, next_state : state_type ;

BEGIN

   clocked : PROCESS (clock, reset)
   BEGIN
      IF (reset = '1') THEN
         current_state <= clr_regs;
         -- Reset Values
      ELSIF (clock'EVENT AND clock = '1') THEN
         current_state <= next_state;
         -- Default Assignment To Internals

      END IF;

   END PROCESS clocked;

   nextstate : PROCESS (current_state)
   BEGIN
      CASE current_state IS
      WHEN clr_regs =>
            next_state <= inc_accb;
      WHEN inc_accb =>
            next_state <= load_acc_sum;
      WHEN load_acc_sum =>
            next_state <= load_acc_A_B;
      WHEN load_acc_A_B =>
            next_state <= load_acc_sum;
      WHEN OTHERS =>
         next_state <= clr_regs;
      END CASE;

   END PROCESS nextstate;

   output : PROCESS (current_state)
   BEGIN
      -- Default Assignment
      clr <= '0';
      inc <= '0';
      ld_A_B <= '0';
      ld_sum <= '0';

      -- State Actions
      CASE current_state IS
      WHEN clr_regs =>
         clear <= '1' ; -- Deliberate error, signal is declared as clr
         inc <= '0' ;
         ld_A_B <= '0' ;
         ld_sum <= '0' ;
      WHEN inc_accb =>
         clear <= '0' ; -- Deliberate error, signal is declared as clr
         inc <= '1' ;
      WHEN load_acc_sum =>
         inc <= '0' ;
         ld_A_B <= '0' ;
         ld_sum <= '1' ;
      WHEN load_acc_A_B =>
         ld_A_B <= '1' ;
         ld_sum <= '0' ;
      WHEN OTHERS =>
         NULL;
      END CASE;

   END PROCESS output;

END fsm;


-- VHDL Entity accumulator

LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY accumulator IS
   PORT( 
      clock : IN     std_logic  ;
      clr   : IN     std_logic  ;
      inc   : IN     std_logic  ;
      ip    : IN     std_logic_vector (7 DOWNTO 0) ;
      ld    : IN     std_logic  ;
      op    : BUFFER std_logic_vector (7 DOWNTO 0)
   );

END accumulator ;

-- VHDL Architecture accumulator

ARCHITECTURE spec OF accumulator IS

BEGIN

   truth_process: PROCESS(clock)

   BEGIN
      IF (clock'EVENT AND clock = '1') THEN
         IF (clr = '1') THEN
            -- Reset Actions
            op <= "00000000";
         ELSE
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

-- VHDL Entity fibgen

LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY fibgen IS
   PORT( 
      clock  : IN     std_logic  ;
      reset  : IN     std_logic  ;
      fibout : OUT    std_logic_vector (7 DOWNTO 0)
   );

END fibgen ;

LIBRARY ieee ;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ARCHITECTURE struct OF fibgen IS

-- Internal signal declarations
SIGNAL A      : std_logic_vector(7 DOWNTO 0);
SIGNAL B      : std_logic_vector(7 DOWNTO 0);
SIGNAL clr    : std_logic;
SIGNAL gnd    : std_logic;
SIGNAL inc    : std_logic;
SIGNAL ld_A_B : std_logic;
SIGNAL ld_sum : std_logic;
SIGNAL sum    : std_logic_vector(7 DOWNTO 0);

-- Implicit buffer signal declarations
SIGNAL fibout_internal : std_logic_vector (7 DOWNTO 0);

-- Component Declarations
COMPONENT accumulator
   PORT (
      clock : IN     std_logic ;
      clr   : IN     std_logic ;
      inc   : IN     std_logic ;
      ip    : IN     std_logic_vector (7 DOWNTO 0);
      ld    : IN     std_logic ;
      op    : BUFFER std_logic_vector (7 DOWNTO 0)
   );
END COMPONENT;
COMPONENT control
   PORT (
      clock  : IN     std_logic ;
      reset  : IN     std_logic ;
      clr    : OUT    std_logic ;
      inc    : OUT    std_logic ;
      ld_A_B : OUT    std_logic ;
      ld_sum : OUT    std_logic 
   );
END COMPONENT;

BEGIN
   -- Architecture concurrent statements
   
   -- Add signals A and B together
   sum <= unsigned(A) + unsigned(B) ;

   -- Tie signal gnd to ground
   gnd <= '0' ;

   acc_A : accumulator
      PORT MAP (
         clock => clock,
         clr   => clr,
         inc   => gnd,
         ip    => fibout_internal,
         ld    => ld_A_B,
         op    => A
      );
   acc_B : accumulator
      PORT MAP (
         clock => clock,
         clr   => clr,
         inc   => inc,
         ip    => A,
         ld    => ld_A_B,
         op    => B
      );
   acc_sum : accumulator
      PORT MAP (
         clock => clock,
         clr   => clr,
         inc   => gnd,
         ip    => sum,
         ld    => ld_sum,
         op    => fibout_internal
      );
   FSM: control
      PORT MAP (
         clock  => clock,
         reset  => reset,
         clr    => clr,
         inc    => inc,
         ld_A_B => ld_A_B,
         ld_sum => ld_sum
      );

   -- Implicit buffered output assignments
   fibout <= fibout_internal;

END struct;


