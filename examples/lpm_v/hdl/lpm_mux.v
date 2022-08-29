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

module lpm_mux(
result,
clock,
clken,
data,
aclr,
sel
);
// synopsys template
parameter lpm_type = "lpm_mux";
	parameter lpm_width = 1;
	parameter lpm_size = 1;
	parameter lpm_widths = 1;
	parameter lpm_pipeline = 0;
	parameter lpm_hint  = "UNUSED";

	input [(lpm_size * lpm_width)-1:0] data;
	input aclr;
	input clock;
	input clken;
	input [lpm_widths-1:0] sel;
	output [lpm_width-1:0] result;

	reg [lpm_width-1:0] tmp_result2 [lpm_pipeline:0];
    reg [lpm_width-1:0] tmp_result;
    integer i;

	tri0 aclr;
	tri0 clock;
	tri1 clken;

	buf (i_aclr, aclr);
	buf (i_clock, clock);
	buf (i_clken, clken);

    always @(data or sel or i_aclr)
	begin
		if (i_aclr)
			for (i = 0; i <= lpm_pipeline; i = i + 1)
				tmp_result2[i] = 'b0;
        else
        begin
            tmp_result = 0;
            for (i = 0; i < lpm_width; i = i + 1)
                tmp_result[i] = data[sel * lpm_width + i];
            tmp_result2[lpm_pipeline] = tmp_result;
        end
	end

    always @(posedge i_clock)
	begin
        if (!i_aclr && i_clken == 1)
            for (i = 0; i < lpm_pipeline; i = i + 1)
                tmp_result2[i] = tmp_result2[i+1];
	end

    assign result = tmp_result2[0];
endmodule
// lpm_mux


