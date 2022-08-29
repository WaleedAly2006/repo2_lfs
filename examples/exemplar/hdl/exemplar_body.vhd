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

package body exemplar is


-- These are the allowed values for the exemplar_synthesis attibute : 
--        -- General feed-through/vector-extend function
--      FEED_THROUGH,
--       -- Three-state reduce function
--      WIRED_THREE_STATE,
--       -- Binary functions
--      BIN_NOT, BIN_AND, BIN_OR, BIN_NAND, BIN_NOR, BIN_XOR, BIN_XNOR,
--       -- Arithmetic functions
--      UMINUS, ABS, REM, ADD, SUB, MULT, DIV, POWER,
--       -- Relational functions
--      EQ, NEQ, LT, GT, LTE, GTE,
--       -- Shifters and Rollers
--      SLL, SRL, SLA, SRA, ROL, ROR,
--       -- Vector-reduce functions
--      REDUCE_AND, REDUCE_OR, REDUCE_NAND,
--      REDUCE_NOR, REDUCE_XOR, REDUCE_XNOR



-- internal type for look-up tables
    type f_1_x_1 is array (el_logic'low TO el_logic'high) of el_logic;
    type f_2_x_1 is array (el_logic'low TO el_logic'high) of f_1_x_1;
    type f_3_x_1 is array (el_logic'low TO el_logic'high) of f_2_x_1;
 
-- 
--  look-up table declarations
--  Carefull : dependant upon order of values in type el_logic
--
    CONSTANT f_not : f_1_x_1 := (
              'X',   --  'X'
              '1',   --  '0'
              '0',   --  '1'
              'X'    --  'Z'
        );

    CONSTANT f_and : f_2_x_1 := ( 
            ( 'X',   -- 'X', 'X'
              '0',   -- 'X', '0'
              'X',   -- 'X', '1'
              'X' ), -- 'X', 'Z'
            ( '0',   -- '0', 'X' 
              '0',   -- '0', '0'
              '0',   -- '0', '1', 
              '0' ), -- '0', 'Z' 
            ( 'X',   -- '1', 'X'
              '0',   -- '1', '0'
              '1',   -- '1', '1'
              'X' ), -- '1', 'Z'
            ( 'X',   -- 'Z', 'X'
              '0',   -- 'Z', '0'
              'X',   -- 'Z', '1'
              'X' )  -- 'Z', 'Z'
        );

    CONSTANT f_or : f_2_x_1 := ( 
            ( 'X',   -- 'X', 'X'
              'X',   -- 'X', '0'
              '1',   -- 'X', '1'
              'X' ), -- 'X', 'Z'
            ( 'X',   -- '0', 'X' 
              '0',   -- '0', '0'
              '1',   -- '0', '1', 
              'X' ), -- '0', 'Z' 
            ( '1',   -- '1', 'X'
              '1',   -- '1', '0'
              '1',   -- '1', '1'
              '1' ), -- '1', 'Z'
            ( 'X',   -- 'Z', 'X'
              'X',   -- 'Z', '0'
              '1',   -- 'Z', '1'
              'X' )  -- 'Z', 'Z'
        );

    CONSTANT f_xor : f_2_x_1 := (
            ( 'X',   -- 'X', 'X'
              'X',   -- 'X', '0'
              'X',   -- 'X', '1'
              'X' ), -- 'X', 'Z'
            ( 'X',   -- '0', 'X' 
              '0',   -- '0', '0'
              '1',   -- '0', '1', 
              'X' ), -- '0', 'Z' 
            ( 'X',   -- '1', 'X'
              '1',   -- '1', '0'
              '0',   -- '1', '1'
              'X' ), -- '1', 'Z'
            ( 'X',   -- 'Z', 'X'
              'X',   -- 'Z', '0'
              'X',   -- 'Z', '1'
              'X' )  -- 'Z', 'Z'
        );

    CONSTANT f_nand : f_2_x_1 := ( 
            ( 'X',   -- 'X', 'X'
              '1',   -- 'X', '0'
              'X',   -- 'X', '1'
              'X' ), -- 'X', 'Z'
            ( '1',   -- '0', 'X' 
              '1',   -- '0', '0'
              '1',   -- '0', '1', 
              '1' ), -- '0', 'Z' 
            ( 'X',   -- '1', 'X'
              '1',   -- '1', '0'
              '0',   -- '1', '1'
              'X' ), -- '1', 'Z'
            ( 'X',   -- 'Z', 'X'
              '1',   -- 'Z', '0'
              'X',   -- 'Z', '1'
              'X' )  -- 'Z', 'Z'
        );

    CONSTANT f_nor : f_2_x_1 := ( 
            ( 'X',   -- 'X', 'X'
              'X',   -- 'X', '0'
              '0',   -- 'X', '1'
              'X' ), -- 'X', 'Z'
            ( 'X',   -- '0', 'X' 
              '1',   -- '0', '0'
              '0',   -- '0', '1', 
              'X' ), -- '0', 'Z' 
            ( '0',   -- '1', 'X'
              '0',   -- '1', '0'
              '0',   -- '1', '1'
              '0' ), -- '1', 'Z'
            ( 'X',   -- 'Z', 'X'
              'X',   -- 'Z', '0'
              '0',   -- 'Z', '1'
              'X' )  -- 'Z', 'Z'
        );

    CONSTANT f_sum : f_3_x_1 := ( 
           (( 'X',   -- X X X 
              'X',   -- X X 0
              'X',   -- X X 1 
              'X' ), -- X X Z 
            ( 'X',   -- X 0 X 
              'X',   -- X 0 0
              'X',   -- X 0 1 
              'X' ), -- X 0 Z 
            ( 'X',   -- X 1 X 
              'X',   -- X 1 0
              'X',   -- X 1 1 
              'X' ), -- X 1 Z 
            ( 'X',   -- X Z X 
              'X',   -- X Z 0
              'X',   -- X Z 1 
              'X' )),-- X Z Z 
           (( 'X',   -- 0 X X 
              'X',   -- 0 X 0
              'X',   -- 0 X 1 
              'X' ), -- 0 X Z 
            ( 'X',   -- 0 0 X 
              '0',   -- 0 0 0
              '1',   -- 0 0 1 
              '0' ), -- 0 0 Z 
            ( 'X',   -- 0 1 X 
              '1',   -- 0 1 0
              '0',   -- 0 1 1 
              '1' ), -- 0 1 Z 
            ( 'X',   -- 0 Z X 
              '0',   -- 0 Z 0
              '1',   -- 0 Z 1 
              '0' )),-- 0 Z Z 
           (( 'X',   -- 1 X X 
              'X',   -- 1 X 0
              'X',   -- 1 X 1 
              'X' ), -- 1 X Z 
            ( 'X',   -- 1 0 X 
              '1',   -- 1 0 0
              '0',   -- 1 0 1 
              '1' ), -- 1 0 Z 
            ( 'X',   -- 1 1 X 
              '0',   -- 1 1 0
              '1',   -- 1 1 1 
              '0' ), -- 1 1 Z 
            ( 'X',   -- 1 Z X 
              '1',   -- 1 Z 0
              '0',   -- 1 Z 1 
              '1' )),-- 1 Z Z 
           (( 'X',   -- Z X X 
              'X',   -- Z X 0
              'X',   -- Z X 1 
              'X' ), -- Z X Z 
            ( 'X',   -- Z 0 X 
              '1',   -- Z 0 0
              '0',   -- Z 0 1 
              '1' ), -- Z 0 Z 
            ( 'X',   -- Z 1 X 
              '1',   -- Z 1 0
              '0',   -- Z 1 1 
              '1' ), -- Z 1 Z 
            ( 'X',   -- Z Z X 
              '0',   -- Z Z 0
              '1',   -- Z Z 1 
              'X' )) -- Z Z Z 
        );

    CONSTANT f_car : f_3_x_1 := ( 
           (( 'X',   -- X X X 
              'X',   -- X X 0
              'X',   -- X X 1 
              'X' ), -- X X Z 
            ( 'X',   -- X 0 X 
              '0',   -- X 0 0
              'X',   -- X 0 1 
              '0' ), -- X 0 Z 
            ( 'X',   -- X 1 X 
              'X',   -- X 1 0
              '1',   -- X 1 1 
              'X' ), -- X 1 Z 
            ( 'X',   -- X Z X 
              '0',   -- X Z 0
              'X',   -- X Z 1 
              '0' )),-- X Z Z 
           (( 'X',   -- 0 X X 
              '0',   -- 0 X 0
              'X',   -- 0 X 1 
              '0' ), -- 0 X Z 
            ( '0',   -- 0 0 X 
              '0',   -- 0 0 0
              '0',   -- 0 0 1 
              '0' ), -- 0 0 Z 
            ( 'X',   -- 0 1 X 
              '0',   -- 0 1 0
              '1',   -- 0 1 1 
              '0' ), -- 0 1 Z 
            ( '0',   -- 0 Z X 
              '0',   -- 0 Z 0
              '0',   -- 0 Z 1 
              '0' )),-- 0 Z Z 
           (( 'X',   -- 1 X X 
              'X',   -- 1 X 0
              '1',   -- 1 X 1 
              'X' ), -- 1 X Z 
            ( 'X',   -- 1 0 X 
              '0',   -- 1 0 0
              '1',   -- 1 0 1 
              '0' ), -- 1 0 Z 
            ( '1',   -- 1 1 X 
              '1',   -- 1 1 0
              '1',   -- 1 1 1 
              '1' ), -- 1 1 Z 
            ( 'X',   -- 1 Z X 
              '0',   -- 1 Z 0
              '1',   -- 1 Z 1 
              '0' )),-- 1 Z Z 
           (( 'X',   -- Z X X 
              '0',   -- Z X 0
              'X',   -- Z X 1 
              '0' ), -- Z X Z 
            ( '0',   -- Z 0 X 
              '0',   -- Z 0 0
              '0',   -- Z 0 1 
              '0' ), -- Z 0 Z 
            ( 'X',   -- Z 1 X 
              '0',   -- Z 1 0
              '1',   -- Z 1 1 
              '0' ), -- Z 1 Z 
            ( '0',   -- Z Z X 
              '0',   -- Z Z 0
              '0',   -- Z Z 1 
              '0' )) -- Z Z Z 
      );

    ---
    -- function el_resolution(driver : el_logic_vector) return el_logic;
    ---
    function  el_resolution(driver: el_logic_vector)
          return el_logic is
       variable result: el_logic := 'Z';
       attribute synthesis_return of result:variable is "WIRED_THREE_STATE" ; 
    begin
       for t1 in driver'range loop
          case result is
             when '1' =>
                case driver(t1) is
                   when '1' => result := '1';
                   when '0' => result := 'X';
                   when 'X' => result := 'X';
                   when 'Z' => result := '1';
                end case;
             when '0' =>
                case driver(t1) is
                   when '1' => result := 'X';
                   when '0' => result := '0';
                   when 'X' => result := 'X';
                   when 'Z' => result := '0';
                end case;
             when 'X' =>
                case driver(t1) is
                   when '1' => result := 'X';
                   when '0' => result := 'X';
                   when 'X' => result := 'X';
                   when 'Z' => result := 'X';
                end case;
             when 'Z' =>
                case driver(t1) is
                   when '1' => result := '1';
                   when '0' => result := '0';
                   when 'X' => result := 'X';
                   when 'Z' => result := 'Z';
                end case;
             end case;
          end loop;
       return result;
    end el_resolution;

    ---
    -- function min  (op_l, op_r : integer) return integer 
    ---
       function min  (op_l, op_r : integer) return integer is
       begin
          if op_l < op_r then
              return op_l;
          else
              return op_r;
          end if ;
       end min;

    ---
    -- function max  (op_l, op_r : integer) return integer 
    ---
       function max  (op_l, op_r : integer) return integer is
       begin
          if op_l > op_r then
              return op_l;
          else
              return op_r;
          end if;
       end max;

    --- 
    -- Local function plus on elbit_vector
    -- Basic addition of equally sized operands.
    -- LSB is the right-most bit in the operands
    -- range of the operands should run size-1 downto 0.
    --- 
      function plus (l, r : elbit_vector) return elbit_vector is
         variable carry : elbit ;
         variable result : elbit_vector(l'length-1 downto 0) ; 
         attribute synthesis_return of result:variable is "ADD" ;
      begin
          assert (l'length = r'length) 
             report "plus : operands should be of equal size"
             severity ERROR;
         carry  := '0';
         for i in l'reverse_range loop
            result(i) := f_sum(l(i))(r(i))(carry);
            carry     := f_car(l(i))(r(i))(carry);
         end loop;
         return result;
      end plus ;

    --- 
    -- Local function plus on bit_vector
    -- Basic addition of equally sized operands.
    -- LSB is the right-most bit in the operands
    -- range of the operands should run size-1 downto 0.
    --- 
      function plus (l, r : bit_vector) return bit_vector is
         variable carry : bit ;
         variable result : bit_vector(l'length-1 downto 0) ; 
         attribute synthesis_return of result:variable is "ADD" ;
      begin
          assert (l'length = r'length) 
             report "plus : operands should be of equal size"
             severity ERROR;
         carry  := '0';
         for i in l'reverse_range loop
            result(i) := l(i) XOR r(i) XOR carry;
	    carry     := (l(i) AND r(i)) OR (carry AND (l(i) OR r(i))) ;
         end loop;
         return result;
      end plus ;

    --- 
    -- Local function minus on elbit_vector
    -- Basic subtraction of equally sized operands.
    -- LSB is the right-most bit in the operands
    -- range of the operands should run size-1 downto 0.
    --- 
      function minus (l, r : elbit_vector) return elbit_vector is
         variable carry : elbit ;
         variable op_r : elbit_vector (r'range) ;
         variable result : elbit_vector(l'length-1 downto 0) ; 
         attribute synthesis_return of result:variable is "SUB" ;
      begin
          assert (l'length = r'length) 
             report "plus : operands should be of equal size"
             severity ERROR;
         carry  := '1';
         op_r := not r;
         for i in l'reverse_range loop
            result(i) := f_sum(l(i))(op_r(i))(carry);
            carry      := f_car(l(i))(op_r(i))(carry);
         end loop;
         return result;
      end minus ;

    --- 
    -- Local function minus on bit_vector
    -- Basic subtraction of equally sized operands.
    -- LSB is the right-most bit in the operands
    -- range of the operands should run size-1 downto 0.
    --- 
      function minus (l, r : bit_vector) return bit_vector is
         variable carry : bit ;
         variable op_r : bit_vector (r'range) ;
         variable result : bit_vector(l'length-1 downto 0) ; 
         attribute synthesis_return of result:variable is "SUB" ;
      begin
          assert (l'length = r'length) 
             report "plus : operands should be of equal size"
             severity ERROR;
         carry  := '1';
         op_r := not r;
         for i in l'reverse_range loop
            result(i) := l(i) XOR op_r(i) XOR carry;
	    carry     := (l(i) AND op_r(i)) OR (carry AND (l(i) OR op_r(i))) ;
         end loop;
         return result;
      end minus ;

 -- 
 -- Definition of externally defined functions/procedures
 --

    ---
    --     function "not"   (l: elbit)           return elbit;
    ---
       function "not"   (l: elbit)           return elbit is
          variable result : elbit ;
          attribute synthesis_return of result:variable is "NOT" ; 
       begin
          result := f_not(l);
          return result ;
       end;

    ---
    --     function "not"   (l: elbit_vector)    return elbit_vector;
    ---
       function "not"   (l: elbit_vector)    return elbit_vector is
          variable result: elbit_vector(l'range);
          attribute synthesis_return of result:variable is "NOT" ; 
       begin
          for t1 in l'range loop
             result(t1) := f_not(l(t1));
          end loop;
          return result;
       end;

    ---
    --     function "not"   (l: elbit_matrix)    return elbit_matrix;
    ---
       function "not"   (l: elbit_matrix)    return elbit_matrix is
          variable result: elbit_matrix(l'range(1), l'range(2));
          attribute synthesis_return of result:variable is "NOT" ; 
       begin
          for t1 in l'range(1) loop
             for t2 in l'range(2) loop
                result(t1, t2) := f_not(l(t1, t2));
             end loop;
          end loop;
          return result;
       end;


    ---
    --     function "and"   (l, r: elbit)           return elbit;
    ---
       function "and"   (l:elbit ; r: elbit)           return elbit is
          variable result : elbit ;
          attribute synthesis_return of result:variable is "AND" ; 
       begin
          result := f_and(l)(r);
          return result ;
       end;

    ---
    --     function "and"   (l, r: elbit_vector)    return elbit_vector;
    ---
       function "and"   (l:elbit_vector ; r: elbit_vector)    return elbit_vector is
          variable result: elbit_vector(l'range);
          attribute synthesis_return of result:variable is "AND" ; 
       begin
           assert (l'length = r'length )
              report "left and right hand operand sizes of 'and' operator do not match"
              severity error;
          for t1 in l'range loop
             result(t1) := f_and(l(t1))(r(t1));
          end loop;
          return result;
       end;

    ---
    --     function "and"   (l, r: elbit_matrix)    return elbit_matrix;
    ---
       function "and"   (l: elbit_matrix; r: elbit_matrix)    
             return elbit_matrix is
          variable result: elbit_matrix(l'range(1), l'range(2));
          attribute synthesis_return of result:variable is "AND" ; 
       begin
           assert ((l'length(2) = r'length(2)) and (l'length(1) = r'length(1)))
              report "left and right hand operand sizes of 'and' operator do not match"
              severity error;
          for t1 in l'range(1) loop
             for t2 in l'range(2) loop
                result(t1, t2) := f_and(l(t1, t2))(r(t1, t2));
             end loop;
          end loop;
          return result;
       end;

    ---
    --     function "or"   (l, r: elbit)           return elbit;
    ---
       function "or"   (l: elbit ; r: elbit)           
          return elbit is
          variable result : elbit ;
          attribute synthesis_return of result:variable is "OR" ; 
       begin
          result := f_or(l)(r);
          return result ;
       end;

    ---
    --     function "or"   (l, r: elbit_vector)    return elbit_vector;
    ---
       function "or"   (l: elbit_vector ; r: elbit_vector)    
             return elbit_vector is
          variable result: elbit_vector(l'range);
          attribute synthesis_return of result:variable is "OR" ; 
       begin
           assert (l'length = r'length )
              report "left and right hand operand sizes of 'or' operator do not match"
              severity error;
          for t1 in l'range loop
             result(t1) := f_or(l(t1))(r(t1));
          end loop;
          return result;
       end;

    ---
    --     function "or"   (l, r: elbit_matrix)    return elbit_matrix;
    ---
       function "or"   (l: elbit_matrix ; r: elbit_matrix)    
             return elbit_matrix is
          variable result: elbit_matrix(l'range(1), l'range(2));
          attribute synthesis_return of result:variable is "OR" ; 
       begin
           assert ((l'length(2) = r'length(2)) and (l'length(1) = r'length(1)))
              report "left and right hand operand sizes of 'or' operator do not match"
              severity error;
          for t1 in l'range(1) loop
             for t2 in l'range(2) loop
                result(t1, t2) := f_or(l(t1, t2))(r(t1, t2));
             end loop;
          end loop;
          return result;
       end;

    ---
    --     function "nand"   (l, r: elbit)           return elbit;
    ---
       function "nand"   (l: elbit ; r: elbit)           
          return elbit is
          variable result : elbit ;
          attribute synthesis_return of result:variable is "NAND" ; 
       begin
          result := f_nand(l)(r);
          return result ;
       end;

    ---
    --     function "nand"   (l, r: elbit_vector)    return elbit_vector;
    ---
       function "nand"   (l: elbit_vector ; r: elbit_vector)    
             return elbit_vector is
          variable result: elbit_vector(l'range);
          attribute synthesis_return of result:variable is "NAND" ; 
       begin
          assert (l'length = r'length )
             report "left and right hand operand sizes of 'nand' operator do not match"
             severity error;
          for t1 in l'range loop
             result(t1) := f_nand(l(t1))(r(t1));
          end loop;
          return result;
       end;

    ---
    --     function "nand"   (l, r: elbit_matrix)    return elbit_matrix;
    ---
       function "nand"   (l: elbit_matrix ; r: elbit_matrix)    
             return elbit_matrix is
          variable result: elbit_matrix(l'range(1), l'range(2));
          attribute synthesis_return of result:variable is "NAND" ; 
       begin
          assert ((l'length(2) = r'length(2)) and (l'length(1) = r'length(1)))
             report "left and right hand operand sizes of 'nand' operator do not match"
             severity error;
          for t1 in l'range(1) loop
             for t2 in l'range(2) loop
                result(t1, t2) := f_nand(l(t1, t2))(r(t1, t2));
             end loop;
          end loop;
          return result;
       end;

    ---
    --     function "nor"   (l, r: elbit)           return elbit;
    ---
       function "nor"   (l: elbit ; r: elbit)           return elbit is
          variable result : elbit ;
          attribute synthesis_return of result:variable is "NOR" ; 
       begin
          result := f_nor(l)(r);
          return result ;
       end;

    ---
    --     function "nor"   (l, r: elbit_vector)    return elbit_vector;
    ---
       function "nor"   (l: elbit_vector ; r: elbit_vector)    
             return elbit_vector is
          variable result: elbit_vector(l'range);
          attribute synthesis_return of result:variable is "NOR" ; 
       begin
          assert (l'length = r'length )
             report "left and right hand operand sizes of 'nor' operator do not match"
             severity error;
          for t1 in l'range loop
             result(t1) := f_nor(l(t1))(r(t1));
          end loop;
          return result;
       end;

    ---
    --     function "nor"   (l, r: elbit_matrix)    return elbit_matrix;
    ---
       function "nor"   (l: elbit_matrix ; r: elbit_matrix)    
             return elbit_matrix is
          variable result: elbit_matrix(l'range(1), l'range(2));
          attribute synthesis_return of result:variable is "NOR" ; 
       begin
          assert ((l'length(2) = r'length(2)) and (l'length(1) = r'length(1)))
             report "left and right hand operand sizes of 'nor' operator do not match"
             severity error;
          for t1 in l'range(1) loop
             for t2 in l'range(2) loop
                result(t1, t2) := f_nor(l(t1, t2))(r(t1, t2));
             end loop;
          end loop;
          return result;
       end;

    ---
    --     function "xor"   (l, r: elbit)           return elbit;
    ---
       function "xor"   (l: elbit ; r: elbit)           
          return elbit is
          variable result : elbit ;
          attribute synthesis_return of result:variable is "XOR" ; 
       begin
          result := f_xor(l)(r);
          return result ;
       end;

    ---
    --     function "xor"   (l, r: elbit_vector)    return elbit_vector;
    ---
       function "xor"   (l: elbit_vector ; r: elbit_vector)    
             return elbit_vector is
          variable result: elbit_vector(l'range);
          attribute synthesis_return of result:variable is "XOR" ; 
       begin
          assert (l'length = r'length )
             report "left and right hand operand sizes of 'xor' operator do not match"
             severity error;
          for t1 in l'range loop
             result(t1) := f_xor(l(t1))(r(t1));
          end loop;
          return result;
       end;

    ---
    --     function "xor"   (l, r: elbit_matrix)    return elbit_matrix;
    ---
       function "xor"   (l: elbit_matrix ; r: elbit_matrix)    
             return elbit_matrix is
          variable result: elbit_matrix(l'range(1), l'range(2));
          attribute synthesis_return of result:variable is "XOR" ; 
       begin
          assert ((l'length(2) = r'length(2)) and (l'length(1) = r'length(1)))
             report "left and right hand operand sizes of 'xor' operator do not match"
             severity error;
          for t1 in l'range(1) loop
             for t2 in l'range(2) loop
                result(t1, t2) := f_xor(l(t1, t2))(r(t1, t2));
             end loop;
          end loop;
          return result;
       end;

    ---
    --     function bool2elb   (l: boolean)                    return elbit;
    ---
       function bool2elb   (l: boolean)                    
             return elbit is
       begin
           if l then
             return '1';
           else
             return '0';
           end if;
        end bool2elb;

    ---
    --     function bool2elb   (l: boolean)                    return bit;
    ---
       function bool2elb   (l: boolean)                    
             return bit is
       begin
           if l then
             return '1';
           else
             return '0';
           end if;
        end bool2elb;

    ---
    --     function elb2bool   (l: elbit)                      return boolean;
    ---
        function elb2bool   (l: elbit)                      
           return boolean is
        begin
           if l = '1' then
              return true;
           else
              return false;
           end if;
        end elb2bool;

    ---
    --     function elb2bool   (l: bit)                      return boolean;
    ---
        function elb2bool   (l: bit)                      
           return boolean is
        begin
           if l = '1' then
              return true;
           else
              return false;
           end if;
        end elb2bool;

    --- 
    --     function elb2int   (l: elbit)                      return natural;
    ---
       function elb2int   (l: elbit)                      
          return natural is
       begin
           if l = '1' then
              return 1;
           else
              return 0;
           end if;
        end elb2int;

    --- 
    --     function elb2int   (l: bit)                      return natural;
    ---
       function elb2int   (l: bit)                      
          return natural is
       begin
           if l = '1' then
              return 1;
           else
              return 0;
           end if;
        end elb2int;

    ---
    --    function sl       (l: elbit_vector; r: integer)     return elbit_vector;
    ---
        function sl       (l: elbit_vector; r: integer)     
	       return elbit_vector is
           alias la : elbit_vector (l'length-1 downto 0) is l ;
           variable result : elbit_vector (l'length-1 downto 0) ;
           constant zero : elbit_vector (l'length-1 downto 0) := (others=>'0') ;
           attribute synthesis_return of result:variable is "SLL" ; 
	begin
            -- Shift in zero. Shifting negative amount is legal (same as right shift). 
           if (ABS(r) >= l'length) then
               result := zero ;
           elsif (r >= 0) then
               result :=  la(l'length-1-r downto 0) & zero (r-1 downto 0) ;
           else -- (r < 0)  
               result := zero (-r-1 downto 0) & (la(l'length-1 downto -r)) ;
           end if ;
	   return result ;
        end sl ;
    ---
    --    function sl       (l: bit_vector; r: integer)     return bit_vector;
    ---
        function sl       (l: bit_vector; r: integer)     return bit_vector is
           alias la : bit_vector (l'length-1 downto 0) is l ;
           variable result : bit_vector (l'length-1 downto 0) ;
           constant zero : bit_vector (l'length-1 downto 0) := (others=>'0') ;
           attribute synthesis_return of result:variable is "SLL" ; 
	begin
            -- Shift in zero. Shifting negative amount is legal (same as right shift). 
           if (ABS(r) >= l'length) then
               result := zero ;
           elsif (r >= 0) then
               result :=  la(l'length-1-r downto 0) & zero (r-1 downto 0) ;
           else -- (r < 0)  
               result := zero (-r-1 downto 0) & (la(l'length-1 downto -r)) ;
           end if ;
           return result ;
        end sl ;

    ---
    --    function sl2       (l: elbit_vector; r: integer)     return elbit_vector;
    ---
        function sl2       (l: elbit_vector; r: integer)     return elbit_vector is
           variable result : elbit_vector (l'length-1 downto 0) ;
           attribute synthesis_return of result:variable is "SLA" ; 
	begin
	    -- Two's complement : no difference with unsigned sl ;
           result := sl (l, r) ;
	   return result ;
        end sl2 ;

    ---
    --    function sl2       (l: bit_vector; r: integer)     return bit_vector;
    ---
        function sl2       (l: bit_vector; r: integer)     return bit_vector is
           variable result : bit_vector (l'length-1 downto 0) ;
           attribute synthesis_return of result:variable is "SLA" ; 
	begin
	    -- Two's complement : no difference with unsigned sl ;
           result := sl (l, r) ;
	   return result ;
        end sl2 ;

    ---
    --    function sr       (l: elbit_vector; r: integer)     return elbit_vector;
    ---
        function sr       (l: elbit_vector; r: integer)     return elbit_vector is
           variable result : elbit_vector (l'length-1 downto 0) ;
           attribute synthesis_return of result:variable is "SRL" ; 
	begin
            -- Shift in zero. This sl with negative shift.
           result := sl (l, -r) ;
           return result ;
        end sr ;

    ---
    --    function sr       (l: bit_vector; r: integer)     return bit_vector;
    ---
        function sr       (l: bit_vector; r: integer)     return bit_vector is
           variable result : bit_vector (l'length-1 downto 0) ;
           attribute synthesis_return of result:variable is "SRL" ; 
	begin
            -- Shift in zero. This sl with negative shift.
           result := sl (l, -r) ;
           return result ;
        end sr ;

    ---
    --    function sr2       (l: elbit_vector; r: integer)     return elbit_vector;
    ---
        function sr2       (l: elbit_vector; r: integer)     return elbit_vector is
           alias la : elbit_vector (l'length-1 downto 0) is l ;
           variable sign : elbit_vector (l'length-1 downto 0) ;
           variable result : elbit_vector (l'length-1 downto 0) ;
           attribute synthesis_return of result:variable is "SRA" ; 
	begin
           if (r > 0) then -- Shift right with left most bit as filling
               sign := (others => l(l'left)) ;
               if (r > l'length) then
                   result := sign ;
               else 
                   result := sign (r-1 downto 0) & la(l'length-1 downto r) ;
               end if ;
           elsif (r < 0) then -- Shift left, with right most bit as filling
               sign := (others => l(l'right)) ;
               if (-r > l'length) then
                   result := sign ;
               else 
                   result := la(l'length+r-1 downto 0) & sign (-r-1 downto 0) ;
               end if ;
           else -- (r = 0)  
               result := l ;
           end if ;
           return result ;
        end sr2 ;

    ---
    --    function sr2       (l: bit_vector; r: integer)     return bit_vector;
    ---
        function sr2       (l: bit_vector; r: integer)     return bit_vector is
           alias la : bit_vector (l'length-1 downto 0) is l ;
           variable sign : bit_vector (l'length-1 downto 0) ;
           variable result : bit_vector (l'length+r-1 downto 0) ;
           attribute synthesis_return of result:variable is "SRA" ; 
	begin
           if (r > 0) then -- Shift right with left most bit (sign bit) as filling
               sign := (others => l(l'left)) ;
               if (r > l'length) then
                   result := sign ;
               else 
                   result := sign (r-1 downto 0) & la(l'length-1 downto r) ;
               end if ;
           elsif (r < 0) then -- Shift left, with right most bit as filling
               sign := (others => l(l'right)) ;
               if (-r > l'length) then
                   result := sign ;
               else 
                   result := la(l'length+r-1 downto 0) & sign (-r-1 downto 0) ;
               end if ;
           else -- (r = 0)  
               result := l ;
           end if ;
           return result ;
        end sr2 ;

    ---
    --     function evec2int (l: elbit_vector)                      return natural;
    ---
       -- Unsigned vector to (positive) integer
       -- Left bit is going to be MSB 
       function evec2int (l: elbit_vector)                      return natural is
          variable result: natural := 0;
           attribute synthesis_return of result:variable is "FEED_THROUGH" ; 
       begin
          for t1 in l'range loop
             result := result * 2;
             if l(t1) = '1' then
                result := result + 1;
             end if;
          end loop;
          return result;
       end evec2int;

    ---
    --     function evec2int (l: bit_vector)                      return natural;
    ---
       function evec2int (l: bit_vector)                      
             return natural is
          variable result: natural := 0;
          attribute synthesis_return of result:variable is "FEED_THROUGH" ; 
       begin
          for t1 in l'range loop
             result := result * 2;
             if l(t1) = '1' then
                result := result + 1;
             end if;
          end loop;
          return result;
       end evec2int;

    ---
    --     function int2evec (l: integer; size: integer) return elbit_vector;
    ---
       -- Left bit is going to be MSB ; 
       -- If integer is negative, MSB bit will become sign bit 
       -- Parameter 'size' is optional, If omitted result vector defaults to 32 bits

       function int2evec (l: integer; size: integer := 32)                      
             return elbit_vector is
          variable result: elbit_vector(size-1 downto 0);
          variable op: integer := l;
          variable neg_fl: boolean := false;
          attribute synthesis_return of result:variable is "FEED_THROUGH" ; 
       begin
          result := (size-1 downto 0 => '0');
          if op < 0 then
             op := op * (-1);
             neg_fl := true;
          end if;

          for i in 0 to SIZE-1 loop
             if (op mod 2) = 1 then
                result (i) := '1' ;
             end if ;
             op := op/2 ;
          end loop ;

          if neg_fl then
             result := comp2(result);
          end if;

          return result;
       end int2evec;

    ---
    --     function int2evec (op: integer; size: integer) return bit_vector;
    ---
       -- Left bit is going to be MSB ; 
       -- If integer is negative, MSB bit will become sign bit 
       -- Parameter 'size' is optional, If omitted result vector defaults to 32 bits

       function int2evec (l: integer; size: integer := 32)                      
             return bit_vector is
          variable result: bit_vector(size-1 downto 0);
          variable op: integer := l;
          variable neg_fl: boolean := false;
          attribute synthesis_return of result:variable is "FEED_THROUGH" ; 
       begin
          result := (size-1 downto 0 => '0');
          if op < 0 then
             op := op * (-1);
             neg_fl := true;
          end if;

          for i in 0 to SIZE-1 loop
             if (op mod 2) = 1 then
                result (i) := '1' ;
             end if ;
             op := op/2 ;
          end loop ;

          if neg_fl then
             result := comp2(result);
          end if;

          return result;
       end int2evec;

    ---
    --  function int2boo    (l: integer)      return boolean;
    ---
      function int2boo    (l: integer)                      
            return boolean is
      begin
         if l = 0 then
            return false;
         else
            return true;
         end if;
      end int2boo;

    ---
    -- function boo2int  (l: boolean)   return natural;
    ---
      function boo2int (l: boolean)
            return natural is
      begin
         if l = false then
            return 0;
         else
            return 1;
         end if;
      end boo2int;

    ---
    -- function add (op_l, op_r: elbit_vector) return elbit_vector;
    ---
      function add (op_l, op_r: elbit_vector) return elbit_vector is
         constant size  : integer := max(op_l'length, op_r'length)+1;
         variable oper_l: elbit_vector(size-1 downto 0);
         variable oper_r: elbit_vector(size-1 downto 0);
         variable result: elbit_vector(size-1 downto 0);
         attribute synthesis_return of result:variable is "ADD" ;
      begin
         oper_l := extend(op_l, size);
         oper_r := extend(op_r, size);
         result := plus (oper_l, oper_r) ;
         return result ;
      end add;
         
    ---
    -- function add (op_l, op_r: bit_vector) return bit_vector;
    ---
      function add (op_l, op_r: bit_vector) return bit_vector is
         constant size  : integer := max(op_l'length, op_r'length)+1;
         variable oper_l: bit_vector(size-1 downto 0);
         variable oper_r: bit_vector(size-1 downto 0);
         variable result: bit_vector(size-1 downto 0);
         attribute synthesis_return of result:variable is "ADD" ;
      begin
         oper_l := extend(op_l, size);
         oper_r := extend(op_r, size);
         result := plus (oper_l, oper_r) ;
         return result;
      end add;
         
    ---
    -- function add2 (op_l, op_r: elbit_vector) return elbit_vector;
    ---
      function add2 (op_l, op_r: elbit_vector) return elbit_vector is
         constant size  : integer := max(op_l'length, op_r'length)+1;
         variable oper_l: elbit_vector(size-1 downto 0);
         variable oper_r: elbit_vector(size-1 downto 0);
         variable result: elbit_vector(size-1 downto 0);
         attribute is_signed of op_l:constant is TRUE ;
         attribute is_signed of op_r:constant is TRUE ;
		 attribute is_signed of result:variable is TRUE ;
         attribute synthesis_return of result:variable is "ADD" ;
      begin
         oper_l := extend2(op_l, size);
         oper_r := extend2(op_r, size);
         result := plus (oper_l, oper_r) ;
         return result;
      end add2;

    ---
    -- function add2 (op_l, op_r: bit_vector) return bit_vector;
    ---
      function add2 (op_l, op_r: bit_vector) return bit_vector is
         constant size  : integer := max(op_l'length, op_r'length)+1;
         variable oper_l: bit_vector(size-1 downto 0);
         variable oper_r: bit_vector(size-1 downto 0);
         variable result: bit_vector(size-1 downto 0);
         attribute is_signed of op_l:constant is TRUE ;
         attribute is_signed of op_r:constant is TRUE ;
		 attribute is_signed of result:variable is TRUE ;
         attribute synthesis_return of result:variable is "ADD" ;
      begin
         oper_l := extend2(op_l, size);
         oper_r := extend2(op_r, size);
         result := plus (oper_l, oper_r) ;
         return result;
      end add2;
         
    ---
    -- function sub (op_l, op_r: elbit_vector) return elbit_vector;
    ---
      function sub (op_l, op_r: elbit_vector) return elbit_vector is
         constant size  : integer := max(op_l'length, op_r'length) + 1;
         variable oper_l: elbit_vector(size-1 downto 0);
         variable oper_r: elbit_vector(size-1 downto 0);
         variable result: elbit_vector(size-1 downto 0);
         attribute synthesis_return of result:variable is "SUB" ;
      begin
         oper_l := extend(op_l, size);
         oper_r := extend(op_r, size);
         result := minus (oper_l, oper_r) ;
         return result;
      end sub;

    ---
    -- function sub (op_l, op_r: bit_vector) return bit_vector;
    ---
      function sub (op_l, op_r: bit_vector) return bit_vector is
         constant size  : integer := max(op_l'length, op_r'length) + 1;
         variable oper_l: bit_vector(size-1 downto 0);
         variable oper_r: bit_vector(size-1 downto 0);
         variable result: bit_vector(size-1 downto 0);
         attribute synthesis_return of result:variable is "SUB" ;
      begin
         oper_l := extend(op_l, size);
         oper_r := extend(op_r, size);
         result := minus (oper_l, oper_r) ;
         return result;
      end sub;
         
    ---
    -- function sub2 (op_l, op_r: elbit_vector) return elbit_vector;
    ---
      function sub2 (op_l, op_r: elbit_vector)
            return elbit_vector is
         constant size  : integer := max(op_l'length, op_r'length)+1;
         variable oper_l: elbit_vector(size-1 downto 0);
         variable oper_r: elbit_vector(size-1 downto 0);
         variable result: elbit_vector(size-1 downto 0);
         attribute is_signed of op_l:constant is TRUE ;
         attribute is_signed of op_r:constant is TRUE ;
		 attribute is_signed of result:variable is TRUE ;
         attribute synthesis_return of result:variable is "SUB" ;
      begin
         oper_l := extend2(op_l, size);
         oper_r := extend2(op_r, size);
         result := minus (oper_l, oper_r) ;
         return result;
      end sub2;
         

    ---
    -- function sub2 (op_l, op_r: bit_vector) return bit_vector;
    ---
      function sub2 (op_l, op_r: bit_vector)
            return bit_vector is
         constant size  : integer := max(op_l'length, op_r'length)+1;
         variable oper_l: bit_vector(size-1 downto 0);
         variable oper_r: bit_vector(size-1 downto 0);
         variable result: bit_vector(size-1 downto 0);
         attribute is_signed of op_l:constant is TRUE ;
         attribute is_signed of op_r:constant is TRUE ;
		 attribute is_signed of result:variable is TRUE ;
         attribute synthesis_return of result:variable is "SUB" ;
      begin
         oper_l := extend2(op_l, size);
         oper_r := extend2(op_r, size);
         result := minus (oper_l, oper_r) ;
         return result;
      end sub2;
         
    ---
    -- function mult (op_l, op_r: elbit_vector)          return elbit_vector;
    -- Basic multiplication function for two unsigned elbit_vectors
    -- Left most bit in op_l and op_r is considered MSB
    ---
    function mult  (op_l, op_r: elbit_vector)          return elbit_vector is
        alias l : elbit_vector (op_l'length-1 downto 0) is op_l ;
        variable result,temp : elbit_vector(op_l'length+op_r'length-1 downto 0);
        attribute synthesis_return of result:variable is "MULT" ; 
    begin
        result := (others => '0');
        temp := extend (op_r,temp'length);
        for i in 0 to l'length-1 loop
          if l(i)='1' then
            result := result + temp;
          end if;
          temp := sl(temp,1);
        end loop;
        return result;
    end mult ;
 
    --- 
    -- function mult  (op_l, op_r: bit_vector)            return bit_vector ;
    -- Basic multiplication function for two unsigned bit_vectors
    -- Left most bit in op_l and op_r is considered MSB
    ---
    function mult  (op_l, op_r: bit_vector)            return bit_vector is 
        alias l : bit_vector (op_l'length-1 downto 0) is op_l ;
        variable result,temp : bit_vector(op_l'length+op_r'length-1 downto 0);
        attribute synthesis_return of result:variable is "MULT" ; 
    begin
        result := (others => '0');
        temp := extend (op_r,temp'length);
        for i in 0 to l'length-1 loop
          if l(i)='1' then
            result := result + temp;
          end if;
          temp := sl(temp,1);
        end loop;
        return result;
    end mult ;

    --- 
    -- function mult2 (op_l, op_r: elbit_vector)          return elbit_vector;
    -- Basic multiplication function for two signed elbit_vectors
    ---
    function mult2 (op_l, op_r: elbit_vector)          return elbit_vector is
        variable result,temp_r : elbit_vector(op_l'length+op_r'length-1 downto 0) ;
        variable temp_l : elbit_vector (op_l'length-1 downto 0) ;
        variable neg_fl : elbit ;
        attribute is_signed of op_l:constant is TRUE ;
        attribute is_signed of op_r:constant is TRUE ;
		attribute is_signed of result:variable is TRUE ;
        attribute synthesis_return of result:variable is "MULT" ; 
    begin
        neg_fl := op_l(op_l'left) xor op_r(op_r'left);
        temp_l := abs(op_l) ;
        temp_r := extend (abs(op_r),result'length) ;
        result := (others => '0');
        for i in 0 to op_l'length-1 loop
          if temp_l(i) = '1' then
            result := result + temp_r;
          end if;
          temp_r := sl2(temp_r,1);
        end loop;
        if (neg_fl='1') then
          return comp2(result);
        else
          return result;
        end if;
    end mult2 ;

    ---
    -- function mult2 (op_l, op_r: bit_vector)            return bit_vector;
    -- Basic multiplication function for two signed bitvectors
    ---
    function mult2 (op_l, op_r: bit_vector)            return bit_vector is
        variable result,temp_r : bit_vector(op_l'length+op_r'length-1 downto 0);
        variable temp_l : bit_vector (op_l'length-1 downto 0) ;
        variable neg_fl : bit ;
        attribute is_signed of op_l:constant is TRUE ;
        attribute is_signed of op_r:constant is TRUE ;
		attribute is_signed of result:variable is TRUE ;
        attribute synthesis_return of result:variable is "MULT" ; 
    begin
        neg_fl := op_l(op_l'left) xor op_r(op_r'left);
        temp_l := abs(op_l) ;
        temp_r := extend (abs(op_r),result'length) ;
        result := (others => '0');
        for i in 0 to op_l'length-1 loop
          if temp_l(i) = '1' then
            result := result + temp_r;
          end if;
          temp_r := sl2(temp_r,1);
        end loop;
        if (neg_fl='1') then
          return comp2(result);
        else
          return result;
        end if;
    end mult2 ;

    ---
    -- function extend(op_l: elbit; op_r: integer) return elbit_vector    
    ---
-- 
--    function extend(op_l: elbit; op_r: integer) return elbit_vector is
--        variable vec : elbit_vector (0 downto 0) ;
--    begin
--        vec := (others=>op_l) ;
--        return extend(vec,op_r) ;
--    end extend ;

    ---
    -- function extend(op_l: bit; op_r: integer) return bit_vector    
    ---
-- 
--    function extend(op_l: bit; op_r: integer) return bit_vector is
--        variable vec : bit_vector (0 downto 0) ;
--    begin
--        vec := (others=>op_l) ;
--        return extend(vec,op_r) ;
--    end extend ;
 

    ---
    --  function extend   (l: elbit_vector  r: integer)   return elbit_vector;
    ---
       function extend   (op_l: elbit_vector; op_r: integer)   
             return elbit_vector is
          variable result : elbit_vector(op_r-1 downto 0);
          alias invec : elbit_vector (op_l'length-1 downto 0) is op_l ;
          constant bound : natural := min(op_l'length,op_r)-1 ;
          attribute synthesis_return of result:variable is "FEED_THROUGH" ; 
       begin
          assert (op_l'length <= op_r )
             report "Unsigned extend operation is a truncation of bits"
             severity WARNING;
          result := (others=>'0');
          result(bound downto 0) := invec(bound downto 0) ;
          return result;
       end extend;

    ---
    --  function extend   (l: bit_vector  r: integer)   return bit_vector;
    ---
       function extend   (op_l: bit_vector; op_r: integer)   
             return bit_vector is
          variable result : bit_vector(op_r-1 downto 0);
          alias invec : bit_vector (op_l'length-1 downto 0) is op_l ;
          constant bound : natural := min(op_l'length,op_r)-1 ;
          attribute synthesis_return of result:variable is "FEED_THROUGH" ; 
       begin
          assert (op_l'length <= op_r )
             report "Unsigned extend operation is a truncation of bits"
             severity WARNING;
          result := (others=>'0');
          result(bound downto 0) := invec(bound downto 0) ;
          return result;
       end extend;

    ---
    -- function extend2(op_l: elbit; op_r: integer) return elbit_vector    
    ---
--
--    function extend2(op_l: elbit; op_r: integer) return elbit_vector is
--        variable vec : elbit_vector (0 downto 0) ;
--    begin
--        vec := (others=>op_l) ;
--        return extend2(vec,op_r) ;
--    end extend2 ;

    ---
    -- function extend2(op_l: bit; op_r: integer) return bit_vector    
    ---
-- 
--    function extend2(op_l: bit; op_r: integer) return bit_vector is
--        variable vec : bit_vector (0 downto 0) ;
--    begin
--        vec := (others=>op_l) ;
--        return extend2(vec,op_r) ;
--    end extend2 ;
 

    ---
    --  function extend2 (l: elbit_vector  r: integer) return elbit_vector;
    ---
       function extend2   (op_l: elbit_vector;  op_r: integer)   
             return elbit_vector is
          variable result : elbit_vector(op_r-1 downto 0);
          alias invec : elbit_vector (op_l'length-1 downto 0) is op_l ;
          constant bound : natural := min(op_l'length,op_r)-1 ;
          attribute is_signed of op_l:constant is TRUE ;
          attribute synthesis_return of result:variable is "FEED_THROUGH" ; 
       begin
          assert (op_l'length <= op_r )
             report "Signed extend operation is a truncation of bits"
             severity WARNING;
          result := (others=>op_l(op_l'left));
          result(bound downto 0) := invec(bound downto 0) ;
          return result;
       end extend2;

    ---
    --  function extend2 (l: bit_vector  r: integer) return bit_vector;
    ---
       function extend2   (op_l: bit_vector;  op_r: integer)   
             return bit_vector is
          variable result : bit_vector(op_r-1 downto 0);
          alias invec : bit_vector (op_l'length-1 downto 0) is op_l ;
          constant bound : natural := min(op_l'length,op_r)-1 ;
          attribute is_signed of op_l:constant is TRUE ;
          attribute synthesis_return of result:variable is "FEED_THROUGH" ; 
       begin
          assert (op_l'length <= op_r )
             report "Signed extend operation is a truncation of bits"
             severity WARNING;
          result := (others=>op_l(op_l'left));
          result(bound downto 0) := invec(bound downto 0) ;
          return result;
       end extend2;

    ---
    -- function comp2 ( op: elbit_vector) return elbit_vector;
    ---
       function comp2 ( op: elbit_vector) return elbit_vector is
           variable result : elbit_vector (op'length-1 downto 0) ;
           attribute synthesis_return of result:variable is "UMINUS" ;
       begin
           result := (not op) + "1" ;
           return result ;
       end comp2 ;

    ---
    -- function comp2 ( op: bit_vector) return bit_vector;
    ---
       function comp2 ( op: bit_vector) return bit_vector is
           variable result : bit_vector (op'length-1 downto 0) ;
           attribute synthesis_return of result:variable is "UMINUS" ;
       begin
           result := (not op) + "1" ;
           return result ;
       end comp2 ;


    ---
    -- function "+" (op_l, op_r: elbit_vector) return elbit_vector;
    ---
      function "+" (op_l, op_r: elbit_vector) return elbit_vector is
         constant size  : integer := max(op_l'length, op_r'length);
         variable oper_l : elbit_vector (size-1 downto 0) ;
         variable oper_r : elbit_vector (size-1 downto 0) ;
         variable result : elbit_vector (size-1 downto 0);
         attribute synthesis_return of result:variable is "ADD" ; 
      begin
         oper_l := extend (op_l,size) ;
         oper_r := extend (op_r,size) ;
	 result := plus (oper_l, oper_r) ;
	 return result ;
      end "+";

    ---
    -- function "+" (op_l, op_r: bit_vector) return bit_vector;
    ---
      function "+" (op_l, op_r: bit_vector) return bit_vector is
         constant size  : integer := max(op_l'length, op_r'length);
         variable oper_l : bit_vector (size-1 downto 0) ;
         variable oper_r : bit_vector (size-1 downto 0) ;
         variable result : bit_vector (size-1 downto 0);
         attribute synthesis_return of result:variable is "ADD" ; 
      begin
         oper_l := extend (op_l,size) ;
         oper_r := extend (op_r,size) ;
	 result := plus (oper_l, oper_r) ;
	 return result ;
      end "+";
    
    ---
    -- function "-" (op_l, op_r: elbit_vector) return elbit_vector;
    ---
      function "-" (op_l, op_r: elbit_vector)
            return elbit_vector is
         constant size  : integer := max(op_l'length, op_r'length);
         variable oper_l : elbit_vector (size-1 downto 0) ;
         variable oper_r : elbit_vector (size-1 downto 0) ;
         variable result : elbit_vector (size-1 downto 0);
         attribute synthesis_return of result:variable is "SUB" ; 
      begin
         oper_l := extend (op_l,size) ;
         oper_r := extend (op_r,size) ;
	 result := minus (oper_l, oper_r) ;
	 return result ;
      end "-";

    ---
    -- function "-" (op_l, op_r: bit_vector) return bit_vector;
    ---
      function "-" (op_l, op_r: bit_vector)
            return bit_vector is
         constant size   : integer := max(op_l'length, op_r'length);
         variable oper_l : bit_vector (size-1 downto 0) ;
         variable oper_r : bit_vector (size-1 downto 0) ;
         variable result : bit_vector (size-1 downto 0);
         attribute synthesis_return of result:variable is "SUB" ; 
      begin
         oper_l := extend (op_l,size) ;
         oper_r := extend (op_r,size) ;
	 result := minus (oper_l, oper_r) ;
	 return result ;
      end "-";

   ---
   -- function "abs"   (op: elbit_vector)   return elbit_vector;
   ---

     function "abs"    (op: elbit_vector)     return elbit_vector is
         variable result : elbit_vector (op'length-1 downto 0) ;
         attribute is_signed of op:constant is TRUE ;
         attribute synthesis_return of result:variable is "ABS" ; 
     begin
        if (op(op'left)='1') then
            result := comp2(op) ;
        else
            result := op ;
        end if ;
        return result ;
     end "abs" ;

   ---
   -- function "abs"   (op: bit_vector)   return bit_vector;
   ---

     function "abs"    (op: bit_vector)     return bit_vector is
         variable result : bit_vector (op'length-1 downto 0) ;
         attribute is_signed of op:constant is TRUE ;
         attribute synthesis_return of result:variable is "ABS" ; 
     begin
        if (op(op'left)='1') then
            result := comp2(op) ;
        else
            result := op ;
        end if ;
        return result ;
     end "abs" ;

  
   --- 
   -- bus procedures
   ---

    procedure pullup  (signal data: inout bit) is
        -- For synthesis, create a pullup.
        attribute synthesis_return of data:signal is "PULL_UP" ;
    begin
       -- there is no Z in bit, so do nothing
    end pullup ;
    
    procedure pullup  (signal data: inout elbit) is
        attribute synthesis_return of data:signal is "PULL_UP" ;
    begin
        if (data = 'Z') then
            data <= '1' ;
        elsif (data='X') then
            data <= 'Z' ;
        end if ;
    end pullup ;

    procedure pulldn  (signal data: inout bit) is
        -- For synthesis, create a pull-down. 
        attribute synthesis_return of data:signal is "PULL_DN" ;
    begin
       -- there is no Z in bit, so do nothing
    end pulldn ;

    procedure pulldn  (signal data: inout elbit) is
        attribute synthesis_return of data:signal is "PULL_DN" ;
    begin
        if (data='Z') then
            data<= '0' ;
        elsif (data='X') then
            data<= 'Z' ;
        end if ;
    end pulldn ;

    procedure trstmem (signal data: inout bit) is
        -- For synthesis, create a trstmem.
        attribute synthesis_return of data:signal is "TRST_MEM" ;
    begin
       -- there is no Z in bit, so do nothing
    end trstmem ; 

    procedure trstmem (signal data: inout elbit) is
        attribute synthesis_return of data:signal is "TRST_MEM" ;
    begin
       if (data = 'Z') then
	  data <= data'last_value ;
       end if; 
    end trstmem ; 

 
   --- 
   -- edge triggered D - flip-flops
   ---
          
    procedure dff (     constant data     : in bit;
                        signal clk      : in bit;
                        signal q        : out bit)
    is begin
        if (clk'event and clk = '1') then
            q <= data ;
        end if;
    end dff;
          
    procedure dff (     constant data     : in elbit;
                        signal clk      : in elbit;
                        signal q        : out elbit)
    is begin
        if (clk'event and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z'
        end if ;
        if (clk /= '0' and clk /= '1') then 
            q <= 'X';            
        end if ;
    end dff;

    procedure dff_v (   constant data     : in bit_vector;
                        signal clk      : in bit;
                        signal q        : out bit_vector)
    is begin
        if (clk'event and clk = '1') then
            q <= data ;
        end if;
    end dff_v;


    procedure dff_v (   constant data     : in elbit_vector;
                        signal clk      : in elbit;
                        signal q        : out elbit_vector)
    is begin
        if (clk'event and clk = '1') then  
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
        if (clk /= '0' and clk /= '1') then 
            q <= (q'range => 'X') ;
        end if ;
    end dff_v;
 
   --- 
   -- edge triggered D - flip-flop with preset (active high)
   ---

    procedure dffp (	constant data	: in bit;
			constant preset	: in bit;
			signal clk	: in bit;
			signal q	: out bit)
    is begin
	if (preset = '1') then
	    q <= '1' ;
	elsif (clk'event and clk = '1') then
	    q <= data ;
	end if;
    end dffp;

    procedure dffp_v (	constant data	: in bit_vector;
			constant preset	: in bit;
			signal clk	: in bit;
			signal q	: out bit_vector)
    is begin
        if (preset = '1') then
            q <= (q'range => '1') ;
        elsif (clk'event and clk = '1') then
            q <= data ;
        end if;
    end dffp_v;

    procedure dffp (	constant data	: in elbit;
			constant preset	: in elbit;
			signal clk	: in elbit;
			signal q	: out elbit)
    is begin
	if (preset = '1') then
	    q <= '1' ;
        elsif (clk'event and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if ((preset /= '0' and preset /= '1') or 
            (clk /= '0' and clk /= '1')) then 
            q <= 'X' ;
        end if ;
    end dffp;

    procedure dffp_v (	constant data	: in elbit_vector;
			constant preset	: in elbit;
			signal clk	: in elbit;
			signal q	: out elbit_vector)
    is begin
	if (preset = '1') then
	    q <= (q'range => '1') ;
        elsif (clk'event and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if ((preset /= '0' and preset /= '1') or
	    (clk /= '0' and clk /= '1')) then
	    q <= (q'range => 'X') ;
        end if ;
    end dffp_v;

   --- 
   -- edge triggered D - flip-flop with clear (active high)
   ---

    procedure dffc (	constant data	: in bit;
			constant clear 	: in bit;
			signal clk	: in bit;
			signal q	: out bit)
    is begin
	if (clear  = '1') then
	    q <= '0' ;
	elsif (clk'event and clk = '1') then
	    q <= data ;
	end if;
    end dffc;

    procedure dffc_v (	constant data	: in bit_vector;
			constant clear 	: in bit;
			signal clk	: in bit;
			signal q	: out bit_vector)
    is begin
	if (clear  = '1') then
	    q <= (q'range => '0') ;
	elsif (clk'event and clk = '1') then
	    q <= data ;
	end if;
    end dffc_v;

    procedure dffc (	constant data	: in elbit;
			constant clear 	: in elbit;
			signal clk	: in elbit;
			signal q	: out elbit)
    is begin
	if (clear = '1') then
	    q <= '0' ;
        elsif (clk'event and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if ((clear /= '0' and clear /= '1') or 
            (clk /= '0' and clk /= '1')) then 
            q <= 'X' ;
        end if ;
    end dffc;

    procedure dffc_v (	constant data	: in elbit_vector;
			constant clear 	: in elbit;
			signal clk	: in elbit;
			signal q	: out elbit_vector)
    is begin
	if (clear = '1') then
	    q <= (q'range => '0') ;
        elsif (clk'event and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if ((clear /= '0' and clear /= '1') or
	    (clk /= '0' and clk /= '1')) then
	    q <= (q'range => 'X') ;
        end if ;
    end dffc_v;

   --- 
   -- edge triggered D - flip-flop with preset and clear. 
   ---

    procedure dffpc (	constant data	: in bit;
			constant preset	: in bit;
			constant clear 	: in bit;
			signal clk	: in bit;
			signal q	: out bit)
    is begin
	if (preset = '1') then
	    q <= '1' ;
        elsif (clear = '1') then
	    q <= '0' ;
        elsif (clk'event and clk = '1') then
	    q <= data ;
	end if;
    end dffpc;

   --- 
   -- edge triggered D - flip-flop with preset, clear and clock enable. 
   ---

    procedure dffpce (	constant data	: in bit;
			constant preset	: in bit;
			constant clear 	: in bit;
			constant enable 	: in bit;
			signal clk	: in bit;
			signal q	: out bit)
    is begin
	if (preset = '1') then
	    q <= '1' ;
        elsif (clear = '1') then
	    q <= '0' ;
        elsif (clk'event and clk = '1') then
            if (enable = '1') then
	        q <= data ;
            end if ;
	end if;
    end dffpce;

    procedure dffpc_v (	constant data	: in bit_vector;
			constant preset	: in bit;
			constant clear 	: in bit;
			signal clk	: in bit;
			signal q	: out bit_vector)
    is begin
	if (preset = '1') then
	    q <= (q'range => '1') ;
	elsif (clear = '1') then
	    q <= (q'range => '0') ;
	elsif (clk'event and clk = '1') then
	    q <= data ;
	end if;
    end dffpc_v;

    procedure dffpc (	constant data	: in elbit;
			constant preset	: in elbit;
			constant clear 	: in elbit;
			signal clk	: in elbit;
			signal q	: out elbit)
    is begin
	if (preset = '1') then
	    q <= '1' ;
	elsif (clear = '1') then
	    q <= '0' ;
        elsif (clk'event and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if ((clear /= '0' and clear /= '1') or 
	    (preset/= '0' and preset/= '1') or 
            (clk /= '0' and clk /= '1')) then 
            q <= 'X' ;
        end if ;
    end dffpc;

   --- 
   -- edge triggered D - flip-flop with preset, clear and clock enable. 
   ---

    procedure dffpce (	constant data	: in elbit;
			constant preset	: in elbit;
			constant clear 	: in elbit;
			constant enable	: in elbit;
			signal clk	: in elbit;
			signal q	: out elbit)
    is begin
	if (preset = '1') then
	    q <= '1' ;
	elsif (clear = '1') then
	    q <= '0' ;
        elsif (clk'event and clk = '1') then
            if (enable = '1') then
                q <= data and data ;    -- takes care of q<='X' if data='Z' 
            end if ;
        end if ;
	if ((clear /= '0' and clear /= '1') or 
	    (preset/= '0' and preset/= '1') or 
            (clk /= '0' and clk /= '1')) then 
            q <= 'X' ;
        end if ;
    end dffpce;

   --- 
   -- edge triggered D - flip-flop register with preset and clear. 
   ---

    procedure dffpc_v (	constant data	: in elbit_vector;
			constant preset	: in elbit;
			constant clear 	: in elbit;
			signal clk	: in elbit;
			signal q	: out elbit_vector)
    is begin
	if (preset = '1') then
	    q <= (q'range => '1') ;
	elsif (clear = '1') then
	    q <= (q'range => '0') ;
        elsif (clk'event and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if ((clear /= '0' and clear /= '1') or
	    (preset/= '0' and preset/= '1') or
	    (clk /= '0' and clk /= '1')) then
	    q <= (q'range => 'X') ;
        end if ;
    end dffpc_v;


    procedure dlatch (	constant data	: in bit;
			constant gate	: in bit;
			signal q	: out bit)
    is begin
	if (gate = '1') then
	    q <= data ;
	end if;
    end dlatch;

    procedure dlatch_v (constant data	: in bit_vector;
			constant gate	: in bit;
			signal q	: out bit_vector)
    is begin
        if (gate = '1') then
            q <= data ;
        end if;
    end dlatch_v;


    procedure dlatch (	constant data	: in elbit;
			constant gate	: in elbit;
			signal q	: out elbit)
    is begin
        assert (gate /= 'Z')
            report "On dlatch : Found high-Z ('Z') on enable gate"
            severity error ;

        if (gate /= '0') then
            q <= gate and data ; 
        end if ;
    end dlatch;

    procedure dlatch_v (constant data	: in elbit_vector;
			 constant gate	: in elbit;
			 signal q	: out elbit_vector)
    is begin
        assert (gate /= 'Z')
            report "On dlatch_v : Found high-Z ('Z') on enable gate"
            severity error ;

        if (gate /= '0') then 
            for i in q'range loop
                q(i) <= data(i) and gate ;
            end loop ;
        end if ;
    end dlatch_v;

    procedure dlatchp (	constant data	: in bit;
			constant preset	: in bit;
			constant gate	: in bit;
			signal q	: out bit)
    is begin
	if (preset = '1') then
            q <= '1' ;
        elsif (gate = '1') then
	    q <= data ;
	end if;
    end dlatchp;

    procedure dlatchp_v (constant data	: in bit_vector;
			constant preset	: in bit;
			constant gate	: in bit;
			signal q	: out bit_vector)
    is begin
	if (preset = '1') then
	    q <= (q'range => '1') ;
        elsif (gate = '1') then
            q <= data ;
        end if;
    end dlatchp_v;


    procedure dlatchp (	constant data	: in elbit;
			constant preset	: in elbit;
			constant gate	: in elbit;
			signal q	: out elbit)
    is begin
        assert (gate /= 'Z')
            report "On dlatchp : Found high-Z ('Z') on enable gate"
            severity error ;

	if (preset = '1') then
	    q <= '1' ;
        elsif (gate = '1') then
            q <= data and data ;
        end if;
	if ((preset /= '0' and preset /= '1') or
	    (gate /= '0' and gate /= '1')) then
            q <= 'X' ;
	end if ;
    end dlatchp;

    procedure dlatchp_v (constant data	: in elbit_vector;
		 	 constant preset: in elbit;
			 constant gate	: in elbit;
			 signal q	: out elbit_vector)
    is begin
        assert (gate /= 'Z')
            report "On dlatchp_v : Found high-Z ('Z') on enable gate"
            severity error ;

	if (preset = '1') then
	    q <= (q'range => '1') ;
        elsif (gate = '1') then
            q <= data and data ;
        end if;
	if ((preset /= '0' and preset /= '1') or
	    (gate /= '0' and gate /= '1')) then
            q <= (q'range => 'X') ;
	end if ;
    end dlatchp_v;

    procedure dlatchc (	constant data	: in bit;
			constant clear 	: in bit;
			constant gate	: in bit;
			signal q	: out bit)
    is begin
	if (clear = '1') then
            q <= '0' ;
	elsif (gate = '1') then
	    q <= data ;
	end if;
    end dlatchc;

    procedure dlatchc_v (constant data	: in bit_vector;
			constant clear 	: in bit;
			constant gate	: in bit;
			signal q	: out bit_vector)
    is begin
	if (clear = '1') then
	    q <= (q'range => '0') ;
        elsif (gate = '1') then
            q <= data ;
        end if;
    end dlatchc_v;


    procedure dlatchc (	constant data	: in elbit;
			constant clear 	: in elbit;
			constant gate	: in elbit;
			signal q	: out elbit)
    is begin
        assert (gate /= 'Z')
            report "On dlatchc : Found high-Z ('Z') on enable gate"
            severity error ;

	if (clear = '1') then
	    q <= '0' ;
        elsif (gate = '1') then
            q <= data and data ;
        end if;
	if ((clear /= '0' and clear /= '1') or
	    (gate /= '0' and gate /= '1')) then
            q <= 'X' ;
	end if ;
    end dlatchc;

    procedure dlatchc_v (constant data	: in elbit_vector;
			 constant clear	: in elbit;
			 constant gate	: in elbit;
			 signal q	: out elbit_vector)
    is begin
        assert (gate /= 'Z')
            report "On dlatchc_v : Found high-Z ('Z') on enable gate"
            severity error ;

	if (clear = '1') then
	    q <= (q'range => '0') ;
        elsif (gate = '1') then
            q <= data and data ;
        end if;
	if ((clear /= '0' and clear /= '1') or
	    (gate /= '0' and gate /= '1')) then
            q <= (q'range => 'X') ;
	end if ;

    end dlatchc_v;

   ---
   -- D-latch with both preset and clear.
   --      Synthesis does NOT guarantee preset-dominance as this model suggests !
   --      This depends on the target technology
   ---

    procedure dlatchpc (constant data	: in bit;
			constant preset	: in bit;
			constant clear 	: in bit;
			constant gate	: in bit;
			signal q	: out bit)
    is begin
	if (preset = '1') then
	    q <= '1' ;
        elsif (clear = '1') then
	    q <= '0' ;
        elsif (gate = '1') then
	    q <= data ;
	end if;
    end dlatchpc;

    procedure dlatchpc_v (constant data	: in bit_vector;
			constant preset	: in bit;
			constant clear 	: in bit;
			constant gate	: in bit;
			signal q	: out bit_vector)
    is begin
	if (preset = '1') then
	    q <= (q'range => '1') ;
        elsif (clear = '1') then
	    q <= (q'range => '0') ;
        elsif (gate = '1') then
	    q <= data ;
	end if;
    end dlatchpc_v;


    procedure dlatchpc (constant data	: in elbit;
			constant preset	: in elbit;
			constant clear 	: in elbit;
			constant gate	: in elbit;
			signal q	: out elbit)
    is begin
        assert (gate /= 'Z')
            report "On dlatchpc : Found high-Z ('Z') on enable gate"
            severity error ;

	if (preset = '1') then
	    q <= '1' ;
        elsif (clear = '1') then
	    q <= '0' ;
        elsif (gate = '1') then
	    q <= data ;
	end if;
	if ((clear /= '0' and clear /= '1') or
	    (preset /= '0' and preset /= '1') or
	    (gate /= '0' and gate /= '1')) then
            q <= 'X' ;
	end if ;
    end dlatchpc;

    procedure dlatchpc_v (constant data	: in elbit_vector;
		 	 constant preset: in elbit;
			 constant clear : in elbit;
			 constant gate	: in elbit;
			 signal q	: out elbit_vector)
    is begin
        assert (gate /= 'Z')
            report "On dlatchpc_v : Found high-Z ('Z') on enable gate"
            severity error ;

	if (preset = '1') then
	    q <= (q'range => '1') ;
        elsif (clear = '1') then
	    q <= (q'range => '0') ;
        elsif (gate = '1') then
	    q <= data ;
	end if;
	if ((clear /= '0' and clear /= '1') or
	    (preset /= '0' and preset /= '1') or
	    (gate /= '0' and gate /= '1')) then
            q <= (q'range => 'X') ;
	end if ;
    end dlatchpc_v;


end exemplar;
