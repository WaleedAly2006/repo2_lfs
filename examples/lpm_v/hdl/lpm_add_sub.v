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
module lpm_add_sub(
result,
cout,
overflow,
add_sub,
cin,
dataa,
datab,
clock,
clken,
aclr
);
// synopsys template
    parameter lpm_type = "lpm_add_sub";
	parameter lpm_width = 1;
	parameter lpm_direction  = "UNUSED";
	parameter lpm_representation = "UNSIGNED";
	parameter lpm_pipeline = 0;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] dataa, datab;
	input  add_sub, cin;
	input  clock;
	input  clken;
	input  aclr;
	output [lpm_width-1:0] result;
	output cout, overflow;

    reg [lpm_width-1:0] tmp_result2 [lpm_pipeline:0];
    reg [lpm_pipeline:0] tmp_cout2;
    reg [lpm_pipeline:0] tmp_overflow2;
    reg [lpm_width-1:0] not_a, not_b, tmp_result;
    reg i_cin;
    integer dataa_int, datab_int, result_int, borrow, i; 

	tri0 aclr;
	tri0 clock;
	tri1 clken;
	tri1 add_sub;

	buf (i_aclr, aclr);
	buf (i_clock, clock);
	buf (i_clken, clken);
	buf (i_add_sub, add_sub);


    initial
    begin
        if (lpm_direction != "ADD" &&
            lpm_direction != "SUB" &&
            lpm_direction != "UNUSED" &&            // non-LPM 220 standard
            lpm_direction != "DEFAULT")             // non-LPM 220 standard
            $display("Error!  LPM_DIRECTION value must be \"ADD\" or \"SUB\".");
        if (lpm_representation != "SIGNED" &&
            lpm_representation != "UNSIGNED")
            $display("Error!  LPM_REPRESENTATION value must be \"SIGNED\" or \"UNSIGNED\".");

        for (i = 0; i <= lpm_pipeline; i = i + 1)
        begin
            tmp_result2[i] = 'b0;
            tmp_cout2[i] = 1'b0;
            tmp_overflow2[i] = 1'b0;
        end
    end

    always @(cin or dataa or datab or i_add_sub or i_aclr)
	begin
		if (i_aclr)
			for (i = 0; i <= lpm_pipeline; i = i + 1)
			begin
				tmp_result2[i] = 'b0;
				tmp_cout2[i] = 1'b0;
				tmp_overflow2[i] = 1'b0;
			end
        else
        begin
    
            // cout is the same for both signed and unsign representation.  
            if (lpm_direction == "ADD" || (i_add_sub == 1 &&
                (lpm_direction == "UNUSED" || lpm_direction == "DEFAULT") ))
            begin
                i_cin = (cin === 1'bz) ? 0 : cin;
                {tmp_cout2[lpm_pipeline], tmp_result2[lpm_pipeline]} = dataa + datab + i_cin;
                tmp_overflow2[lpm_pipeline] = tmp_cout2[lpm_pipeline];
            end
            else if (lpm_direction == "SUB" || (i_add_sub == 0 &&
                    (lpm_direction == "UNUSED" || lpm_direction == "DEFAULT") ))
            begin
                i_cin = (cin === 1'bz) ? 1 : cin;
                borrow = (~i_cin) ? 1 : 0;
                {tmp_overflow2[lpm_pipeline], tmp_result2[lpm_pipeline]} = dataa - datab - borrow;
                tmp_cout2[lpm_pipeline] = (dataa >= (datab+borrow))?1:0;
            end
     
            if (lpm_representation == "SIGNED")
            begin
                not_a = ~dataa;
                not_b = ~datab;

                dataa_int = (dataa[lpm_width-1]) ? (not_a)*(-1)-1 : dataa;
                datab_int = (datab[lpm_width-1]) ? (not_b)*(-1)-1 : datab;
    
                // perform the addtion or subtraction operation
                if (lpm_direction == "ADD" || (i_add_sub == 1 &&
                    (lpm_direction == "UNUSED" || lpm_direction == "DEFAULT") ))
                begin
                    i_cin = (cin === 1'bz) ? 0 : cin;
                    result_int = dataa_int + datab_int + i_cin;
                    tmp_result = result_int;
                    tmp_overflow2[lpm_pipeline] = ((dataa[lpm_width-1] == datab[lpm_width-1]) &&
                                                   (dataa[lpm_width-1] != tmp_result[lpm_width-1])) ?
                                                  1 : 0;
                end
                else if (lpm_direction == "SUB" || (i_add_sub == 0 &&
                        (lpm_direction == "UNUSED" || lpm_direction == "DEFAULT") ))
                begin
                    i_cin = (cin === 1'bz) ? 1 : cin;
                    borrow = (~i_cin) ? 1 : 0;
                    result_int = dataa_int - datab_int - borrow;
                    tmp_result = result_int;
                    tmp_overflow2[lpm_pipeline] = ((dataa[lpm_width-1] != datab[lpm_width-1]) &&
                                                   (dataa[lpm_width-1] != tmp_result[lpm_width-1])) ?
                                                  1 : 0;
                end
                tmp_result2[lpm_pipeline] = result_int;
            end
        end
	end	

    always @(posedge i_clock)
	begin
        if (!i_aclr && i_clken == 1)
            for (i = 0; i < lpm_pipeline; i = i + 1)
			begin
                tmp_result2[i] = tmp_result2[i+1];
                tmp_cout2[i] = tmp_cout2[i+1];
                tmp_overflow2[i] = tmp_overflow2[i+1];
			end
	end

    assign result = tmp_result2[0];
    assign cout = tmp_cout2[0];
    assign overflow = tmp_overflow2[0];

endmodule
// lpm_add_sub


