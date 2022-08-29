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

module lpm_decode(
eq,
data,
enable,
clock,
clken,
aclr
);
// synopsys template
parameter lpm_type = "lpm_decode";
	parameter lpm_width = 1;
	parameter lpm_decodes = 1 << lpm_width;
	parameter lpm_pipeline = 0;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	input  enable;
    input  clock;
	input  clken;
	input  aclr;
	output [lpm_decodes-1:0] eq;

    reg    [lpm_decodes-1:0] tmp_eq2 [lpm_pipeline:0];
    reg    [lpm_decodes-1:0] tmp_eq;
    integer i;

	tri0   clock;
	tri1   clken;
	tri0   aclr;
	tri1   enable;

	buf (i_clock, clock);
	buf (i_clken, clken);
	buf (i_aclr, aclr);
	buf (i_enable, enable);


    always @(data or i_enable or i_aclr)
	begin
        if (i_aclr)
			for (i = 0; i <= lpm_pipeline; i = i + 1)
                tmp_eq2[i] = 'b0;
        else
        begin
            tmp_eq = 0;
            if (i_enable)
                tmp_eq[data] = 1'b1;
            tmp_eq2[lpm_pipeline] = tmp_eq;
        end
	end
 
    always @(posedge i_clock)
	begin
        if (!i_aclr && clken == 1)
            for (i = 0; i < lpm_pipeline; i = i + 1)
                tmp_eq2[i] = tmp_eq2[i+1];
	end

    assign eq = tmp_eq2[0];

endmodule
// lpm_decode


