-- VHDL code for Calculator Controller, Counter and decoder design units

-- VHDL for Calculator Controller design unit

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;

ENTITY Controller IS
   PORT( 
      Clk          : IN     std_logic;
      Rst          : IN     std_logic;
      Add          : IN     std_logic;
      Subtract     : IN     std_logic;
      Multiply     : IN     std_logic;
      CommandValid : IN     std_logic;
      MultiplyDone : IN     std_logic;
      Initializing : OUT    std_logic;
      DataReady    : OUT    std_logic;
      SelectInput  : OUT    std_logic;
      SelectB      : OUT    std_logic;
      AccLoad      : OUT    std_logic;
      AccAdd       : OUT    std_logic
   );

-- Declarations

END Controller ;

ARCHITECTURE rtl OF Controller IS
   -- Architecture Declarations
   TYPE STATE_TYPE IS (
      sINIT,
      sNOOP,
      sADD,
      sSUBTRACT,
      sMULTIPLY,
      sRES
   );

   -- State vector declaration
   ATTRIBUTE state_vector : string;
   ATTRIBUTE state_vector OF rtl : ARCHITECTURE IS "ControllerState" ;


   -- Declare current and next state signals
   SIGNAL ControllerState : STATE_TYPE ;
   SIGNAL NextControllerState : STATE_TYPE ;

   -- Declare any pre-registered internal signals
   SIGNAL DataReady_int : std_logic  ;

BEGIN

   ----------------------------------------------------------------------------
   clocked : PROCESS(
      Clk,
      Rst
   )
   ----------------------------------------------------------------------------
   BEGIN
      IF (Rst = '1') THEN
         ControllerState <= sRES;
         -- Reset Values
         DataReady <= '0';
      ELSIF (Clk'EVENT AND Clk = '1') THEN
         ControllerState <= NextControllerState;
         -- Registered output assignments
         DataReady <= DataReady_int;
      END IF;

   END PROCESS clocked;

   ----------------------------------------------------------------------------
   nextstate : PROCESS (
      Add,
      CommandValid,
      ControllerState,
      Multiply,
      MultiplyDone,
      Subtract
   )
   ----------------------------------------------------------------------------
   BEGIN
      -- Default Assignment
      AccAdd <= '-';
      AccLoad <= '-';
      DataReady_int <= '0';
      Initializing <= '0';
      SelectB <= '-';
      SelectInput <= '-';

      -- State Actions
      CASE ControllerState IS
      WHEN sINIT =>
         Initializing <= '1';
      WHEN sNOOP =>
         SelectInput <= '0'; 
         SelectB <= '0';
         AccLoad <= '1';
      WHEN sADD =>
         SelectInput <= '1';
         SelectB <= '1';
         AccLoad <= '0';
         AccAdd <= '1';
      WHEN sSUBTRACT =>
         SelectInput <= '1';
         SelectB <= '1';
         AccLoad <= '0';
         AccAdd <= '0';
      WHEN sMULTIPLY =>
         SelectInput <= '1';
         SelectB <= '0';
         AccLoad <= '0';
      WHEN sRES =>
         Initializing <= '1';
      WHEN OTHERS =>
         NULL;
      END CASE;

      -- Default state assignment
      NextControllerState <= ControllerState;
      CASE ControllerState IS
      WHEN sINIT =>
            NextControllerState <= sNOOP;
      WHEN sNOOP =>
         IF ((CommandValid = '1') AND (Add = '1')) THEN
            SelectInput <= '1';
            NextControllerState <= sADD;
         ELSIF ((CommandValid = '1') AND (Subtract = '1')) THEN
            SelectInput <= '1';
            NextControllerState <= sSUBTRACT;
         ELSIF ((CommandValid = '1') AND (Multiply = '1')) THEN
            SelectInput <= '1';
            NextControllerState <= sMULTIPLY;
         ELSIF (NOT ( CommandValid ) = '1') THEN
            SelectInput <= '0';
            NextControllerState <= sNOOP;
         ELSE
            NextControllerState <= sNOOP;
         END IF;
      WHEN sADD =>
            DataReady_int <= '1';
            NextControllerState <= sNOOP;
      WHEN sSUBTRACT =>
            DataReady_int <= '1';
            NextControllerState <= sNOOP;
      WHEN sMULTIPLY =>
         IF (MultiplyDone = '1') THEN
            AccAdd <= '0';
            DataReady_int <= '1';
            NextControllerState <= sNOOP;
         ELSIF (NOT(MultiplyDone) = '1') THEN
            AccAdd <= '1';
            NextControllerState <= sMULTIPLY;
         ELSE
            NextControllerState <= sMULTIPLY;
         END IF;
      WHEN sRES =>
            NextControllerState <= sINIT;
      WHEN OTHERS =>
         NextControllerState <= sRES;
      END CASE;

   END PROCESS nextstate;
   
END rtl;



-- VHDL for Counter design unit

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;


ENTITY Counter IS
   PORT( 
      Clk          : IN     std_logic;
      Initializing : IN     std_logic;
      AccLoad      : IN     std_logic;
      B            : IN     std_logic_vector (4 downto 0);
      MultiplyDone : OUT    std_logic
   );

-- Declarations

END Counter ;

ARCHITECTURE rtl OF Counter IS

BEGIN
   process1 : PROCESS (Clk, Initializing)
   -- Process declarations
      variable Count : integer;

   BEGIN
      IF  (Initializing = '1')  THEN
         Count := 0; 
      ELSIF (Clk'event AND Clk = '1') THEN
         IF  (AccLoad = '1')  THEN
            Count := conv_integer(unsigned(B));
         ELSE
            Count := (Count - 1);
         END IF;
      END IF;
      IF  (Count = 0)  THEN
         MultiplyDone <= '1';
      ELSE
         MultiplyDone <= '0';
      END IF;
   END PROCESS process1;

END rtl; -- Counter

-- VHDL for Decoder design unit

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;


ENTITY Decoder IS
   PORT( 
      OpCode       : IN     std_logic_vector (1 downto 0);
      OpCodeValid  : IN     std_logic;
      CommandValid : OUT    std_logic;
      Add          : OUT    std_logic;
      Subtract     : OUT    std_logic;
      Multiply     : OUT    std_logic;
      Clk          : IN     std_logic;
      Rst          : IN     std_logic
   );

-- Declarations

END Decoder ;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ARCHITECTURE rtl OF Decoder IS
BEGIN

   ---------------------------------------------------------------------------
   truth_process: PROCESS(clk, rst)
   ---------------------------------------------------------------------------
   BEGIN
      -- Asynchronous Reset
      IF (rst = '1') THEN
         -- Reset Actions
         CommandValid <= '0';
         Add <= '0';
         Subtract <= '0';
         Multiply <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN

         -- Global Actions
         CommandValid <= '0';
         Add <= '0';
         Subtract <= '0';
         Multiply <= '0';

         -- Block 1
         IF (OpCode = "00") AND (OpCodeValid = '1') THEN
            CommandValid <= '1';
         ELSIF (OpCode = "01") AND (OpCodeValid = '1') THEN
            CommandValid <= '1';
            Add <= '1';
         ELSIF (OpCode = "10") AND (OpCodeValid = '1') THEN
            CommandValid <= '1';
            Subtract <= '1';
         ELSIF (OpCode = "11") AND (OpCodeValid = '1') THEN
            CommandValid <= '1';
            Multiply <= '1';
         END IF;

      END IF;
   END PROCESS truth_process;

END rtl;
