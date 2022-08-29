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
module lpm_fifo_dc_fefifo( 
   usedw_in, 
   wreq, 
   rreq, 
   empty, 
   full, 
   clock, 
   aclr
);

// synopsys template
// synopsys template
// synopsys template
// synopsys template
parameter lpm_widthad        = 1,
          lpm_numwords       = 1,
          lpm_mode           = "READ",
          underflow_checking = "ON",
          overflow_checking  = "ON";

// Internal Declarations

input  [lpm_widthad-1:0] usedw_in;
input                    wreq;
input                    rreq;
output                   empty;
output                   full;
input                    clock;
input                    aclr;


wire [lpm_widthad-1:0] usedw_in;
wire wreq;
wire rreq;
wire empty;
wire full;
wire clock;
wire aclr;

	// internal reg
    reg [1:0] sm_empty;
    reg i_empty;
    reg lrreq;
    reg valid_rreq;
    reg i_full;
    integer almostfull;

    initial
    begin
        if (lpm_mode != "READ" && lpm_mode != "WRITE")
            $display("Error!  LPM_MODE must be \"READ\" or \"WRITE\".");
        if(underflow_checking != "ON" && underflow_checking != "OFF")
            $display("Error! underflow_checking must be ON or OFF.");
        if(overflow_checking != "ON" && overflow_checking != "OFF")
            $display("Error! overflow_checking must be ON or OFF.");

        sm_empty = 2'b00;
        i_empty = 1'b1;
        lrreq = 1'b0;
        i_full = 1'b0;
        almostfull = (lpm_numwords >= 3) ? lpm_numwords-3 : 0;
    end

    always @(rreq or i_empty)
        valid_rreq = (underflow_checking == "OFF") ? rreq
                                                   : rreq && !i_empty;

    always @(posedge clock or posedge aclr)
    begin
        if (aclr)
        begin
            sm_empty = 2'b00;
            lrreq <= 1'b0;
        end
        else // if ($time > 0)
        begin
            lrreq <= valid_rreq;
            if (lpm_mode == "READ")
            begin
               casex (sm_empty)
                    2'b00:                          // state_empty
                        if (usedw_in != 0)
                            sm_empty = 2'b01;
                    2'b01:                          // state_non_empty
                        if (rreq && ((usedw_in==1 && !lrreq) || (usedw_in==2 && lrreq)))
                            sm_empty = 2'b10;
                    2'b10:                          // state_emptywait
                        if (usedw_in > 1) sm_empty = 2'b01;
                        else sm_empty = 2'b00;
                endcase
            end
            else if (lpm_mode == "WRITE")
            begin
                casex (sm_empty)
                    2'b00:                          // state_empty
                        if (wreq)
                            sm_empty = 2'b01;
                    2'b01:                          // state_one
                        if (!wreq)
                            sm_empty = 2'b11;
                    2'b11:                          // state_non_empty
                        if (wreq)
                            sm_empty = 2'b01;
                        else if (usedw_in == 0)
                            sm_empty = 2'b00;
                endcase
            end
        end

        i_empty = !sm_empty[0];
        i_full = (!aclr && $time>0 && usedw_in>=almostfull) ? 1'b1 : 1'b0;
    end

    assign empty = i_empty;
    assign full = i_full;

endmodule
// lpm_fifo_dc_fefifo


