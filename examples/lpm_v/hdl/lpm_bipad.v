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

module lpm_bipad(
result,
pad,
data,
enable
);
// synopsys template
parameter lpm_type = "lpm_bipad";
	parameter lpm_width = 1;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	input  enable;
	inout  [lpm_width-1:0] pad;
	output [lpm_width-1:0] result;

	reg    [lpm_width-1:0] tmp_pad;
	reg    [lpm_width-1:0] result;

	always @(data or pad or enable)
	begin
		if (enable == 1)
		begin
			tmp_pad = data;
			result = 'bz;
		end
		else if (enable == 0)
		begin
			result = pad;
			tmp_pad = 'bz;
		end
	end

	assign pad = tmp_pad;

endmodule
// lpm_bipad


