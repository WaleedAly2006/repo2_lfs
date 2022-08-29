------------------------------------------------------------------------
--                                                                      
--                   Copyright (c) 2002 by Mentor Graphics              
--                                                                      
--  This source file is proprietary information of Mentor Graphics,Inc. 
--  It may be distributed in whole without restriction provided that    
--  this copyright statement is not removed from the file and that      
--  any derivative work contains this copyright notice.                 
--       
--      Package  : exemplar_1164
--
--      Version  : 3
--
--      Purpose  : Definition of package exemplar_1164.
--                 Functions, procedures and operators that provide often 
--                 needed functionality for the IEEE 1164 standard 
--                 STD_LOGIC, STD_LOGIC_VECTOR and STD_ULOGIC_VECTOR 
--                 types are defined in this package, for general use.
--                 Also attributes are defined that have pre-defined 
--                 semantics in CORE. 
--                 If the package exemplar_1164 is used in a VHDL description, 
--                 this file provides the simulation models.
--
--
------------------------------------------------------------------------
------------------------------------------------------------------------

library ieee ;
use ieee.std_logic_1164.all ;


package exemplar_1164 is

---
-- Attribute declarations
---
 
    attribute required_time   : time ;
    attribute arrival_time    : time ;
    attribute output_load     : real ;
    attribute max_load        : real ;
    attribute clock_cycle     : time ;
    attribute clock_offset    : time ;
    attribute pulse_width     : time ;
    attribute input_drive     : time ;
    attribute nobuff          : boolean ;
    attribute pin_number      : string ;
    attribute preserve_signal : boolean ;
    attribute noopt           : boolean ;

--
-- Attributes for synthesis directives in functions
--
    attribute synthesis_return : string ;
    attribute is_signed : boolean ;
 
 -- Specify pin_numbers for bits of a 1-dimensional array
    type exemplar_string_array is array (natural range <>, natural range <>) of character ;
    attribute array_pin_number : exemplar_string_array ;
 
 -- Buffer_sig attribute to force a (clock) buffer on a signal
    attribute buffer_sig : string ;
 
 -- PAD attribute to force a particular PAD cell on a IO pin
    attribute pad : string ;

-- Type needed to indicate speed requirements for module generators 
    type modgen_select is (smallest, small, fast, fastest);
     -- Use this attribute to set speed on signals/variables
    attribute modgen_sel : modgen_select ;

--  Attributes for encoding of enumerated types.

    type encoding_style is (BINARY, ONEHOT, TWOHOT, GRAY, RANDOM) ;
    attribute TYPE_ENCODING_STYLE : encoding_style ;

-- Example of using type_encoding_style for an enumerated type :
--      type state_t is (PLAY, WAIT_FOR_MOVE, END_OF_GAME);
--      attribute TYPE_ENCODING_STYLE of state_t:type is ONEHOT ;
 
    attribute TYPE_ENCODING : exemplar_string_array ;

-- Example of using TYPE_ENCODING for an enumerated type :
--    type state_t is (PLAY, WAIT_FOR_MOVE, END_OF_GAME);
--    attribute TYPE_ENCODING of state_t:type is ("011","110","101") ;
 
---
-- type conversion function declarations
---
    function bool2elb (l: boolean)                    return std_ulogic;
    function elb2bool (l: std_ulogic)                 return boolean;
    function evec2int (l: std_ulogic_vector)          return natural;
    function evec2int (l: std_logic_vector)           return natural;
    function int2evec (l: integer; size: integer:=32) return std_ulogic_vector;
    function int2evec (l: integer; size: integer:=32) return std_logic_vector;
    function elb2int  (l: std_ulogic)                 return natural;

---
-- shift function declarations
---
    function sl   (l: std_ulogic_vector; r: integer) return std_ulogic_vector;
    function sl   (l: std_logic_vector; r: integer)  return std_logic_vector;
    function sl2  (l: std_ulogic_vector; r: integer) return std_ulogic_vector;
    function sl2  (l: std_logic_vector; r: integer)  return std_logic_vector;
    function sr   (l: std_ulogic_vector; r: integer) return std_ulogic_vector;
    function sr   (l: std_logic_vector; r: integer)  return std_logic_vector;
    function sr2  (l: std_ulogic_vector; r: integer) return std_ulogic_vector;
    function sr2  (l: std_logic_vector; r: integer)  return std_logic_vector;

---
-- arithmetic functions declarations
---
    function add    (op_l, op_r: std_ulogic_vector)  return std_ulogic_vector;
    function add    (op_l, op_r: std_logic_vector)   return std_logic_vector;
    function add2   (op_l, op_r: std_ulogic_vector)  return std_ulogic_vector;
    function add2   (op_l, op_r: std_logic_vector)   return std_logic_vector;
    function sub    (op_l, op_r: std_ulogic_vector)  return std_ulogic_vector;
    function sub    (op_l, op_r: std_logic_vector)   return std_logic_vector;
    function sub2   (op_l, op_r: std_ulogic_vector)  return std_ulogic_vector;
    function sub2   (op_l, op_r: std_logic_vector)   return std_logic_vector;
    function mult   (op_l, op_r: std_ulogic_vector)  return std_ulogic_vector;
    function mult   (op_l, op_r: std_logic_vector)   return std_logic_vector;
    function mult2  (op_l, op_r: std_ulogic_vector)  return std_ulogic_vector;
    function mult2  (op_l, op_r: std_logic_vector)   return std_logic_vector;
--  function extend (op_l: std_ulogic; op_r: integer) return std_ulogic_vector;
--  function extend (op_l: std_ulogic; op_r: integer) return std_logic_vector;
    function extend (op_l: std_ulogic_vector; op_r: integer) return std_ulogic_vector;
    function extend (op_l: std_logic_vector; op_r: integer) return std_logic_vector;
--  function extend2 (op_l: std_ulogic; op_r: integer) return std_ulogic_vector;
--  function extend2 (op_l: std_ulogic; op_r: integer) return std_logic_vector;
    function extend2 (op_l: std_ulogic_vector; op_r: integer) return std_ulogic_vector;
    function extend2 (op_l: std_logic_vector; op_r: integer) return std_logic_vector;
    function comp2  (op: std_ulogic_vector)          return std_ulogic_vector;
    function comp2  (op: std_logic_vector)           return std_logic_vector;

---
--  overloaded arithmetic functions
---
    function "+"    (op_l, op_r: std_ulogic_vector)  return std_ulogic_vector;
    function "+"    (op_l, op_r: std_logic_vector)   return std_logic_vector;
    function "-"    (op_l, op_r: std_ulogic_vector)  return std_ulogic_vector;
    function "-"    (op_l, op_r: std_logic_vector)   return std_logic_vector;
    function "*"    (op_l, op_r: std_ulogic_vector)  return std_ulogic_vector;
    function "*"    (op_l, op_r: std_logic_vector)   return std_logic_vector;
--    function "mod"  (op_l, op_r: std_ulogic_vector) return std_ulogic_vector;
--    function "rem"  (op_l, op_r: std_ulogic_vector) return std_ulogic_vector;
    function "abs"  (op: std_ulogic_vector)       return std_ulogic_vector;
    function "abs"  (op: std_logic_vector)        return std_logic_vector;

---
-- predefined bus procedure declarations 
---

    procedure pullup  (signal data: inout std_ulogic) ;
    procedure pulldn  (signal data: inout std_ulogic) ;
    procedure trstmem (signal data: inout std_ulogic) ;

---
-- predefined register and bus procedure declarations
---
    procedure dff  (	constant data	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic);

    procedure dff_v  (	constant data	: in std_logic_vector;
			signal clk	: in std_logic;
			signal q	: out std_logic_vector);

    procedure dff_v  (	constant data	: in std_ulogic_vector;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic_vector);

    procedure dffc (	constant data	: in std_ulogic;
			constant clear	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic);

    procedure dffc_v (	constant data	: in std_logic_vector;
			constant clear	: in std_logic;
			signal clk	: in std_logic;
			signal q	: out std_logic_vector);

    procedure dffc_v (	constant data	: in std_ulogic_vector;
			constant clear	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic_vector);

    procedure dffp (	constant data	: in std_ulogic;
			constant preset	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic);

    procedure dffp_v (	constant data	: in std_logic_vector;
			constant preset	: in std_logic;
			signal clk	: in std_logic;
			signal q	: out std_logic_vector);

    procedure dffp_v (	constant data	: in std_ulogic_vector;
			constant preset	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic_vector);

    procedure dffpc (	constant data	: in std_ulogic;
			constant preset	: in std_ulogic;
			constant clear	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic);

    procedure dffpce (	constant data	: in std_ulogic;
			constant preset	: in std_ulogic;
			constant clear	: in std_ulogic;
			constant enable	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic);

    procedure dffpc_v (	constant data	: in std_logic_vector;
			constant preset	: in std_logic;
			constant clear	: in std_logic;
			signal clk	: in std_logic;
			signal q	: out std_logic_vector);

    procedure dffpc_v (	constant data	: in std_ulogic_vector;
			constant preset	: in std_ulogic;
			constant clear	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic_vector);

    procedure dlatch  (	constant data	: in std_ulogic;
  	constant gate	: in std_ulogic;
  	signal q	: out std_ulogic);
  
    procedure dlatch_v  (	constant data	: in std_logic_vector;
  	constant gate	: in std_logic;
  	signal q	: out std_logic_vector);
  
    procedure dlatch_v  (	constant data	: in std_ulogic_vector;
  	constant gate	: in std_ulogic;
  	signal q	: out std_ulogic_vector);
  
    procedure dlatchc (	constant data	: in std_ulogic;
  	constant clear	: in std_ulogic;
  	constant gate	: in std_ulogic;
  	signal q	: out std_ulogic);
  
    procedure dlatchc_v (	constant data	: in std_logic_vector;
  	constant clear	: in std_logic;
  	constant gate	: in std_logic;
  	signal q	: out std_logic_vector);
  
    procedure dlatchc_v (	constant data	: in std_ulogic_vector;
  	constant clear	: in std_ulogic;
  	constant gate	: in std_ulogic;
  	signal q	: out std_ulogic_vector);

    procedure dlatchp (	constant data	: in std_ulogic;
  	constant preset	: in std_ulogic;
  	constant gate	: in std_ulogic;
  	signal q	: out std_ulogic);
  
    procedure dlatchp_v (	constant data	: in std_logic_vector;
  	constant preset	: in std_logic;
  	constant gate	: in std_logic;
  	signal q	: out std_logic_vector);
  
    procedure dlatchp_v (	constant data	: in std_ulogic_vector;
  	constant preset	: in std_ulogic;
  	constant gate	: in std_ulogic;
  	signal q	: out std_ulogic_vector);
  
    procedure dlatchpc (	constant data	: in std_ulogic;
  	constant preset	: in std_ulogic;
  	constant clear	: in std_ulogic;
  	constant gate	: in std_ulogic;
  	signal q	: out std_ulogic);
  
    procedure dlatchpc_v (	constant data	: in std_logic_vector;
  	constant preset	: in std_logic;
  	constant clear	: in std_logic;
  	constant gate	: in std_logic;
  	signal q	: out std_logic_vector);
  
    procedure dlatchpc_v (	constant data	: in std_ulogic_vector;
  	constant preset	: in std_ulogic;
  	constant clear	: in std_ulogic;
  	constant gate	: in std_ulogic;
  	signal q	: out std_ulogic_vector);

end exemplar_1164;

