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

module lpm_outpad( 
   data, 
   pad
);

// synopsys template
// synopsys template
// synopsys template
// synopsys template
parameter lpm_type  = "lpm_outpad",
          lpm_width = 1,
          lpm_hint  = "UNUSED";

// Internal Declarations

input  [lpm_width-1:0] data;
output [lpm_width-1:0] pad;


wire [lpm_width-1:0] data;
reg [lpm_width-1:0] pad;

	always @(data)
	begin
		pad = data;
	end

endmodule
// lpm_outpad

