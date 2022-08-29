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
module lpm_divide(
quotient,
remain,
numer,
denom,
clock,
clken,
aclr
);

// synopsys template
parameter lpm_type = "lpm_divide";
	parameter lpm_widthn = 1;
	parameter lpm_widthd = 1;
	parameter lpm_nrepresentation = "UNSIGNED";
	parameter lpm_drepresentation = "UNSIGNED";
	parameter lpm_remainderpositive = "TRUE";
	parameter lpm_pipeline = 0;
	parameter lpm_hint = "UNUSED";

	input  clock;
	input  clken;
	input  aclr;
	input  [lpm_widthn-1:0] numer;
	input  [lpm_widthd-1:0] denom;
	output [lpm_widthn-1:0] quotient;
	output [lpm_widthd-1:0] remain;

	// inernal reg
    reg [lpm_widthn-1:0] tmp_quotient [lpm_pipeline:0];
    reg [lpm_widthd-1:0] tmp_remain [lpm_pipeline:0];
    reg [lpm_widthn-1:0] ONES, ZEROS, UNKNOWN, HiZ;
    reg [lpm_widthd-1:0] DZEROS, DUNKNOWN;
    reg [lpm_widthn-1:0] NUNKNOWN;
    reg [lpm_widthd-1:0] RZEROS;
    reg [lpm_widthn-1:0] not_numer;
    reg [lpm_widthd-1:0] not_denom;
	integer i;
	integer int_numer, int_denom, int_quotient, int_remain;

	tri0 aclr;
	tri0 clock;
	tri1 clken;

	buf (i_aclr, aclr);
	buf (i_clock, clock);
	buf (i_clken, clken);


	initial
	begin
        // check if lpm_widthn > 0
        if (lpm_widthn <= 0)
            $display("Error!  LPM_WIDTHN must be greater than 0.\n");
        // check if lpm_widthd > 0
        if (lpm_widthd <= 0)
            $display("Error!  LPM_WIDTHD must be greater than 0.\n");
        // check for valid lpm_nrep value
        if ((lpm_nrepresentation != "SIGNED") && (lpm_nrepresentation != "UNSIGNED"))
            $display("Error!  LPM_NREPRESENTATION value must be \"SIGNED\" or \"UNSIGNED\".");
        // check for valid lpm_drep value
        if ((lpm_drepresentation != "SIGNED") && (lpm_drepresentation != "UNSIGNED"))
            $display("Error!  LPM_DREPRESENTATION value must be \"SIGNED\" or \"UNSIGNED\".");
        // check for valid lpm_remainderpositive value
        if ((lpm_remainderpositive != "TRUE") && (lpm_remainderpositive != "FALSE"))
            $display("Error!  LPM_REMAINDERPOSITIVE value must be \"TRUE\" or \"FALSE\".");
     
        for (i=0; i < lpm_widthn; i=i+1)
        begin
            ONES[i] = 1'b1;
            ZEROS[i] = 1'b0;
            UNKNOWN[i] = 1'bx;
            HiZ[i] = 1'bz;
        end
    
        for (i=0; i < lpm_widthd; i=i+1)
            DUNKNOWN[i] = 1'bx;
        for (i=0; i < lpm_widthn; i=i+1)
            NUNKNOWN[i] = 1'bx;
        for (i=0; i < lpm_widthd; i=i+1)
            RZEROS[i] = 1'b0;
	end

    always @(numer or denom or i_aclr)
	begin
		if (i_aclr)
		begin
			for (i = 0; i <= lpm_pipeline; i = i + 1)
				tmp_quotient[i] = ZEROS;
			tmp_remain[i] = RZEROS;
		end
        else
        begin
            int_numer = numer; 
            int_denom = denom;
            not_numer = ~numer;
            not_denom = ~denom;

            if (lpm_nrepresentation == "SIGNED")
                if (numer[lpm_widthn-1] == 1)
                    int_numer = (not_numer) * (-1) - 1;
            if (lpm_drepresentation == "SIGNED")
                if (denom[lpm_widthd-1] == 1)
                    int_denom = (not_denom) * (-1) - 1;
    
            int_quotient = int_numer / int_denom;
            int_remain = int_numer % int_denom;
    
            // LPM 220 standard
            if ((lpm_remainderpositive == "TRUE") && (int_remain < 0))
            begin
                int_quotient = int_quotient + ((int_denom < 0) ? 1 : (-1));
                int_remain = int_numer - int_quotient*int_denom;
            end
    
            tmp_quotient[lpm_pipeline] = int_quotient;
            tmp_remain[lpm_pipeline] = int_remain;
        end
	end

    always @(posedge i_clock)
    begin
        if (!i_aclr && i_clken)
            for (i = 0; i < lpm_pipeline; i = i + 1)
			begin
				tmp_quotient[i] = tmp_quotient[i+1];
				tmp_remain[i] = tmp_remain[i+1];
			end
	end

	assign quotient = tmp_quotient[0];
	assign remain = tmp_remain[0];

endmodule
// lpm_divide


