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

module lpm_latch(
q,
data,
gate,
aset,
aclr
);
// synopsys template
parameter lpm_type = "lpm_latch";
  parameter lpm_width = 1;
  parameter lpm_avalue = "UNUSED";
  parameter lpm_pvalue = "UNUSED";
  parameter lpm_hint = "UNUSED";

  input  [lpm_width-1:0] data;
  input  gate, aset, aclr;
  output [lpm_width-1:0] q;

  reg [lpm_width-1:0] q;

  reg [lpm_width-1:0] i_data;

  tri0 aset;
  tri0 aclr;

  buf (i_aset, aset);
  buf (i_aclr, aclr);

//---------------------------------------------------------------//
//  function integer str_to_int;
//---------------------------------------------------------------//
	function integer str_to_int;
        input [8*16:1] s; 
		
		reg [8*16:1] reg_s;
		reg [8:1] digit;
		reg [8:1] tmp;
        integer m, ivalue; 
		
		begin 
			ivalue = 0;
			reg_s = s;
			for (m=1; m<=16; m= m+1) 
			begin 
				tmp = reg_s[128:121];
				digit = tmp & 8'b00001111;
				reg_s = reg_s << 8; 
				ivalue = ivalue * 10 + digit; 
			end
			str_to_int = ivalue;
		end
	endfunction
//---------------------------------------------------------------//

	initial
	begin
		if (lpm_pvalue != "UNUSED")
			q = str_to_int(lpm_pvalue);
        i_data = (data === {lpm_width{1'bz}}) ? 0 : data;
	end

    always @(data)
        i_data = data;

    always @(i_data or gate or i_aclr or i_aset)
	begin
		if (i_aclr)
			q = 'b0;
		else if (i_aset)
            q = (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                         : str_to_int(lpm_avalue);
		else if (gate)
            q = i_data;
	end

endmodule
// lpm_latch


