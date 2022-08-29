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
module lpm_bustri(
result,
tridata,
data,
enabledt,
enabletr
);

// synopsys template
parameter lpm_type = "lpm_bustri";
	parameter lpm_width = 1;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	input  enabledt;
	input  enabletr;
	output [lpm_width-1:0] result;
	inout  [lpm_width-1:0] tridata;

	reg    [lpm_width-1:0] result;
	reg    [lpm_width-1:0] tmp_tridata;

	tri0  enabledt;
	tri0  enabletr;
	buf (i_enabledt, enabledt);
	buf (i_enabletr, enabletr);

	always @(data or tridata or i_enabletr or i_enabledt)
	begin
        if (i_enabledt == 0 && i_enabletr == 1)
		begin
			result = tridata;
			tmp_tridata = 'bz;
		end
        else if (i_enabledt == 1 && i_enabletr == 0)
		begin
			result = 'bz;
			tmp_tridata = data;
		end
        else if (i_enabledt == 1 && i_enabletr == 1)
		begin
			result = data;
			tmp_tridata = data;
		end
		else
		begin
			result = 'bz;
			tmp_tridata = 'bz;
		end
	end

	assign tridata = tmp_tridata;

endmodule
// lpm_bustri


