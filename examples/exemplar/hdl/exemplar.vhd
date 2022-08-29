------------------------------------------------------------------------
--                                                                      
--                   Copyright (c) 2002 by Mentor Graphics              
--                                                                      
--  This source file is proprietary information of Mentor Graphics,Inc. 
--  It may be distributed in whole without restriction provided that    
--  this copyright statement is not removed from the file and that      
--  any derivative work contains this copyright notice.                 
--       
--      Package  : exemplar
--
--      Version  : 3
--
--      Purpose  : Definition of package exemplar.
--                 The purpose of this file is to provide the behavior of the
--                 Exemplar Logic VHDL library types, functions and
--                 procedures for IEEE 1076 VHDL simulators.
--                 Functions, procedures and operators that provide often
--                 needed functionality for the standard BIT and BIT_VECTOR
--                 types are also defined in this package.
--
------------------------------------------------------------------------
------------------------------------------------------------------------

package exemplar is

---
-- type declarations
---
       -- el_logic: enumerated type with 4 values
    type el_logic is ( 'X', '0', '1', 'Z');

    -------------------------------------------------------------------
    -- Directives for Exemplar synthesis of el_logic.
    -- Declare the type encoding attribute and set the value for el_logic
    -- Directives for the resolution function and all other function are
    -- in the package body
    -------------------------------------------------------------------
    attribute logic_type_encoding : string ;

    attribute logic_type_encoding of el_logic:type is
                 -- ('X','0','1','Z')
                    ('X','0','1','Z') ;

    -------------------------------------------------------------------
    -- Directives for Exemplar synthesis of the exemplar package functions.
    -- Declare the synthesis-directive attribute; to be set on
    -- basic functions that are difficult for synthesis, in the body of the 
    -- package 
    -------------------------------------------------------------------
    attribute synthesis_return : string ;
    attribute is_signed : boolean ;

       -- el_logic_vector: array of standard values
    type el_logic_vector is array (integer range <>) of el_logic;

       -- el_resolution: resolution function to be used on all signals of type elbit
    function el_resolution(driver : el_logic_vector) return el_logic;

       -- elbit: basic Exemplar bit type to be used with all signal declarations.
    subtype elbit is el_resolution el_logic;

       -- elbit_vector: 1-dimensional array of elbits
    type elbit_vector is array (integer range <>) of elbit;

       -- elbit_matrix: 2-dimensional array of elbits
    type elbit_matrix is array (integer range <>, integer range <>) of elbit;

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
-- Overloaded logical operator declarations (bitwise)
---
    function "not"   (l: elbit)                           return elbit;
    function "not"   (l: elbit_vector)                    return elbit_vector;
    function "not"   (l: elbit_matrix)                    return elbit_matrix;

    function "and"   (l: elbit;        r: elbit)           return elbit;
    function "and"   (l: elbit_vector; r: elbit_vector)    return elbit_vector;
    function "and"   (l: elbit_matrix; r: elbit_matrix)    return elbit_matrix;

    function "nand"  (l: elbit;        r: elbit)           return elbit;
    function "nand"  (l: elbit_vector; r: elbit_vector)    return elbit_vector;
    function "nand"  (l: elbit_matrix; r: elbit_matrix)    return elbit_matrix;

    function "or"    (l: elbit;        r: elbit)           return elbit;
    function "or"    (l: elbit_vector; r: elbit_vector)    return elbit_vector;
    function "or"    (l: elbit_matrix; r: elbit_matrix)    return elbit_matrix;

    function "nor"   (l: elbit;        r: elbit)           return elbit;
    function "nor"   (l: elbit_vector; r: elbit_vector)    return elbit_vector;
    function "nor"   (l: elbit_matrix; r: elbit_matrix)    return elbit_matrix;

    function "xor"   (l: elbit;        r: elbit)           return elbit;
    function "xor"   (l: elbit_vector; r: elbit_vector)    return elbit_vector;
    function "xor"   (l: elbit_matrix; r: elbit_matrix)    return elbit_matrix;

---
-- type conversion function declarations
---
    function bool2elb   (l: boolean)                    return elbit;
    function bool2elb   (l: boolean)                    return bit;
    function elb2bool   (l: elbit)                      return boolean;
    function elb2bool   (l: bit)                        return boolean;
    function int2boo    (l: integer)                    return boolean;
    function boo2int    (l: boolean)                    return natural;
    function evec2int   (l: elbit_vector)               return natural;
    function evec2int   (l: bit_vector)                 return natural;
    function int2evec   (l: integer; size: integer:=32) return elbit_vector;
    function int2evec   (l: integer; size: integer:=32) return bit_vector;
    function elb2int    (l: elbit)                      return natural;
    function elb2int    (l: bit)                        return natural;

---
-- shift function declarations
---
    function sl       (l: elbit_vector; r: integer)     return elbit_vector;
    function sl       (l: bit_vector; r: integer)       return bit_vector;
    function sl2      (l: elbit_vector; r: integer)     return elbit_vector;
    function sl2      (l: bit_vector; r: integer)       return bit_vector;
    function sr       (l: elbit_vector; r: integer)     return elbit_vector;
    function sr       (l: bit_vector; r: integer)       return bit_vector;
    function sr2      (l: elbit_vector; r: integer)     return elbit_vector;
    function sr2      (l: bit_vector; r: integer)       return bit_vector;

---
-- arithmetic functions declarations
---
    function add      (op_l, op_r: elbit_vector)          return elbit_vector;
    function add      (op_l, op_r: bit_vector)            return bit_vector;
    function add2     (op_l, op_r: elbit_vector)          return elbit_vector;
    function add2     (op_l, op_r: bit_vector)            return bit_vector;
    function sub      (op_l, op_r: elbit_vector)          return elbit_vector;
    function sub      (op_l, op_r: bit_vector)            return bit_vector;
    function sub2     (op_l, op_r: elbit_vector)          return elbit_vector;
    function sub2     (op_l, op_r: bit_vector)            return bit_vector;
    function mult     (op_l, op_r: elbit_vector)          return elbit_vector;
    function mult     (op_l, op_r: bit_vector)            return bit_vector;
    function mult2    (op_l, op_r: elbit_vector)          return elbit_vector;
    function mult2    (op_l, op_r: bit_vector)            return bit_vector;
    function extend   (op_l: elbit_vector; op_r: integer) return elbit_vector;
    function extend   (op_l: bit_vector; op_r: integer)   return bit_vector;
 --   function extend   (op_l: elbit; op_r: integer)        return elbit_vector;
 --   function extend   (op_l: bit; op_r: integer)          return bit_vector;
 --   function extend2  (op_l: elbit; op_r: integer)        return elbit_vector;
 --   function extend2  (op_l: bit; op_r: integer)          return bit_vector;
    function extend2  (op_l: elbit_vector; op_r: integer) return elbit_vector;
    function extend2  (op_l: bit_vector; op_r: integer)   return bit_vector;
    function comp2    (op: elbit_vector)                  return elbit_vector;
    function comp2    (op: bit_vector)                    return bit_vector;

---
--  overloaded arithmetic functions
---
    function "+"      (op_l, op_r: elbit_vector)          return elbit_vector;
    function "+"      (op_l, op_r: bit_vector)            return bit_vector;
    function "-"      (op_l, op_r: elbit_vector)          return elbit_vector;
    function "-"      (op_l, op_r: bit_vector)            return bit_vector;
--    function "mod"    (op_l, op_r: elbit_vector)          return elbit_vector;
--    function "rem"    (op_l, op_r: elbit_vector)          return elbit_vector;
    function "abs"    (op: elbit_vector)                  return elbit_vector;
    function "abs"    (op: bit_vector)                    return bit_vector;

---
-- predefined bus procedure declarations 
---

    procedure pullup  (signal data: inout bit) ;
    procedure pullup  (signal data: inout elbit) ;
    procedure pulldn  (signal data: inout bit) ;
    procedure pulldn  (signal data: inout elbit) ;
    procedure trstmem (signal data: inout bit) ;
    procedure trstmem (signal data: inout elbit) ;

---
-- predefined register and bus procedure declarations
---
    procedure dff  (	constant data     : in bit;
			signal clk	: in bit;
			signal q	: out bit);

    procedure dff  (	constant data	: in elbit;
			signal clk	: in elbit;
			signal q	: out elbit);

    procedure dff_v  (	constant data	: in bit_vector;
			signal clk	: in bit;
			signal q	: out bit_vector);

    procedure dff_v  (	constant data	: in elbit_vector;
			signal clk	: in elbit;
			signal q	: out elbit_vector);

    procedure dffc (	constant data	: in bit;
			constant clear	: in bit;
			signal clk	: in bit;
			signal q	: out bit);

    procedure dffc (	constant data	: in elbit;
			constant clear	: in elbit;
			signal clk	: in elbit;
			signal q	: out elbit);

    procedure dffc_v (	constant data	: in bit_vector;
			constant clear	: in bit;
			signal clk	: in bit;
			signal q	: out bit_vector);

    procedure dffc_v (	constant data	: in elbit_vector;
			constant clear	: in elbit;
			signal clk	: in elbit;
			signal q	: out elbit_vector);

    procedure dffp (	constant data	: in bit;
			constant preset	: in bit;
			signal clk	: in bit;
			signal q	: out bit);

    procedure dffp (	constant data	: in elbit;
			constant preset	: in elbit;
			signal clk	: in elbit;
			signal q	: out elbit);

    procedure dffp_v (	constant data	: in bit_vector;
			constant preset	: in bit;
			signal clk	: in bit;
			signal q	: out bit_vector);

    procedure dffp_v (	constant data	: in elbit_vector;
			constant preset	: in elbit;
			signal clk	: in elbit;
			signal q	: out elbit_vector);

    procedure dffpc (	constant data	: in bit;
			constant preset	: in bit;
			constant clear	: in bit;
			signal clk	: in bit;
			signal q	: out bit);

    procedure dffpc (	constant data	: in elbit;
			constant preset	: in elbit;
			constant clear	: in elbit;
			signal clk	: in elbit;
			signal q	: out elbit);

    procedure dffpce (	constant data	: in bit;
			constant preset	: in bit;
			constant clear	: in bit;
                        constant enable : in bit;
			signal clk	: in bit;
			signal q	: out bit);

    procedure dffpce (	constant data	: in elbit;
			constant preset	: in elbit;
			constant clear	: in elbit;
                        constant enable : in elbit;
			signal clk	: in elbit;
			signal q	: out elbit);

    procedure dffpc_v (	constant data	: in bit_vector;
			constant preset	: in bit;
			constant clear	: in bit;
			signal clk	: in bit;
			signal q	: out bit_vector);

    procedure dffpc_v (	constant data	: in elbit_vector;
			constant preset	: in elbit;
			constant clear	: in elbit;
			signal clk	: in elbit;
			signal q	: out elbit_vector);

    procedure dlatch  (	constant data	: in bit;
  			constant gate	: in bit;
  			signal q	: out bit);
  
    procedure dlatch  (	constant data	: in elbit;
  			constant gate	: in elbit;
  			signal q	: out elbit);
  
    procedure dlatch_v  (constant data	: in bit_vector;
  			constant gate	: in bit;
  			signal q	: out bit_vector);
  
    procedure dlatch_v  (constant data	: in elbit_vector;
 		 	constant gate	: in elbit;
  			signal q	: out elbit_vector);
  
    procedure dlatchc (	constant data	: in bit;
  			constant clear	: in bit;
 		 	constant gate	: in bit;
 		 	signal q	: out bit);
  
    procedure dlatchc (	constant data	: in elbit;
 		 	constant clear	: in elbit;
 		 	constant gate	: in elbit;
  			signal q	: out elbit);
  
    procedure dlatchc_v (constant data	: in bit_vector;
 		 	constant clear	: in bit;
 		 	constant gate	: in bit;
 		 	signal q	: out bit_vector);
  
    procedure dlatchc_v (constant data	: in elbit_vector;
		  	constant clear	: in elbit;
 		 	constant gate	: in elbit;
 		 	signal q	: out elbit_vector);

    procedure dlatchp (	constant data	: in bit;
 		 	constant preset	: in bit;
 		 	constant gate	: in bit;
 		 	signal q	: out bit);
  
    procedure dlatchp (	constant data	: in elbit;
		  	constant preset	: in elbit;
 		 	constant gate	: in elbit;
 		 	signal q	: out elbit);
  
    procedure dlatchp_v (constant data	: in bit_vector;
 		 	constant preset	: in bit;
  			constant gate	: in bit;
  			signal q	: out bit_vector);
  
    procedure dlatchp_v (constant data	: in elbit_vector;
 		 	constant preset	: in elbit;
  			constant gate	: in elbit;
  			signal q	: out elbit_vector);
  
    procedure dlatchpc (constant data	: in bit;
		  	constant preset	: in bit;
  			constant clear	: in bit;
  			constant gate	: in bit;
  			signal q	: out bit);
  
    procedure dlatchpc (constant data	: in elbit;
  			constant preset	: in elbit;
  			constant clear	: in elbit;
  			constant gate	: in elbit;
  			signal q	: out elbit);
  
    procedure dlatchpc_v (constant data	: in bit_vector;
 		 	constant preset	: in bit;
 		 	constant clear	: in bit;
 		 	constant gate	: in bit;
  			signal q	: out bit_vector);
  
    procedure dlatchpc_v (constant data	: in elbit_vector;
  			constant preset	: in elbit;
  			constant clear	: in elbit;
  			constant gate	: in elbit;
  			signal q	: out elbit_vector);

end exemplar;

