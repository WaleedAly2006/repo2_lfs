-- Test Bench and Tester for VHDL Calculator design

-- VHDL for Tester design unit

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Calc_tester IS
   PORT( 
      DataReady : IN     std_logic;
      Z         : IN     std_logic_vector (4 DOWNTO 0);
      A         : OUT    std_logic_vector (4 DOWNTO 0);
      B         : OUT    std_logic_vector (4 DOWNTO 0);
      Clk       : OUT    std_logic;
      OpCode    : OUT    std_logic_vector (1 DOWNTO 0);
      Rst       : OUT    std_logic;
      OpCodeValid  : OUT    std_logic;
      Initializing : IN     std_logic 
   );

-- Declarations

END Calc_tester ;

ARCHITECTURE spec OF Calc_tester IS

   CONSTANT clk_prd : time := 100 ns;

BEGIN

A <= "00100", "00101" AFTER 2000 ns;
B <= "00011", "00010" AFTER 2000 ns;

-- Binary Counter Stimulus Generator
OpCode <= "00",               -- NOOP
          "01" AFTER 400 ns,  -- A+B
          "10" AFTER 800 ns,  -- A-B
          "11" AFTER 1200 ns, -- A*B
          "00" AFTER 1600 ns, -- NOOP
          "01" AFTER 2000 ns, -- A+B
          "10" AFTER 2400 ns, -- A-B
          "11" AFTER 2800 ns; -- A*B

-- Clock Stimulus Generator
-------------------------------------
clk_proc : PROCESS
-------------------------------------
   BEGIN
      Clk <= '0';
      WAIT FOR 25 ns;
      LOOP
         Clk <= '1';
             WAIT FOR clk_prd/2;
         Clk <= '0';
             WAIT FOR clk_prd/2;
      END LOOP;
   END PROCESS clk_proc;

-- Pulse Stimulus Generator
Rst <= '0', '1' AFTER 40 ns, '0' AFTER 60 ns;

-- time-ordered stimulus vector section

OpCodeValid <= '0',
               '1' AFTER 110 ns,
               '0' AFTER 310 ns,
               '1' AFTER 490 ns,
               '0' AFTER 600 ns,
               '1' AFTER 900 ns,
               '0' AFTER 960 ns,
               '1' AFTER 1260 ns,
               '0' AFTER 1350 ns,
               '1' AFTER 2150 ns,
               '0' AFTER 2350 ns,
               '1' AFTER 2530 ns,
               '0' AFTER 2640 ns,
               '1' AFTER 2940 ns,
               '0' AFTER 3000 ns,
               '1' AFTER 3300 ns,
               '0' AFTER 3390 ns;

end spec;

-- VHDL for Test Bench

ENTITY Calc_tb IS
-- Declarations

END Calc_tb ;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ARCHITECTURE struct OF Calc_tb IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL A            : std_logic_vector(4 DOWNTO 0);
   SIGNAL B            : std_logic_vector(4 DOWNTO 0);
   SIGNAL Clk          : std_logic;
   SIGNAL DataReady    : std_logic;
   SIGNAL Initializing : std_logic;
   SIGNAL OpCode       : std_logic_vector(1 DOWNTO 0);
   SIGNAL OpCodeValid  : std_logic;
   SIGNAL Rst          : std_logic;
   SIGNAL Z            : std_logic_vector(4 DOWNTO 0);


   -- Component Declarations
   COMPONENT Calc_tester
   PORT (
      DataReady    : IN     std_logic ;
      Z            : IN     std_logic_vector (4 DOWNTO 0);
      A            : OUT    std_logic_vector (4 DOWNTO 0);
      B            : OUT    std_logic_vector (4 DOWNTO 0);
      Clk          : OUT    std_logic ;
      OpCode       : OUT    std_logic_vector (1 DOWNTO 0);
      Rst          : OUT    std_logic ;
      OpCodeValid  : OUT    std_logic ;
      Initializing : IN     std_logic 
   );
   END COMPONENT;
   COMPONENT Calc_Top
   PORT (
      A            : IN     std_logic_vector (4 downto 0); 
      B            : IN     std_logic_vector (4 downto 0); 
      Z            : OUT    std_logic_vector (4 downto 0); 
      DataReady    : OUT    std_logic ;
      OpCode       : IN     std_logic_vector (1 downto 0);
      OpCodeValid  : IN     std_logic ;
      Initializing : OUT    std_logic ;
      Clk          : IN     std_logic ;
      Rst          : IN     std_logic 
   );
   END COMPONENT;

-- FOR ALL : Calc_Top USE ENTITY work.Calc_Top;
-- FOR ALL : Calc_tester USE ENTITY work.Calc_tester;

BEGIN
   -- Instance port mappings.
   I1 : Calc_tester
      PORT MAP (
         DataReady    => DataReady,
         Z            => Z,
         A            => A,
         B            => B,
         Clk          => Clk,
         OpCode       => OpCode,
         Rst          => Rst,
         OpCodeValid  => OpCodeValid,
         Initializing => Initializing
      );
   I0 : Calc_Top
      PORT MAP (
         A            => A,
         B            => B,
         Z            => Z,
         DataReady    => DataReady,
         OpCode       => OpCode,
         OpCodeValid  => OpCodeValid,
         Initializing => Initializing,
         Clk          => Clk,
         Rst          => Rst
      );

END struct;

