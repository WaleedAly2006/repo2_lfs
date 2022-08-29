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
module lpm_compare(
alb,
aeb,
agb,
aleb,
aneb,
ageb,
dataa,
datab,
clock,
clken,
aclr
);

// synopsys template
parameter lpm_type = "lpm_compare";
	parameter lpm_width = 1;
	parameter lpm_representation = "UNSIGNED";
    parameter lpm_pipeline = 0;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] dataa, datab;
	input  clock;
	input  clken;
	input  aclr;
	output alb, aeb, agb, aleb, aneb, ageb;

    reg [lpm_pipeline:0] tmp_alb2, tmp_aeb2, tmp_agb2;
    reg [lpm_pipeline:0] tmp_aleb2, tmp_aneb2, tmp_ageb2;
    reg [lpm_width-1:0] not_a, not_b;
    integer dataa_int, datab_int, i;

	tri0 aclr;
	tri0 clock;
	tri1 clken;

	buf (i_aclr, aclr);
	buf (i_clock, clock);
	buf (i_clken, clken);

    initial
    begin
        if (lpm_representation != "SIGNED" &&
            lpm_representation != "UNSIGNED")
            $display("Error!  LPM_REPRESENTATION value must be \"SIGNED\" or \"UNSIGNED\".");
    end


    always @(dataa or datab or i_aclr)
	begin
		if (i_aclr)
            for (i = 0; i <= lpm_pipeline; i = i + 1)
			begin
                tmp_aeb2[i] = 'b0;
                tmp_agb2[i] = 'b0;
                tmp_alb2[i] = 'b0;
                tmp_aleb2[i] = 'b0;
                tmp_aneb2[i] = 'b0;
                tmp_ageb2[i] = 'b0;
			end
        else
        begin
            dataa_int = dataa;
            datab_int = datab;
            not_a = ~dataa;
            not_b = ~datab;
    
            if (lpm_representation == "SIGNED")
            begin
                if (dataa[lpm_width-1] == 1)
                    dataa_int = (not_a) * (-1) - 1;
                if (datab[lpm_width-1] == 1)
                    datab_int = (not_b) * (-1) - 1;
            end
    
            tmp_alb2[lpm_pipeline] = (dataa_int < datab_int);
            tmp_aeb2[lpm_pipeline] = (dataa_int == datab_int);
            tmp_agb2[lpm_pipeline] = (dataa_int > datab_int);
            tmp_aleb2[lpm_pipeline] = (dataa_int <= datab_int);
            tmp_aneb2[lpm_pipeline] = (dataa_int != datab_int);
            tmp_ageb2[lpm_pipeline] = (dataa_int >= datab_int);
        end
	end

    always @(posedge i_clock)
	begin
        if (!i_aclr && i_clken == 1)
            for (i = 0; i < lpm_pipeline; i = i + 1)
            begin
                tmp_alb2[i] = tmp_alb2[i+1];
                tmp_aeb2[i] = tmp_aeb2[i+1];
                tmp_agb2[i] = tmp_agb2[i+1];
                tmp_aleb2[i] = tmp_aleb2[i+1];
                tmp_aneb2[i] = tmp_aneb2[i+1];
                tmp_ageb2[i] = tmp_ageb2[i+1];
            end
	end

    assign alb = tmp_alb2[0];
    assign aeb = tmp_aeb2[0];
    assign agb = tmp_agb2[0];
    assign aleb = tmp_aleb2[0];
    assign aneb = tmp_aneb2[0];
    assign ageb = tmp_ageb2[0];

endmodule
// lpm_compare


