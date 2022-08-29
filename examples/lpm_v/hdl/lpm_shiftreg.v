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

module lpm_shiftreg(
q,
shiftout,
data,
clock,
enable,
aclr,
aset,
sclr,
sset,
shiftin,
load
);
// synopsys template
parameter lpm_type = "lpm_shiftreg";
	parameter lpm_width  = 1;
	parameter lpm_avalue = "UNUSED";
	parameter lpm_svalue = "UNUSED";
	parameter lpm_pvalue = "UNUSED";
	parameter lpm_direction = "LEFT";
	parameter lpm_hint  = "UNUSED";

	input  [lpm_width-1:0] data;
	input  clock, enable;
	input  aclr, aset;
	input  sclr, sset;
	input  shiftin, load;
	output [lpm_width-1:0] q;
	output shiftout;


	reg  [lpm_width-1:0] tmp_q;
	reg  abit;
	integer i;

	wire tmp_shiftout;

	tri1 enable;
	tri1 shiftin;
	tri0 load;
	tri0 sclr;
	tri0 sset;
	tri0 aclr;
	tri0 aset;

	buf (i_enable, enable);
	buf (i_shiftin, shiftin);
	buf (i_load, load);
	buf (i_sclr, sclr);
	buf (i_sset, sset);
	buf (i_aclr, aclr);
	buf (i_aset, aset);


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
        if (lpm_direction != "LEFT" &&
            lpm_direction != "RIGHT" &&
            lpm_direction != "UNUSED")          // non-LPM 220 standard
            $display("Error!  LPM_DIRECTION value must be \"LEFT\" or \"RIGHT\".");

        tmp_q = (lpm_pvalue == "UNUSED") ? 0 : str_to_int(lpm_pvalue);
    end

    always @(i_aclr or i_aset)
    begin
		if (i_aclr)
            tmp_q = (i_aset) ? 'bx : 0;
		else if (i_aset)
            tmp_q = (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                             : str_to_int(lpm_avalue);
    end

    always @(posedge clock)
	begin :asyn_block // Asynchronous process
		if (i_aclr)
            tmp_q = (i_aset) ? 'bx : 0;
		else if (i_aset)
            tmp_q = (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                             : str_to_int(lpm_avalue);
		else
		begin :syn_block // Synchronous process
			if (i_enable)
			begin
				if (i_sclr)
					tmp_q = 0;
				else if (i_sset)
                    tmp_q = (lpm_svalue == "UNUSED") ? {lpm_width{1'b1}}
                                                     : str_to_int(lpm_svalue);
				else if (i_load)  
					tmp_q = data;
				else if (!i_load)
				begin
                    if (lpm_direction == "LEFT" || lpm_direction == "UNUSED")
						{abit,tmp_q} = {tmp_q,i_shiftin};
                    else if (lpm_direction == "RIGHT")
						{tmp_q,abit} = {i_shiftin,tmp_q};
				end
			end
		end
	end


    assign tmp_shiftout = (lpm_direction == "RIGHT") ? tmp_q[0]
                                                     : tmp_q[lpm_width-1];
	assign q = tmp_q;
	assign shiftout = tmp_shiftout;

endmodule
// lpm_shiftreg


