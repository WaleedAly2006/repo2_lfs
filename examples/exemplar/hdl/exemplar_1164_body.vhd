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

package body exemplar_1164 is

 ---
 -- Functions used only in the package body
 ---

    ---
    -- function min  (op_l, op_r : integer) return integer 
    ---
       function min  (op_l, op_r : integer) 
             return integer is
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
       function max  (op_l, op_r : integer) 
             return integer is
       begin
          if op_l > op_r then
              return op_l;
          else
              return op_r;
          end if;
       end max;

    ---
    -- function plus for std_ulogic_vector
    -- Basic addition function of two equally sized vectors.
    -- LSB is right most bit.
    -- Parameter ranges should be size-1 downto 0.
    ---
      function plus (l,r : std_ulogic_vector) return std_ulogic_vector is
         variable carry : std_ulogic ;
         variable result : std_ulogic_vector(l'length-1 downto 0) ; 
         attribute synthesis_return of result:variable is "ADD" ;
      begin
         carry  := '0';
         for i in 0 to l'length-1 loop
            result(i) := l(i) XOR r(i) XOR carry;
            carry     := (l(i) AND r(i)) OR (carry AND (l(i) OR r(i))) ;
         end loop;
         return result ;
      end plus ;

    ---
    -- function plus for std_logic_vector
    -- Basic addition function of two equally sized vectors.
    -- LSB is right most bit.
    -- Parameter ranges should be size-1 downto 0.
    ---
      function plus (l,r : std_logic_vector) return std_logic_vector is
         variable carry : std_logic ;
         variable result : std_logic_vector(l'length-1 downto 0) ; 
         attribute synthesis_return of result:variable is "ADD" ;
      begin
         carry  := '0';
         for i in 0 to l'length-1 loop
            result(i) := l(i) XOR r(i) XOR carry;
            carry     := (l(i) AND r(i)) OR (carry AND (l(i) OR r(i))) ;
         end loop;
         return result ;
      end plus ;

    ---
    -- function minus for std_ulogic_vector
    -- Basic subtraction function of two equally sized vectors.
    -- LSB is right most bit.
    -- Parameter ranges should be size-1 downto 0.
    ---
      function minus (l,r : std_ulogic_vector) return std_ulogic_vector is
         variable carry : std_ulogic ;
         variable result : std_ulogic_vector(l'length-1 downto 0) ; 
         variable op_r : std_ulogic_vector (l'length-1 downto 0) ;
         attribute synthesis_return of result:variable is "SUB" ;
      begin
         carry  := '1';
         op_r := not r ;
         for i in 0 to l'length-1 loop
            result(i) := l(i) XOR op_r(i) XOR carry;
            carry     := (l(i) AND op_r(i)) OR (carry AND (l(i) OR op_r(i))) ;
         end loop;
         return result ;
      end minus ;

    ---
    -- function minus for std_logic_vector
    -- Basic subtraction function of two equally sized vectors.
    -- LSB is right most bit.
    -- Parameter ranges should be size-1 downto 0.
    ---
      function minus (l,r : std_logic_vector) return std_logic_vector is
         variable carry : std_logic ;
         variable result : std_logic_vector(l'length-1 downto 0) ; 
         variable op_r : std_logic_vector (l'length-1 downto 0) ;
         attribute synthesis_return of result:variable is "SUB" ;
      begin
         carry  := '1';
         op_r := not r ;
         for i in 0 to l'length-1 loop
            result(i) := l(i) XOR op_r(i) XOR carry;
            carry     := (l(i) AND op_r(i)) OR (carry AND (l(i) OR op_r(i))) ;
         end loop;
         return result ;
      end minus ;


  ---
  -- Definition of exported functions
  ---

    ---
    --  function bool2elb   (l: boolean)  return std_ulogic;
    ---
       function bool2elb   (l: boolean)   return std_ulogic is
       begin
           if l then
             return '1';
           else
             return '0';
           end if;
        end bool2elb;

    ---
    --     function elb2bool   (l: std_ulogic)  return boolean;
    ---
        function elb2bool   (l: std_ulogic) return boolean is
        begin
           if (l = '1' or l = 'H') then
              return true;
           else
              return false;
           end if;
        end elb2bool;

    --- 
    --     function elb2int   (l: std_ulogic)   return natural;
    ---
       function elb2int   (l: std_ulogic) return natural is
       begin
           if (l = '1' or l = 'H') then
              return 1;
           else
              return 0;
           end if;
        end elb2int;

    ---
    --    function sl (l: std_ulogic_vector; r: integer)     return std_ulogic_vector;
    ---
        function sl(l: std_ulogic_vector; r: integer) return std_ulogic_vector is
           alias la : std_ulogic_vector (l'length-1 downto 0) is l ;
           constant zero : std_ulogic_vector (l'length-1 downto 0) := (others => '0') ;
           variable result : std_ulogic_vector (l'length-1 downto 0) ;
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
    --    function sl       (l: std_logic_vector; r: integer)     return std_logic_vector;
    ---
        function sl       (l: std_logic_vector; r: integer)     return std_logic_vector is
	begin
           return std_logic_vector(sl(std_ulogic_vector(l),r)) ;
        end sl ;

    ---
    --    function sl2       (l: std_ulogic_vector; r: integer)     return std_ulogic_vector;
    ---
        function sl2       (l: std_ulogic_vector; r: integer)     
	       return std_ulogic_vector is
           alias la : std_ulogic_vector (l'length-1 downto 0) is l ;
           constant zero : std_ulogic_vector (l'length-1 downto 0) := (others => '0') ;
           variable result : std_ulogic_vector (l'length-1 downto 0) ;
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
        end sl2 ;

    ---
    --    function sl2       (l: std_logic_vector; r: integer)     return std_logic_vector;
    ---
        function sl2       (l: std_logic_vector; r: integer)     return std_logic_vector is
	begin
           return std_logic_vector(sl2(std_ulogic_vector(l),r)) ;
        end sl2 ;

    ---
    --    function sr       (l: std_ulogic_vector; r: integer)     return std_ulogic_vector;
    ---
        function sr       (l: std_ulogic_vector; r: integer)     
	       return std_ulogic_vector is
           variable result : std_ulogic_vector (l'length-1 downto 0) ;
           attribute synthesis_return of result:variable is "SRL" ;
        begin
            -- Shift right and fill with zero
            -- This is exactly sl with negative value.
           result := sl(l,-r) ;
           return result ; 
        end sr ;

    ---
    --    function sr       (l: std_logic_vector; r: integer)     return std_logic_vector;
    ---
        function sr       (l: std_logic_vector; r: integer)     return std_logic_vector is
           variable result : std_logic_vector (l'length-1 downto 0) ;
           attribute synthesis_return of result:variable is "SRL" ;
        begin
            -- Shift right and fill with zero
            -- This is exactly sl with negative value.
           result := sl (l,-r) ;
           return result ;
        end sr ;

    ---
    --    function sr2       (l: std_ulogic_vector; r: integer)     return std_ulogic_vector;
    ---
        function sr2       (l: std_ulogic_vector; r: integer)     
	       return std_ulogic_vector is
           alias la : std_ulogic_vector (l'length-1 downto 0) is l ;
           variable sign : std_ulogic_vector (l'length-1 downto 0) ;
           variable result : std_ulogic_vector (l'length-1 downto 0) ;
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
    --    function sr2       (l: std_logic_vector; r: integer)     return std_logic_vector;
    ---
        function sr2       (l: std_logic_vector; r: integer)     return std_logic_vector is
           alias la : std_logic_vector (l'length-1 downto 0) is l ;
           variable sign : std_logic_vector (l'length-1 downto 0) ;
           variable result : std_logic_vector (l'length-1 downto 0) ;
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
    -- function evec2int (l: std_ulogic_vector)                      return natural;
    -- Translate unsigned vector into integer representation
    ---
       function evec2int (l: std_ulogic_vector)                      
             return natural is
          variable result: natural := 0;
           attribute synthesis_return of result:variable is "FEED_THROUGH" ;
       begin
          for t1 in l'range loop
             result := result * 2;
             if (l(t1) = '1' or l(t1) = 'H') then
                result := result + 1;
             end if;
          end loop;
          return result;
       end evec2int;

    ---
    --     function evec2int (l: std_logic_vector)                      return natural;
    ---
       function evec2int (l: std_logic_vector)  return natural is
       begin
          return evec2int (std_ulogic_vector(l)) ;
       end evec2int;

    ---
    -- function int2evec (op: integer; size: integer := 32) return std_ulogic_vector;
    -- Translate an integer to a signed vector representation
    ---
        -- Integer to signed or unsigned vector
       function int2evec (l: integer; size: integer := 32) return std_ulogic_vector is
          variable result: std_ulogic_vector(size-1 downto 0);
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
    -- function int2evec (op: integer; size: integer := 32) return std_logic_vector;
    ---
       function int2evec (l: integer; size: integer := 32)  return std_logic_vector is
       begin
          return std_logic_vector(std_ulogic_vector'(int2evec(l,size))) ;
       end int2evec;

    ---
    -- function add (op_l, op_r: std_ulogic_vector) return std_ulogic_vector;
    -- Addition of two unsigned vectors ; include carry bit on MSB (==left) bit
    ---
      function add (op_l, op_r: std_ulogic_vector)
            return std_ulogic_vector is
         constant size  : integer := max(op_l'length, op_r'length)+1;
         variable oper_l: std_ulogic_vector(size-1 downto 0);
         variable oper_r: std_ulogic_vector(size-1 downto 0);
         variable result: std_ulogic_vector(size-1 downto 0);
         attribute synthesis_return of result:variable is "ADD" ;
      begin
         oper_l := extend(op_l, size);
         oper_r := extend(op_r, size);
         result := plus (oper_l, oper_r) ;
         return result;
      end add;
         
    ---
    -- function add2 (op_l, op_r: std_ulogic_vector) return std_ulogic_vector;
    -- Addition of two signed vectors ; include carry bit on MSB (==left) bit
    ---
      function add2 (op_l, op_r: std_ulogic_vector)
            return std_ulogic_vector is
         constant size  : integer := max(op_l'length, op_r'length)+1;
         variable oper_l: std_ulogic_vector(size-1 downto 0);
         variable oper_r: std_ulogic_vector(size-1 downto 0);
         variable result: std_ulogic_vector(size-1 downto 0);
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
    -- function add (op_l, op_r: std_logic_vector) return std_logic_vector;
    ---
      function add (op_l, op_r: std_logic_vector) return std_logic_vector is
      begin
         return std_logic_vector(add(std_ulogic_vector(op_l),
                                     std_ulogic_vector(op_r))) ;
      end add;
         
    ---
    -- function add2 (op_l, op_r: std_logic_vector) return std_logic_vector;
    ---
      function add2 (op_l, op_r: std_logic_vector) return std_logic_vector is
      begin
         return std_logic_vector(add2(std_ulogic_vector(op_l),
                                      std_ulogic_vector(op_r))) ;
      end add2;
         
    ---
    -- function sub (op_l, op_r: std_ulogic_vector) return std_ulogic_vector;
    -- Subtract two unsigned vectors ; include carry bit on MSB (==left) side
    ---
      function sub (op_l, op_r: std_ulogic_vector)
            return std_ulogic_vector is
         constant size  : integer := max(op_l'length, op_r'length)+1;
         variable oper_l: std_ulogic_vector(size-1 downto 0);
         variable oper_r: std_ulogic_vector(size-1 downto 0);
         variable result: std_ulogic_vector(size-1 downto 0);
         attribute synthesis_return of result:variable is "SUB" ;
      begin
         oper_l := extend(op_l, size);
         oper_r := extend(op_r, size);
         result := minus (oper_l, oper_r) ; 
         return result;
      end sub;

    ---
    -- function sub2 (op_l, op_r: std_ulogic_vector) return std_ulogic_vector;
    -- Subtract two signed vectors ; include carry bit on MSB side
    ---
      function sub2 (op_l, op_r: std_ulogic_vector)
            return std_ulogic_vector is
         constant size  : integer := max(op_l'length, op_r'length)+1;
         variable oper_l: std_ulogic_vector(size-1 downto 0);
         variable oper_r: std_ulogic_vector(size-1 downto 0);
         variable result: std_ulogic_vector(size-1 downto 0);
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
    -- function sub (op_l, op_r: std_logic_vector) return std_logic_vector;
    ---
      function sub (op_l, op_r: std_logic_vector)  return std_logic_vector is
      begin
         return std_logic_vector(sub(std_ulogic_vector(op_l),std_ulogic_vector(op_r))) ;
      end sub;
        
    ---
    -- function sub2 (op_l, op_r: std_logic_vector) return std_logic_vector;
    ---
      function sub2 (op_l, op_r: std_logic_vector)  return std_logic_vector is
      begin
         return std_logic_vector(sub2(std_ulogic_vector(op_l),std_ulogic_vector(op_r))) ;
      end sub2;
        
    ---
    --   function mult (op_l, op_r: std_ulogic_vector)     return std_ulogic_vector is
    -- Multiplication of two unsigned vectors
    -- Left most bit in op_l and op_r is assumed to be MSB
    ---
  
    function mult (op_l, op_r: std_ulogic_vector)          return std_ulogic_vector is
         alias l : std_ulogic_vector (op_l'length-1 downto 0) is op_l ;
         variable result,temp : std_ulogic_vector (op_l'length+op_r'length-1 downto 0) ;
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
    --   function mult2    (op_l, op_r: std_ulogic_vector)          return std_ulogic_vector is
    -- Multiplication of two signed vectors
    -- Left most bit in op_l and op_r is assumed to be MSB (sign bit)
    ---

    function mult2    (op_l, op_r: std_ulogic_vector)          return std_ulogic_vector is
        variable result,temp_r : std_ulogic_vector (op_l'length+op_r'length-1 downto 0) ;
        variable temp_l : std_ulogic_vector (op_l'length-1 downto 0) ;
        variable neg_fl : std_ulogic ;
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

    function mult     (op_l, op_r: std_logic_vector) return std_logic_vector is
    begin
        return std_logic_vector(mult(std_ulogic_vector(op_l),
                                     std_ulogic_vector(op_r))) ; 
    end mult ;

    function mult2    (op_l, op_r: std_logic_vector) return std_logic_vector is
    begin
        return std_logic_vector(mult2(std_ulogic_vector(op_l),
                                      std_ulogic_vector(op_r))) ; 
    end mult2 ;

    ---
    -- function extend(op_l: std_ulogic; op_r: integer) return std_ulogic_vector
    ---
--
--    function extend(op_l: std_ulogic; op_r: integer) return std_ulogic_vector is
--        variable vec : std_ulogic_vector (0 downto 0) ;
--    begin
--        vec := (others=>op_l) ; 
--        return extend(vec,op_r) ;
--    end extend ;

    ---
    -- function extend(op_l: std_ulogic; op_r: integer) return std_logic_vector
    ---
--    
--    function extend(op_l: std_ulogic; op_r: integer) return std_logic_vector is
--        variable vec : std_logic_vector (0 downto 0) ;
--    begin
--        vec := (others=>op_l) ; 
--        return extend(vec,op_r) ;
--    end extend ;

    ---
    --  function extend   (l: std_ulogic_vector  r: integer)   return std_ulogic_vector;
    -- Basic zero-extend / truncate function for vectors.
    -- Independent of index order of op_l, this function performs left
    -- hand zero extention on op_l to size op_r. 
    ---
       function extend   (op_l: std_ulogic_vector; op_r: integer)   
             return std_ulogic_vector is
          variable result : std_ulogic_vector(op_r-1 downto 0);
          alias invec : std_ulogic_vector (op_l'length-1 downto 0) is op_l ;
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
    --  function extend   (l: std_logic_vector  r: integer)   return std_logic_vector;
    ---
       function extend   (op_l: std_logic_vector; op_r: integer)   
             return std_logic_vector is
       begin
          return std_logic_vector(extend(std_ulogic_vector(op_l),op_r)) ;
       end extend;

    ---
    -- function extend2(op_l: std_ulogic; op_r: integer) return std_ulogic_vector
    ---
--
--    function extend2(op_l: std_ulogic; op_r: integer) return std_ulogic_vector is
--        variable vec : std_ulogic_vector (0 downto 0) ;
--    begin
--        vec := (others=>op_l) ; 
--        return extend2(vec,op_r) ;
--    end extend2 ;

    ---
    -- function extend2(op_l: std_ulogic; op_r: integer) return std_logic_vector
    ---
--    
--    function extend2(op_l: std_ulogic; op_r: integer) return std_logic_vector is
--        variable vec : std_logic_vector (0 downto 0) ;
--    begin
--        vec := (others=>op_l) ; 
--        return extend2(vec,op_r) ;
--    end extend2 ;

    ---
    -- function extend2 (l: std_ulogic_vector  r: integer) return std_ulogic_vector
    -- Basic sign-extention / truncation function. 
    -- Independant of index order of op_l, left bit (sign) extention is done 
    ---
       function extend2   (op_l: std_ulogic_vector;  op_r: integer)   
             return std_ulogic_vector is
          variable result : std_ulogic_vector(op_r-1 downto 0);
          alias invec : std_ulogic_vector (op_l'length-1 downto 0) is op_l ;
          constant bound : natural := min(op_l'length,op_r)-1 ;
          attribute is_signed of op_l:constant is true ;
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
    -- function extend2(l: std_logic_vector  r: integer) return std_logic_vector
    ---
       function extend2   (op_l: std_logic_vector;  op_r: integer)   
             return std_logic_vector is
       begin
          return std_logic_vector(extend2(std_ulogic_vector(op_l),op_r)) ;
       end extend2;

    ---
    -- function comp2 ( op: std_ulogic_vector) return std_ulogic_vector;
    ---
       function comp2 ( op: std_ulogic_vector) return std_ulogic_vector is
          variable result : std_ulogic_vector (op'range) ;
          attribute synthesis_return of result:variable is "UMINUS" ;
       begin
             result := (not op) + "1" ;
             return result ;
       end comp2 ;

    ---
    -- function comp2 ( op: std_logic_vector) return std_logic_vector;
    ---
       function comp2 ( op: std_logic_vector) return std_logic_vector is
          variable result : std_logic_vector (op'range) ;
          attribute synthesis_return of result:variable is "UMINUS" ;
       begin
             result := (not op) + "1" ;
             return result ;
       end comp2 ;


    ---
    -- function "+" (op_l, op_r: std_ulogic_vector) return std_ulogic_vector;
    ---
      function "+" (op_l, op_r: std_ulogic_vector) return std_ulogic_vector is
         constant size  : integer := max(op_l'length, op_r'length);
         variable oper_l: std_ulogic_vector(size-1 downto 0);
         variable oper_r: std_ulogic_vector(size-1 downto 0);
         variable result: std_ulogic_vector(size-1 downto 0);
         attribute synthesis_return of result:variable is "ADD" ;
      begin
         -- unsigned addition
         oper_l := extend (op_l, size) ;
         oper_r := extend (op_r, size) ;
	 result := plus (oper_l, oper_r) ;
	 return result ;
      end "+";
    
    ---
    -- function "+" (op_l, op_r: std_logic_vector) return std_ulogic_vector;
    ---
      function "+" (op_l, op_r: std_logic_vector)
            return std_logic_vector is
         constant size  : integer := max(op_l'length, op_r'length);
         variable oper_l: std_logic_vector(size-1 downto 0);
         variable oper_r: std_logic_vector(size-1 downto 0);
         variable result: std_logic_vector(size-1 downto 0);
         attribute synthesis_return of result:variable is "ADD" ;
      begin
         -- unsigned addition
         oper_l := extend (op_l, size) ;
         oper_r := extend (op_r, size) ;
	 result := plus (oper_l, oper_r) ;
	 return result ;
      end "+";
    
    ---
    -- function "-" (op_l, op_r: std_ulogic_vector) return std_ulogic_vector;
    ---
      function "-" (op_l, op_r: std_ulogic_vector) return std_ulogic_vector is
         constant size  : integer := max(op_l'length, op_r'length);
         variable oper_l: std_ulogic_vector(size-1 downto 0);
         variable oper_r: std_ulogic_vector(size-1 downto 0);
         variable result: std_ulogic_vector(size-1 downto 0);
         attribute synthesis_return of result:variable is "SUB" ;
      begin
         -- unsigned subtraction
         oper_l := extend (op_l, size) ;
         oper_r := extend (op_r, size) ;
	 result := minus (oper_l, oper_r) ;
	 return result ;
      end "-";
    
    ---
    -- function "-" (op_l, op_r: std_logic_vector) return std_logic_vector;
    ---
      function "-" (op_l, op_r: std_logic_vector) return std_logic_vector is
         constant size  : integer := max(op_l'length, op_r'length);
         variable oper_l: std_logic_vector(size-1 downto 0);
         variable oper_r: std_logic_vector(size-1 downto 0);
         variable result: std_logic_vector(size-1 downto 0);
         attribute synthesis_return of result:variable is "SUB" ;
      begin
         -- unsigned subtraction
         oper_l := extend (op_l, size) ;
         oper_r := extend (op_r, size) ;
	 result := minus (oper_l, oper_r) ;
	 return result ;
      end "-";

   ---
   -- function "*"    (op_l, op_r: std_ulogic_vector)  return std_ulogic_vector;
   -- Unsigned multiplication of std_ulogic_vector
   ---
    function "*"    (op_l, op_r: std_ulogic_vector)  return std_ulogic_vector is
    begin
       return mult (op_l, op_r) ;
    end "*" ;
   
   ---
   -- function "*"    (op_l, op_r: std_logic_vector)   return std_logic_vector;
   -- Unsigned multiplication of std_logic_vector
   ---
    function "*"    (op_l, op_r: std_logic_vector)   return std_logic_vector is
    begin
       return std_logic_vector(mult(std_ulogic_vector(op_l),
                                    std_ulogic_vector(op_r))) ; 
    end "*" ;

   ---
   -- function "abs"  (op: std_ulogic_vector) return std_ulogic_vector;
   -- Take the absolute value of a signed vector 
   --
    function "abs"    (op: std_ulogic_vector)  return std_ulogic_vector is 
          variable result : std_ulogic_vector(op'range) ;
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
   -- function "abs"  (op: std_logic_vector) return std_logic_vector;
   -- Take the absolute value of a signed vector 
   --
    function "abs"    (op: std_logic_vector)   return std_logic_vector is
          variable result : std_logic_vector(op'range) ;
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

    procedure pullup  (signal data: inout std_ulogic) is 
       attribute synthesis_return of data:signal is "PULL_UP" ;
    begin
       data <= 'H' ;
    end pullup ;

    procedure pulldn  (signal data: inout std_ulogic) is
       attribute synthesis_return of data:signal is "PULL_DN" ;
    begin
       data <= 'L' ;
    end pulldn ;

    procedure trstmem (signal data: inout std_ulogic) is
       attribute synthesis_return of data:signal is "TRST_MEM" ;
    begin
       if (data = 'Z') then
	  data <= data'last_value ;
       end if; 
    end trstmem ; 

 
   --- 
   -- edge triggered D - flip-flops
   ---
          
    procedure dff (     constant data     : in std_ulogic;
                        signal clk      : in std_ulogic;
                        signal q        : out std_ulogic)
    is begin
        if (clk'event and clk'last_value = '0' and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z'
        end if ;
        if (clk /= '0' and clk /= '1') then 
            q <= 'X' ;            
        end if ;
    end dff;

    procedure dff_v (   constant data     : in std_logic_vector;
                        signal clk      : in std_logic;
                        signal q        : out std_logic_vector)
    is begin
        if (clk'event and clk'last_value = '0' and clk = '1') then  
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
        if (clk /= '0' and clk /= '1') then 
            q <= (q'range => 'X') ;
        end if ;
    end dff_v;


    procedure dff_v (   constant data     : in std_ulogic_vector;
                        signal clk      : in std_ulogic;
                        signal q        : out std_ulogic_vector)
    is begin
        if (clk'event and clk'last_value = '0' and clk = '1') then  
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
        if (clk /= '0' and clk /= '1') then 
            q <= (q'range => 'X') ;
        end if ;
    end dff_v;
 
   --- 
   -- edge triggered D - flip-flop with preset (active high)
   ---

    procedure dffp (	constant data	: in std_ulogic;
			constant preset	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic)
    is begin
	if (preset = '1') then
	    q <= '1' ;
        elsif (clk'event and clk'last_value = '0' and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if (preset/='1' and clk/='0' and clk/='1') then 
            q <= 'X' ;
        end if ;
    end dffp;

    procedure dffp_v (	constant data	: in std_logic_vector;
			constant preset	: in std_logic;
			signal clk	: in std_logic;
			signal q	: out std_logic_vector)
    is begin
	if (preset = '1') then
	    q <= (q'range => '1') ;
        elsif (clk'event and clk'last_value = '0' and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if (preset/='1' and clk/='0' and clk/='1') then
	    q <= (q'range => 'X') ;
        end if ;
    end dffp_v;

    procedure dffp_v (	constant data	: in std_ulogic_vector;
			constant preset	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic_vector)
    is begin
	if (preset = '1') then
	    q <= (q'range => '1') ;
        elsif (clk'event and clk'last_value = '0' and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if (preset/='1' and clk/='0' and clk/='1') then
	    q <= (q'range => 'X') ;
        end if ;
    end dffp_v;

   --- 
   -- edge triggered D - flip-flop with clear (active high)
   ---


    procedure dffc (	constant data	: in std_ulogic;
			constant clear 	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic)
    is begin
	if (clear = '1') then
	    q <= '0' ;
        elsif (clk'event and clk'last_value = '0' and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if (clear/='1' and clk/='0' and clk /= '1') then 
            q <= 'X' ; 
        end if ;
    end dffc;

    procedure dffc_v (	constant data	: in std_logic_vector;
			constant clear 	: in std_logic;
			signal clk	: in std_logic;
			signal q	: out std_logic_vector)
    is begin
	if (clear = '1') then
	    q <= (q'range => '0') ;
        elsif (clk'event and clk'last_value = '0' and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if (clear/='1' and clk/='0' and clk/='1') then
	    q <= (q'range => 'X') ;
        end if ;
    end dffc_v;

    procedure dffc_v (	constant data	: in std_ulogic_vector;
			constant clear 	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic_vector)
    is begin
	if (clear = '1') then
	    q <= (q'range => '0') ;
        elsif (clk'event and clk'last_value = '0' and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if (clear/='1' and clk/='0' and clk/='1') then
	    q <= (q'range => 'X') ;
        end if ;
    end dffc_v;

   --- 
   -- edge triggered D - flip-flop with preset and clear 
   --      Synthesis does NOT guarantee preset-dominance as this model suggests ! 
   --      This depends on the target technology
   ---

    procedure dffpc (	constant data	: in std_ulogic;
			constant preset	: in std_ulogic;
			constant clear 	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic)
    is begin
	if (preset = '1') then
	    q <= '1' ;
	elsif (clear = '1') then
	    q <= '0' ;
        elsif (clk'event and clk'last_value = '0' and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if ((clear/='1' or preset/='1') and clk/='0' and clk/='1') then 
            q <= 'X' ;
        end if ;
    end dffpc;

    procedure dffpce (	constant data	: in std_ulogic;
			constant preset	: in std_ulogic;
			constant clear 	: in std_ulogic;
			constant enable	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic)
    is begin
	if (preset = '1') then
	    q <= '1' ;
	elsif (clear = '1') then
	    q <= '0' ;
        elsif (clk'event and clk'last_value = '0' and clk = '1') then
            if (enable = '1') then
                q <= data and data ;    -- takes care of q<='X' if data='Z' 
            end if ;
        end if ;
	if ((clear/='1' or preset/='1') and clk/='0' and clk/='1') then 
            q <= 'X' ;
        end if ;
    end dffpce;

    procedure dffpc_v (	constant data	: in std_logic_vector;
			constant preset	: in std_logic;
			constant clear 	: in std_logic;
			signal clk	: in std_logic;
			signal q	: out std_logic_vector)
    is begin
	if (preset = '1') then
	    q <= (q'range => '1') ;
	elsif (clear = '1') then
	    q <= (q'range => '0') ;
        elsif (clk'event and clk'last_value = '0' and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if ((clear/='1' or preset/='1') and clk/='0' and clk/='1') then 
	    q <= (q'range => 'X') ;
        end if ;
    end dffpc_v;

    procedure dffpc_v (	constant data	: in std_ulogic_vector;
			constant preset	: in std_ulogic;
			constant clear 	: in std_ulogic;
			signal clk	: in std_ulogic;
			signal q	: out std_ulogic_vector)
    is begin
	if (preset = '1') then
	    q <= (q'range => '1') ;
	elsif (clear = '1') then
	    q <= (q'range => '0') ;
        elsif (clk'event and clk'last_value = '0' and clk = '1') then
            q <= data and data ;    -- takes care of q<='X' if data='Z' 
        end if ;
	if ((clear/='1' or preset/='1') and clk/='0' and clk/='1') then 
	    q <= (q'range => 'X') ;
        end if ;
    end dffpc_v;

 --
 --  Regular level sensitive D-latch
 --

    procedure dlatch (	constant data	: in std_ulogic;
			constant gate	: in std_ulogic;
			signal q	: out std_ulogic)
    is begin
        assert (gate /= 'Z')
            report "On dlatch : Found high-Z ('Z') on enable gate"
            severity error ;

        if (gate /= '0') then
            q <= gate and data ; -- Makes sure q<='X' in case gate or data is not valid '0' or '1'
        end if ;
    end dlatch;

    procedure dlatch_v (constant data	: in std_logic_vector;
			constant gate	: in std_logic;
			signal q	: out std_logic_vector)
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


    procedure dlatch_v (constant data	: in std_ulogic_vector;
			constant gate	: in std_ulogic;
			signal q	: out std_ulogic_vector)
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

 -- 
 -- Dlatch with preset 
 --

    procedure dlatchp (	constant data	: in std_ulogic;
			constant preset	: in std_ulogic;
			constant gate	: in std_ulogic;
			signal q	: out std_ulogic)
    is begin
        assert (gate /= 'Z')
            report "On dlatchp : Found high-Z ('Z') on enable gate"
            severity error ;

	if (preset = '1') then
	    q <= '1' ;
        elsif (gate = '1') then
            q <= data and data ;
        end if;
	if (preset/='1' and gate/='0' and gate/='1') then
            q <= 'X' ;
	end if ;
    end dlatchp;

    procedure dlatchp_v (constant data	: in std_logic_vector;
			constant preset	: in std_logic;
			constant gate	: in std_logic;
			signal q	: out std_logic_vector)
    is begin
        assert (gate /= 'Z')
            report "On dlatchp_v : Found high-Z ('Z') on enable gate"
            severity error ;

	if (preset = '1') then
	    q <= (q'range => '1') ;
        elsif (gate = '1') then
            q <= data and data ;
        end if;
	if (preset/='1' and gate/='0' and gate/='1') then
            q <= (q'range => 'X') ;
	end if ;
    end dlatchp_v;


    procedure dlatchp_v (constant data	: in std_ulogic_vector;
		 	 constant preset: in std_ulogic;
			 constant gate	: in std_ulogic;
			 signal q	: out std_ulogic_vector)
    is begin
        assert (gate /= 'Z')
            report "On dlatchp_v : Found high-Z ('Z') on enable gate"
            severity error ;

	if (preset = '1') then
	    q <= (q'range => '1') ;
        elsif (gate = '1') then
            q <= data and data ;
        end if;
	if (preset/='1' and gate/='0' and gate/='1') then
            q <= (q'range => 'X') ;
	end if ;
    end dlatchp_v;

 --
 -- D latch with clear 
 --

    procedure dlatchc (	constant data	: in std_ulogic;
			constant clear 	: in std_ulogic;
			constant gate	: in std_ulogic;
			signal q	: out std_ulogic)
    is begin
        assert (gate /= 'Z')
            report "On dlatchc : Found high-Z ('Z') on enable gate"
            severity error ;

	if (clear = '1') then
	    q <= '0' ;
        elsif (gate = '1') then
            q <= data and data ;
        end if;
	if (clear/='1' and gate/='0' and gate/='1') then
            q <= 'X' ;
	end if ;
    end dlatchc;

    procedure dlatchc_v (constant data	: in std_logic_vector;
			constant clear 	: in std_logic;
			constant gate	: in std_logic;
			signal q	: out std_logic_vector)
    is begin
        assert (gate /= 'Z')
            report "On dlatchc_v : Found high-Z ('Z') on enable gate"
            severity error ;

	if (clear = '1') then
	    q <= (q'range => '0') ;
        elsif (gate = '1') then
            q <= data and data ;
        end if;
	if (clear/='1' and gate/='0' and gate/='1') then
            q <= (q'range => 'X') ;
	end if ;

    end dlatchc_v;


    procedure dlatchc_v (constant data	: in std_ulogic_vector;
			 constant clear : in std_ulogic;
			 constant gate	: in std_ulogic;
			 signal q	: out std_ulogic_vector)
    is begin
        assert (gate /= 'Z')
            report "On dlatchc_v : Found high-Z ('Z') on enable gate"
            severity error ;

	if (clear = '1') then
	    q <= (q'range => '0') ;
        elsif (gate = '1') then
            q <= data and data ;
        end if;
	if (clear/='1' and gate/='0' and gate/='1') then
            q <= (q'range => 'X') ;
	end if ;

    end dlatchc_v;

 -- 
 -- D latch with clear and preset
 --      Synthesis does NOT guarantee preset-dominance as this model suggests ! 
 --      This depends on the target technology
 --

    procedure dlatchpc (constant data	: in std_ulogic;
			constant preset	: in std_ulogic;
			constant clear 	: in std_ulogic;
			constant gate	: in std_ulogic;
			signal q	: out std_ulogic)
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
	if ((preset/='1' or clear/='1') and gate/='0' and gate/='1') then
            q <= 'X' ;
	end if ;
    end dlatchpc;

    procedure dlatchpc_v (constant data	: in std_logic_vector;
			constant preset	: in std_logic;
			constant clear 	: in std_logic;
			constant gate	: in std_logic;
			signal q	: out std_logic_vector)
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
	if ((preset/='1' or clear/='1') and gate/='0' and gate/='1') then
            q <= (q'range => 'X') ;
	end if ;
    end dlatchpc_v;


    procedure dlatchpc_v (constant data	: in std_ulogic_vector;
		 	 constant preset: in std_ulogic;
			 constant clear : in std_ulogic;
			 constant gate	: in std_ulogic;
			 signal q	: out std_ulogic_vector)
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
	if ((preset/='1' or clear/='1') and gate/='0' and gate/='1') then
            q <= (q'range => 'X') ;
	end if ;
    end dlatchpc_v;

end exemplar_1164;
