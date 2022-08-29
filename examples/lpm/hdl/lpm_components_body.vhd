------------------------------------------------------------------------
-- LPM 220 Component Declaration Package  (Support string type generic)
-- These models are based on LPM version 220 (EIA-IS103 October 1998).
------------------------------------------------------------------------
-- Version Quartus v1.1 (lpm 220)      Date 01/23/01
--
-- 01/23/01: Adding use_eab=on support for lpm_ram_io, lpm_ram_dp and
--           lpm_ram_dq.
------------------------------------------------------------------------
-- Version 2.1.1 (lpm 220) Date 07/27/00
--
-- LPM_LATCH:
--     Changed Data port to be initialized with 0's.
-- LPM_DIVIDE:
--     Added LPM_REMAINDERPOSITIVE parameter.  This is a non-LPM 220
--     standard parameter.  It defaults to TRUE for LPM 220 behaviour.
-- LPM_ADD_SUB:
--     Changed default value of CIN port to HIGH (0) when subtract.
--     This behaviour is different from LPM 220 specification, which
--     probably states the incorrect default value.
------------------------------------------------------------------------
-- Version 2.1 (lpm 220) Date 04/05/00
--
-- LPM_CONSTANT:
--     Changed LPM_WIDTH type from positive to natural.
-- LPM_INV:
--     Changed LPM_WIDTH type from positive to natural.
-- LPM_AND:
--     Changed LPM_WIDTH and LPM_SIZE type from positive to natural.
-- LPM_OR:
--     Changed LPM_WIDTH and LPM_SIZE type from positive to natural.
-- LPM_XOR:
--     Changed LPM_WIDTH and LPM_SIZE type from positive to natural.
-- LPM_BUSTRI:
--     Changed LPM_WIDTH type from positive to natural.
-- LPM_MUX:
--     Changed LPM_WIDTH, LPM_SIZE and LPM_WIDTHS type from positive
--       to natural.
--     Changed LPM_PIPELINE type from integer to natural.
-- LPM_DECODE:
--     Changed LPM_WIDTH and LPM_DECODES type from positive to natural.
--     Changed LPM_PIPELINE type from integer to natural.
-- LPM_CLSHIFT:
--     Changed LPM_WIDTH and LPM_WIDTHDIST type from positive to
--       natural.
-- LPM_ADD_SUB:
--     Changed LPM_WIDTH type from positive to natural.
--     Changed LPM_PIPELINE type from integer to natural.
-- LPM_COMPARE:
--     Changed LPM_WIDTH type from positive to natural.
--     Changed LPM_PIPELINE type from integer to natural.
-- LPM_MULT:
--     Changed LPM_WIDTHA, LPM_WIDTHB and LPM_WIDTHP type from positive
--       to natural.
--     Changed LPM_PIPELINE type from integer to natural.
-- LPM_DIVIDE:
--     Changed LPM_WIDTHN and LPM_WIDTHD from positive to natural.
--     Changed LPM_PIPELINE type from integer to natural.
-- LPM_ABS:
--     Changed LPM_WIDTH type from positive to natural.
-- LPM_COUNTER:
--     Changed LPM_WIDTH type from positive to natural.
-- LPM_LATCH:
--     Changed LPM_WIDTH type from positive to natural.
-- LPM_FF:
--     Changed LPM_WIDTH type from positive to natural.
-- LPM_SHIFTREG:
--     Changed LPM_WIDTH type from positive to natural.
-- LPM_RAM_DQ:
--     Changed LPM_WIDTH and LPM_WIDTHAD from positive to natural.
-- LPM_RAM_DP:
--     Changed LPM_WIDTH and LPM_WIDTHAD from positive to natural.
-- LPM_RAM_IO:
--     Changed LPM_WIDTH and LPM_WIDTHAD from positive to natural.
-- LPM_ROM:
--     Changed LPM_WIDTH and LPM_WIDTHAD from positive to natural.
-- LPM_FIFO:
--     Changed LPM_WIDTH, LPM_WIDTHU and LPM_NUMWORDS from positive to
--       natural.
-- LPM_FIFO_DC:
--     Changed LPM_WIDTH, LPM_WIDTHU and LPM_NUMWORDS from positive to
--       natural.
-- LPM_TTABLE:
--     Changed LPM_WIDTHIN and LPM_WIDTHOUT from positive to natural.
-- LPM_FSM:
--     Changed LPM_WIDTHIN, LPM_WIDTHOUT and LPM_WIDTHS from positive
--       to natural.
-- LPM_INPAD:
--     Changed LPM_WIDTH type from positive to natural.
-- LPM_OUTPAD:
--     Changed LPM_WIDTH type from positive to natural.
-- LPM_BIPAD:
--     Changed LPM_WIDTH type from positive to natural.
------------------------------------------------------------------------
-- Version 1.8 (lpm 220) Date 10/21/99
--
-- Fixed str_to_int() to correctly convert string to integer.
------------------------------------------------------------------------
-- Version 1.7 (lpm 220) Date 07/13/99
--
-- Changed OutEnab and WE in LPM_RAM_IO to default to 'Z'.
------------------------------------------------------------------------
-- Version 1.6 (lpm 220) Date 06/14/99
--
-- Added LPM_HINT and LPM_TYPE to all, if not existed.
-- Changed all clock signals default value to '0'.
-- Changed default values of parameters to comply with the spec.
--     
-- LPM_BUSTRI:
--     Renamed TRDATA to TRIDATA.
-- LPM_MULT:
--     Changed LPM_WIDTHS type from positive to natural, default to 0.
-- LPM_DIVIDE:
--     Discarded LPM_WIDTHD and LPM_WIDTHR.
-- LPM_COUNTER:
--     Discarded EQ.
--     Added CIN and COUT.
--     Changed LPM_MODULUS type from integer to natural.
-- LPM_FF:
--     Added LPM_PVALUE, default to "UNUSED".
--     Changed LPM_FFTYPE default value from "FFTYPE_DFF" to "DFF".
-- LPM_SHIFTREG:
--     Added LPM_PVALUE, default to "UNUSED".
-- LPM_RAM_DQ:
--     Changed LPM_NUMWORDS type from integer to natrual.
--     Changed WE to have no default value.
-- LPM_RAM_DP:
--     Changed LPM_NUMWORDS type from integer to natrual.
--     Changed RDCLKEN default value from '0' to '1'.
-- LPM_RAM_IO:
--     Changed LPM_NUMWORDS type from integer to natrual.
-- LPM_ROM:
--     Changed LPM_NUMWORDS type from integer to natrual.
-- LPM_FIFO:
--     Added LPM_WIDTHU default value '1'.
--     Added ACLR and SCLR default value '0'.
-- LPM_FSM:
--     Added LPM_PVALUE, default to "UNUSED".
--     Added TESTENAB and TESTIN, default to '0'.
--     Added TESTOUT.
------------------------------------------------------------------------
-- Version 1.5 (lpm 220) Date 05/10/99
--
-- Added 0 default value to LPM_NUMWORD parameter in LPM_RAM_DQ,
-- LPM_RAM_IO, and LPM_ROM. Also added 0 default value to LPM_MODULUS.
------------------------------------------------------------------------
-- Version 1.4 (lpm 220) Date 02/05/99
--
-- Removed the constant declarations for string type parameters.
-- Changed LPM_NUMWORDS type from string to positive.
-- Added LPM_DIVIDE, LPM_RAM_DP, LPM_FIFO, and LPM_SCFIFO functions.
------------------------------------------------------------------------
-- Version 1.3   Date 07/30/97
------------------------------------------------------------------------
-- Excluded:
--
-- 1. LPM_POLARITY.
-- 2. SCAN pins are eliminated from storage functions.
------------------------------------------------------------------------
-- Assumptions:
--
--    LPM_SVALUE, LPM_AVALUE, LPM_MODULUS, and LPM_NUMWORDS, LPM_HINT,
--    LPM_STRENGTH, LPM_DIRECTION, and LPM_PVALUE  default value is 
--    string "UNUSED".
------------------------------------------------------------------------


package body LPM_COMPONENTS is

    function str_to_int( s : string ) return integer is
	variable len : integer := s'length;
	variable ivalue : integer := 0;
	variable digit : integer;
	begin
        for i in 1 to len loop
			case s(i) is
				when '0' =>
					digit := 0;
				when '1' =>
					digit := 1;
				when '2' =>
					digit := 2;
				when '3' =>
					digit := 3;
				when '4' =>
					digit := 4;
				when '5' =>
					digit := 5;
				when '6' =>
					digit := 6;
				when '7' =>
					digit := 7;
				when '8' =>
					digit := 8;
				when '9' =>
					digit := 9;
				when others =>
					ASSERT FALSE
					REPORT "Illegal Character "&  s(i) & "in string parameter! "
					SEVERITY ERROR;
			end case;
			ivalue := ivalue * 10 + digit;
		end loop;
		return ivalue;
	end;

end;
