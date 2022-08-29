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
module lpm_counter(
q,
data,
clock,
cin,
cout,
clk_en,
cnt_en,
updown,
aset,
aclr,
aload,
sset,
sclr,
sload
);

// synopsys template
parameter lpm_type = "lpm_counter";
	parameter lpm_width = 1;
	parameter lpm_modulus = 0;
	parameter lpm_direction = "UNUSED";
	parameter lpm_avalue = "UNUSED";
	parameter lpm_svalue = "UNUSED";
	parameter lpm_pvalue = "UNUSED";
	parameter lpm_hint = "UNUSED";

	output [lpm_width-1:0] q;
	output cout;
	input  cin;
	input  [lpm_width-1:0] data;
	input  clock, clk_en, cnt_en, updown;
	input  aset, aclr, aload;
	input  sset, sclr, sload;

    reg  [lpm_width-1:0] tmp_count;
    reg  prev_clock;
    reg  tmp_updown;
    reg  [lpm_width-1:0] ONES;
    integer tmp_modulus, i;

	tri1 clk_en;
	tri1 cnt_en;
	tri0 sload;
	tri0 sset;
	tri0 sclr;
	tri0 aload;
	tri0 aset;
	tri0 aclr;
    tri1 cin;
    tri1 updown;

	buf (i_clk_en, clk_en);
	buf (i_cnt_en, cnt_en);
	buf (i_sload, sload);
	buf (i_sset, sset);
	buf (i_sclr, sclr);
	buf (i_aload, aload);
	buf (i_aset, aset);
	buf (i_aclr, aclr);
	buf (i_cin, cin);
    buf (i_updown, updown);


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
			for (m=1; m<=16; m=m+1)
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
		// check if lpm_modulus < 0
		if (lpm_modulus < 0)
            $display("Error!  LPM_MODULUS must be greater than 0.\n");
		// check if lpm_modulus > 1<<lpm_width
		if (lpm_modulus > 1<<lpm_width)
            $display("Error!  LPM_MODULUS must be less than or equal to 1<<LPM_WIDTH.\n");
        // check if lpm_direction valid
        if (lpm_direction != "UNUSED" && lpm_direction != "UP" && lpm_direction != "DOWN")
            $display("Error!  LPM_DIRECTION must be \"UP\" or \"DOWN\" if used.\n");
        else if (lpm_direction != "UNUSED" && updown !== 1'bz)
            $display("Error!  LPM_DIRECTION and UPDOWN cannot be used at the same time.\n");

        for (i=0; i < lpm_width; i=i+1)
            ONES[i] = 1'b1;

        prev_clock = clock;

		tmp_modulus = (lpm_modulus == 0) ? (1 << lpm_width) : lpm_modulus;
		tmp_count = (lpm_pvalue == "UNUSED") ? 0 : str_to_int(lpm_pvalue);
	end

    always @(i_aclr or i_aset or i_aload or data or clock or i_updown)
	begin :asyn_block

        tmp_updown = ((lpm_direction == "UNUSED" && i_updown == 1) || lpm_direction == "UP")
                     ? 1 : 0;
		if (i_aclr)
            tmp_count = 0;
		else if (i_aset)
            tmp_count = (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                                 : str_to_int(lpm_avalue);
		else if (i_aload)
            tmp_count = data;
        else if (clock === 1 && prev_clock !== 1 && $time > 0)
		begin :syn_block
			if (i_clk_en)
			begin
				if (i_sclr)
                    tmp_count = 0;
				else if (i_sset)
                    tmp_count = (lpm_svalue == "UNUSED") ? {lpm_width{1'b1}}
                                                         : str_to_int(lpm_svalue);
				else if (i_sload)
                    tmp_count = data;
                else if (i_cnt_en && i_cin)
                begin
                    if (tmp_updown == 1)
                        tmp_count = (tmp_count == tmp_modulus-1) ? 0
                                                                 : tmp_count+1;
                    else
                        tmp_count = (tmp_count == 0) ? tmp_modulus-1
                                                     : tmp_count-1;
                end
			end
		end

        prev_clock = clock;
	end

    assign q = tmp_count;
    assign cout = (i_cin && ((tmp_updown==0 && tmp_count==0) ||
                             (tmp_updown==1 && (tmp_count==tmp_modulus-1 ||
                                                tmp_count==ONES)) ))
                    ? 1 : 0;

endmodule
// lpm_counter


