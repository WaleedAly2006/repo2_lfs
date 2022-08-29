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

module lpm_mult(
result,
dataa,
datab,
sum,
clock,
clken,
aclr
);

// synopsys template
parameter lpm_type = "lpm_mult";
	parameter lpm_widtha = 1;
	parameter lpm_widthb = 1;
	parameter lpm_widths = 1;
	parameter lpm_widthp = 1;
	parameter lpm_representation  = "UNSIGNED";
	parameter lpm_pipeline  = 0;
	parameter lpm_hint = "UNUSED";

	input  clock;
	input  clken;
	input  aclr;
	input  [lpm_widtha-1:0] dataa;
	input  [lpm_widthb-1:0] datab;
	input  [lpm_widths-1:0] sum;
	output [lpm_widthp-1:0] result;

	// inernal reg
    reg [lpm_widthp-1:0] resulttmp [lpm_pipeline:0];
    reg [lpm_widthp-1:0] i_prod, t_p;
    reg [lpm_widths-1:0] i_prod_s, t_s;
    reg [lpm_widtha+lpm_widthb-1:0] i_prod_ab;
    reg [lpm_widtha-1:0] t_a;
    reg [lpm_widthb-1:0] t_b;
    reg sign_ab, sign_s;
    integer i;

	tri0 aclr;
	tri0 clock;
	tri1 clken;

	buf (i_aclr, aclr);
	buf (i_clock, clock);
	buf (i_clken, clken);


	initial
	begin
        // check if lpm_widtha > 0
        if (lpm_widtha <= 0)
            $display("Error!  LPM_WIDTHA must be greater than 0.\n");
        // check if lpm_widthb > 0
        if (lpm_widthb <= 0)
            $display("Error!  LPM_WIDTHB must be greater than 0.\n");
        // check if lpm_widthp > 0
        if (lpm_widthp <= 0)
            $display("Error!  LPM_WIDTHP must be greater than 0.\n");
        // check for valid lpm_rep value
        if ((lpm_representation != "SIGNED") && (lpm_representation != "UNSIGNED"))
            $display("Error!  LPM_REPRESENTATION value must be \"SIGNED\" or \"UNSIGNED\".", $time);
	end

    always @(dataa or datab or sum or i_aclr)
	begin
        if (i_aclr)
            for (i = 0; i <= lpm_pipeline; i = i + 1)
                resulttmp[i] = 'b0;
        else
        begin
            t_a = dataa;
            t_b = datab;
            t_s = sum;
            sign_ab = 0;
            sign_s = 0;
    
            if (lpm_representation == "SIGNED")
            begin
                sign_ab = dataa[lpm_widtha-1] ^ datab[lpm_widthb-1];
                sign_s = sum[lpm_widths-1];

                if (dataa[lpm_widtha-1] == 1)
                    t_a = ~dataa + 1;
                if (datab[lpm_widthb-1] == 1)
                    t_b = ~datab + 1;
                if (sum[lpm_widths-1] == 1)
                    t_s = ~sum + 1;
            end
    
            if (sum === {lpm_widths{1'bz}})
            begin
                t_s = 0;
                sign_s = 0;
            end

            if (sign_ab == sign_s)
            begin
                i_prod = t_a * t_b + t_s;
                i_prod_s = t_a * t_b + t_s;
                i_prod_ab = t_a * t_b + t_s;
            end
            else
            begin
                i_prod = t_a * t_b - t_s;
                i_prod_s = t_a * t_b - t_s;
                i_prod_ab = t_a * t_b - t_s;
            end

            if (sign_ab)
            begin
                i_prod = ~i_prod + 1;
                i_prod_s = ~i_prod_s + 1;
                i_prod_ab = ~i_prod_ab + 1;
            end

            if (lpm_widthp < lpm_widths || lpm_widthp < lpm_widtha+lpm_widthb)
                for (i = 0; i < lpm_widthp; i = i + 1)
                    i_prod[lpm_widthp-1-i] = (lpm_widths > lpm_widtha+lpm_widthb)
                                             ? i_prod_s[lpm_widths-1-i]
                                             : i_prod_ab[lpm_widtha+lpm_widthb-1-i];
    
            resulttmp[lpm_pipeline] = i_prod;
        end
	end

    always @(posedge i_clock)
	begin
        if (!i_aclr && i_clken == 1)
            for (i = 0; i < lpm_pipeline; i = i + 1)
                resulttmp[i] = resulttmp[i+1];
	end

    assign result = resulttmp[0];

endmodule
// lpm_mult


