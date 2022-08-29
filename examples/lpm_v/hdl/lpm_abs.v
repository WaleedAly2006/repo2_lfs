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

module lpm_abs( 
   result, 
   overflow, 
   data
);

// synopsys template
// synopsys template
parameter lpm_type  = "lpm_abs",
          lpm_width = 1,
          lpm_hint  = "UNUSED";

// Internal Declarations

output [lpm_width-1:0] result;
output                 overflow;
input  [lpm_width-1:0] data;


reg [lpm_width-1:0] result;
reg overflow;
wire [lpm_width-1:0] data;


	always @(data)
	begin
		overflow = 0;
        result = data;
        not_r = ~data;

		if (data[lpm_width-1] == 1)
		begin
            result = (not_r) + 1;
            overflow = (result == (1<<(lpm_width-1)));
		end
	end

endmodule 
// lpm_abs

