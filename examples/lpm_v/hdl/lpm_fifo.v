//------------------------------------------------------------------------
//   This Verilog file was developed by Altera Corporation.  It may be
// freely copied and/or distributed at no cost.  Any persons using this
// file for any purpose do so at their own risk, and are responsible for
// the results of such use.  Altera Corporation does not guarantee that
// this file is complete, correct, or fit for any particular purpose.
// NO WARRANTY OF ANY KIND IS EXPRESSED OR IMPLIED.  This notice must
// accompany any copy of this file.
//
//------------------------------------------------------------------------
// LPM Synthesizable Models 
// These models are based on LPM version 220 (EIA-IS103 October 1998).
//-----------------------------------------------------------------------
// Version Quartus v1.1 (lpm 220)      Date 04/17/01
//------------------------------------------------------------------------

module lpm_fifo(
data,
clock,
wrreq,
rdreq,
aclr,
sclr,
q,
usedw,
full,
empty
);
// synopsys template
parameter lpm_type = "lpm_fifo";
	parameter lpm_width  = 1;
	parameter lpm_widthu  = 1;
    parameter lpm_numwords = 1;
	parameter lpm_showahead = "OFF";
	parameter lpm_hint = "UNUSED";

    input  [lpm_width-1:0] data;
    input  clock;
    input  wrreq;
    input  rdreq;
    input  aclr;
    input  sclr;
	output [lpm_width-1:0] q;
	output [lpm_widthu-1:0] usedw;
	output full;
	output empty;

	// internal reg
	reg [lpm_width-1:0] mem_data [lpm_numwords-1:0];
	reg [lpm_width-1:0] tmp_q;
	reg [lpm_width-1:0] ZEROS;
	reg [lpm_widthu+1:0] count_id;
	reg [lpm_widthu-1:0] write_id;
	reg [lpm_widthu-1:0] read_id;
	reg empty_flag;
	reg full_flag;
	integer i;

	tri0 aclr;
	tri0 sclr;

	buf (i_aclr, aclr);
	buf (i_sclr, sclr);


	initial
	begin
        if (lpm_width <= 0)
            $display("Error!  LPM_WIDTH must be greater than 0.");

        if (lpm_numwords < 1)
            $display("Error!  LPM_NUMWORDS must be greater than 0.");

		// check for number of words out of bound
        if ((lpm_widthu != 1) && (lpm_numwords > (1 << lpm_widthu)))
            $display("Error!  The ceiling of log2(LPM_NUMWORDS) must equal to LPM_WIDTHU.");
        if (lpm_numwords <= (1 << (lpm_widthu-1)) && lpm_numwords > 1)
            $display("Error!  The ceiling of log2(LPM_NUMWORDS) must equal to LPM_WIDTHU.");

        if (lpm_showahead != "ON" && lpm_showahead != "OFF")
            $display("Error!  LPM_SHOWAHEAD must be \"ON\" or \"OFF\".");


		for (i=0; i < lpm_width; i=i+1)
			ZEROS[i] = 1'b0;

		for (i = 0; i < lpm_numwords; i=i+1)
			mem_data[i] = ZEROS;

		full_flag = 0;
		empty_flag = 1;
		read_id = 0;
		write_id = 0;
		count_id = 0;
		tmp_q = ZEROS;
	end

    always @(posedge clock or posedge i_aclr)
	begin
		if (i_aclr)
		begin
			tmp_q = ZEROS;
			full_flag = 0;
			empty_flag = 1;
			read_id = 0;
			write_id = 0;
			count_id = 0;
			if (lpm_showahead == "ON")
				tmp_q = mem_data[0];
		end
		else if (clock)
		begin
			if (i_sclr)
			begin
				tmp_q = mem_data[read_id];
				full_flag = 0;
				empty_flag = 1;
				read_id = 0;
				write_id = 0;
				count_id = 0;
				if (lpm_showahead == "ON")
					tmp_q = mem_data[0];
			end
			else
			begin
				// both WRITE and READ
				if ((wrreq && !full_flag) && (rdreq && !empty_flag))
				begin
					mem_data[write_id] = data;
					if (write_id >= lpm_numwords-1)
						write_id = 0;
					else
						write_id = write_id + 1;

					tmp_q = mem_data[read_id];
					if (read_id >= lpm_numwords-1)
						read_id = 0;
					else
						read_id = read_id + 1;
					if (lpm_showahead == "ON")
						tmp_q = mem_data[read_id];
				end

				// WRITE
				else if (wrreq && !full_flag)
				begin
					mem_data[write_id] = data;
					if (lpm_showahead == "ON")
						tmp_q = mem_data[read_id];
					count_id = count_id + 1;
					empty_flag = 0;
					if (count_id >= lpm_numwords)
					begin
						full_flag = 1;
						count_id = lpm_numwords;
					end
					if (write_id >= lpm_numwords-1)
						write_id = 0;
					else
						write_id = write_id + 1;
				end
							
				// READ
				else if (rdreq && !empty_flag)
				begin
					tmp_q = mem_data[read_id];
					count_id = count_id - 1;
					full_flag = 0;
					if (count_id <= 0)
					begin
						empty_flag = 1;
						count_id = 0;
					end
					if (read_id >= lpm_numwords-1)
						read_id = 0;
					else
						read_id = read_id + 1;
					if (lpm_showahead == "ON")
						tmp_q = mem_data[read_id];
				end
			end
		end
	end

	assign q = tmp_q;
	assign full = full_flag;
	assign empty = empty_flag;
	assign usedw = count_id;

endmodule
// lpm_fifo


