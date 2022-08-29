-- VHDL Entity lpm.lpm_fifo.symbol
--
-- Created:
--          by - user.group (host.domain)
--          at - 09:12:44 02/18/03
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2003.1
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
LIBRARY lpm;
USE lpm.lpm_components.all;

ENTITY lpm_fifo IS
   GENERIC( 
      lpm_WIDTH     : natural;
      lpm_WIDTHU    : natural := 1;
      lpm_NUMWORDS  : natural;
      lpm_SHOWAHEAD : string  := "OFF";
      lpm_TYPE      : string  := "LPM_FIFO";
      lpm_HINT      : string  := "UNUSED"
   );
   PORT( 
      aclr  : IN     std_logic  := '0';
      clock : IN     std_logic;
      data  : IN     std_logic_vector (lpm_WIDTH-1 DOWNTO 0);
      rdreq : IN     std_logic;
      sclr  : IN     std_logic  := '0';
      wrreq : IN     std_logic;
      empty : OUT    std_logic;
      full  : OUT    std_logic;
      q     : OUT    std_logic_vector (lpm_WIDTH-1 DOWNTO 0);
      usedw : OUT    std_logic_vector (lpm_WIDTHU-1 DOWNTO 0)
   );

-- Declarations

END lpm_fifo ;


--------------------------------------------------------------------------
--   This VHDL file was developed by Altera Corporation.  It may be
-- freely copied and/or distributed at no cost.  Any persons using this
-- file for any purpose do so at their own risk, and are responsible for
-- the results of such use.  Altera Corporation does not guarantee that
-- this file is complete, correct, or fit for any particular purpose.
-- NO WARRANTY OF ANY KIND IS EXPRESSED OR IMPLIED.  This notice must
-- accompany any copy of this file.
--
--------------------------------------------------------------------------
-- LPM Synthesizable Models (Support string type generic)
-- These models are based on LPM version 220 (EIA-IS103 October 1998).
-------------------------------------------------------------------------
-- Version Quartus v1.1 (lpm 220)      Date 02/01/01
--------------------------------------------------------------------------
architecture lpm_syn of lpm_fifo is

type lpm_memory is array (lpm_numwords-1 downto 0) of std_logic_vector(lpm_width-1 downto 0);

signal tmp_q : std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '0');
signal read_id, write_id, count_id : integer := 0;
signal empty_flag : std_logic := '1';
signal full_flag : std_logic := '0';
constant ZEROS : std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '0');

begin

	process (clock, aclr)
	variable mem_data : lpm_memory := (OTHERS => ZEROS);

	begin
        if (LPM_SHOWAHEAD /= "ON" and LPM_SHOWAHEAD /= "OFF") then
            ASSERT FALSE
            REPORT "Illegal LPM_SHOWAHEAD property value for LPM_FIFO!"
            SEVERITY ERROR;
        end if;

		if (aclr = '1') then
			tmp_q <= ZEROS;
			full_flag <= '0';
			empty_flag <= '1';
			read_id <= 0;
			write_id <= 0;
			count_id <= 0;
			if (lpm_showahead = "ON") then
				tmp_q <= mem_data(0);
			end if;
		elsif (clock'event and clock = '1') then
			if (sclr = '1') then
				tmp_q <= mem_data(read_id);
				full_flag <= '0';
				empty_flag <= '1';
				read_id <= 0;
				write_id <= 0;
				count_id <= 0;
				if (lpm_showahead = "ON") then
					tmp_q <= mem_data(0);
				end if;
			else
				----- IF BOTH READ AND WRITE -----
				if (wrreq = '1' and full_flag = '0') and
					(rdreq = '1' and empty_flag = '0') then

					mem_data(write_id) := data;
					if (write_id >= lpm_numwords-1) then
						write_id <= 0;
					else
						write_id <= write_id + 1;
					end if;

					tmp_q <= mem_data(read_id);
					if (read_id >= lpm_numwords-1) then
						read_id <= 0;
						if (lpm_showahead = "ON") then
							tmp_q <= mem_data(0);
						end if;
					else
						read_id <= read_id + 1;
						if (lpm_showahead = "ON") then
							tmp_q <= mem_data(read_id+1);
						end if;
					end if;

				----- IF WRITE (ONLY) -----
				elsif (wrreq = '1' and full_flag = '0') then

					mem_data(write_id) := data;
					if (lpm_showahead = "ON") then
						tmp_q <= mem_data(read_id);
					end if;
					count_id <= count_id + 1;
					empty_flag <= '0';
					if (count_id >= lpm_numwords-1) then
						full_flag <= '1';
						count_id <= lpm_numwords;
					end if;
					if (write_id >= lpm_numwords-1) then
						write_id <= 0;
					else
						write_id <= write_id + 1;
					end if;

				----- IF READ (ONLY) -----
				elsif (rdreq = '1' and empty_flag = '0') then

					tmp_q <= mem_data(read_id);
					count_id <= count_id - 1;
					full_flag <= '0';
					if (count_id <= 1) then
						empty_flag <= '1';
						count_id <= 0;
					end if;
					if (read_id >= lpm_numwords-1) then
						read_id <= 0;
						if (lpm_showahead = "ON") then
							tmp_q <= mem_data(0);
						end if;
					else
						read_id <= read_id + 1;
						if (lpm_showahead = "ON") then
							tmp_q <= mem_data(read_id+1);
						end if;
					end if;
				end if;  -- if WRITE and/or READ
			end if;  -- if sclr = '1'
		end if;  -- if aclr = '1'
	end process;

	q <= tmp_q;
	full <= full_flag;
	empty <= empty_flag;
	usedw <= conv_std_logic_vector(count_id, lpm_widthu);

end lpm_syn;