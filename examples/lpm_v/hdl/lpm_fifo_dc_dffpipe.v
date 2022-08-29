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

module lpm_fifo_dc_dffpipe( 
   d, 
   q, 
   clock, 
   aclr
);

// synopsys template
// synopsys template
// synopsys template
// synopsys template
parameter lpm_delay = 1,
          lpm_width = 128;

// Internal Declarations

input  [lpm_width-1:0] d;
output [lpm_width-1:0] q;
input                  clock;
input                  aclr;


wire [lpm_width-1:0] d;
wire [lpm_width-1:0] q;
wire clock;
wire aclr;

	// internal reg
    reg [lpm_width-1:0] dffpipe [lpm_delay:0];
    reg [lpm_width-1:0] i_q;
    integer delay, i;

    initial
    begin
        delay = lpm_delay-1;
        for (i=0; i<lpm_delay; i=i+1)
            dffpipe[i] = 0;
        i_q = 0;
    end

    always @(d)
    begin
        if (lpm_delay == 0 && !aclr)
            i_q <= (aclr) ? 0 : d;
    end

    always @(aclr)
    begin
        if (aclr)
        begin
            for (i=0; i<lpm_delay; i=i+1)
                dffpipe[i] = 0;
            i_q <= 0;
        end
    end

    always @(posedge clock)
    begin
        if (!aclr && lpm_delay > 0 && $time > 0)
        begin
            if (delay > 0)
                for (i=delay; i>0; i=i-1)
                    dffpipe[i] = dffpipe[i-1];
            dffpipe[0] = d;
            i_q <= dffpipe[delay];
        end
    end

    assign q = i_q;

endmodule
// lpm_fifo_dc_dffpipe


