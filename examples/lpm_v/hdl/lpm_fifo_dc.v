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

module lpm_fifo_dc(
data,
rdclock,
wrclock,
aclr,
rdreq,
wrreq,
rdfull,
wrfull,
rdempty,
wrempty,
rdusedw,
wrusedw,
q
);
// synopsys template
parameter lpm_type = "lpm_fifo_dc";
	parameter lpm_width = 1;
	parameter lpm_widthu = 1;
        parameter lpm_numwords = 1;
	parameter lpm_showahead = "OFF";
	parameter lpm_hint = "USE_EAB=ON"; 
	parameter underflow_checking = "ON"; 
	parameter overflow_checking = "ON"; 
        parameter delay_rdusedw = 1;
        parameter delay_wrusedw = 1;
        parameter rdsync_delaypipe = 3;
        parameter wrsync_delaypipe = 3;

	input [lpm_width-1:0] data;
        input rdclock;
        input wrclock;
	input wrreq;
	input rdreq;
	input aclr;
	output rdfull;
	output wrfull;
	output rdempty;
	output wrempty;
	output [lpm_widthu-1:0] rdusedw;
	output [lpm_widthu-1:0] wrusedw;
	output [lpm_width-1:0] q;

	// internal reg
    reg [lpm_width-1:0] mem_data [(1<<lpm_widthu)-1:0];
    reg [lpm_widthu-1:0] i_rdptr, i_wrptr;
    wire [lpm_widthu-1:0] w_rdptrrg, w_wrdelaycycle;
    wire [lpm_widthu-1:0] w_ws_nbrp, w_rs_nbwp, w_ws_dbrp, w_rs_dbwp;
    wire [lpm_widthu-1:0] w_wr_dbuw, w_rd_dbuw, w_rdusedw, w_wrusedw;
    reg [lpm_widthu-1:0] i_wr_udwn, i_rd_udwn;
    wire w_rdempty, w_wrempty, wrdfull, w_wrfull;
    reg i_rdempty, i_wrempty;
    reg i_rdfull, i_wrfull;
    reg i_rden, i_wren, i_rdenclock;
    reg [lpm_width-1:0] i_q;
    integer i;

    reg [lpm_width-1:0] i_data_tmp, i_data_reg;
    reg [lpm_width-1:0] i_q_tmp, i_q_reg;
    reg [lpm_widthu-1:0] i_rdptr_tmp, i_wrptr_tmp, i_wrptr_reg;
    reg i_wren_tmp, i_wren_reg;

	tri0 aclr;
	buf (i_aclr, aclr);


    initial
    begin
        if(lpm_showahead != "ON" && lpm_showahead != "OFF")
            $display("Error! lpm_showahead must be ON or OFF.");
        if(underflow_checking != "ON" && underflow_checking != "OFF")
            $display("Error! underflow_checking must be ON or OFF.");
        if(overflow_checking != "ON" && overflow_checking != "OFF")
            $display("Error! overflow_checking must be ON or OFF.");

        i_rdptr = 0;
        i_wrptr = 0;
        i_rdempty = 1;
        i_wrempty = 1;
        i_rdfull = 0;
        i_wrfull = 0;
        i_rden = 0;
        i_rdenclock = 0;
        i_wren = 0;
        i_q = 0;

        i_data_tmp = 0;
        i_data_reg = 0;
        i_q_tmp = 0;
        i_q_reg = 0;
        i_rdptr_tmp = 0;
        i_wrptr_tmp = 0;
        i_wrptr_reg = 0;
        i_wren_tmp = 0;
        i_wren_reg = 0;
        i_wr_udwn = 0;
        i_rd_udwn = 0;

        for (i=0; i<(1<<lpm_widthu); i=i+1)
            mem_data[i] = 0;
    end


    //--------
    // FIFOram
    //--------

    always @(rdreq or i_rdempty)
        i_rden = (underflow_checking == "OFF") ? rdreq
                                               : rdreq && !i_rdempty;
    always @(wrreq or i_wrfull)
        i_wren = (overflow_checking == "OFF") ? wrreq
                                              : wrreq && !i_wrfull;

    // FIFOram_sync
    always @(i_data_reg or i_q_tmp or i_q_reg or i_aclr or
             i_rdptr or i_wren_reg or i_wrptr_reg)
    begin
        if (i_aclr)
        begin
            i_wrptr_tmp <= 0;
            i_rdptr_tmp <= 0;
            i_wren_tmp <= 0;
            i_data_tmp <= 0;
            i_q <= (lpm_showahead == "ON") ? i_q_tmp : 0;
        end
        else
        begin
            i_wrptr_tmp <= i_wrptr_reg;
            i_rdptr_tmp <= i_rdptr;
            i_wren_tmp <= i_wren_reg;
            i_data_tmp <= i_data_reg;
            i_q <= (lpm_showahead == "ON") ? i_q_tmp : i_q_reg;
        end
    end

    // FIFOram_aclr
    always @(i_aclr)
    begin
        if (i_aclr)
        begin
            i_data_reg <= 0;
            i_wrptr_reg <= 0;
            i_wren_reg <= 0;
            i_q_reg <= 0;
        end
    end

    // FIFOram_wrclock
    always @(posedge wrclock)
    begin
        if (!i_aclr && $time > 0)
        begin
            i_data_reg <= data;
            i_wrptr_reg <= i_wrptr;
            i_wren_reg <= i_wren;
        end
    end

    // FIFOram_rdclock
    always @(posedge rdclock)
    begin
        if (!i_aclr && i_rden && $time > 0)
            i_q_reg <= i_q_tmp;
    end

    // FIFOram_memory_read
    always @(i_rdptr_tmp)
        i_q_tmp <= mem_data[i_rdptr_tmp];

    // FIFOram_memory_write_eab
    always @(negedge wrclock)
    begin
        if (lpm_hint == "USE_EAB=ON")
        begin
            if (i_wren_tmp)
                mem_data[i_wrptr_tmp] = i_data_tmp;
            i_q_tmp = mem_data[i_rdptr_tmp];
        end
    end

    // FIFOram_memory_write_lcell
    always @(posedge wrclock)
    begin
        if (lpm_hint != "USE_EAB=ON")
        begin
            if (i_wren_tmp)
                mem_data[i_wrptr_tmp] = i_data_tmp;
            i_q_tmp = mem_data[i_rdptr_tmp];
        end
    end


    //---------
    // Counters
    //---------

    // rdptr
    always @(i_aclr)
        if (i_aclr)
            i_rdptr <= 0;
    always @(posedge rdclock)
        if (!i_aclr && i_rden && $time > 0)
            i_rdptr <= ((i_rdptr < (1<<lpm_widthu)-1) || (underflow_checking == "OFF"))
                        ? i_rdptr+1 : 0;

    // wrptr
    always @(i_aclr)
        if (i_aclr)
            i_wrptr <= 0;
    always @(posedge wrclock)
        if (!i_aclr && i_wren && $time > 0)
            i_wrptr <= ((i_wrptr < (1<<lpm_widthu)-1) || (overflow_checking == "OFF"))
                        ? i_wrptr+1 : 0;

    //-------------------
    // Delays & DFF Pipes
    //-------------------

    always @(negedge rdclock)  i_rdenclock <= 0;
    always @(posedge rdclock)  if (i_rden) i_rdenclock <= 1;

    lpm_fifo_dc_dffpipe RDPTR_D ( .d (i_rdptr), .q (w_rdptrrg),
                             .clock (i_rdenclock), .aclr (i_aclr) );
    lpm_fifo_dc_dffpipe WRPTR_D ( .d (i_wrptr), .q (w_wrdelaycycle),
                             .clock (wrclock), .aclr (i_aclr) );
    defparam
        RDPTR_D.lpm_delay = 0,
        RDPTR_D.lpm_width = lpm_widthu,
        WRPTR_D.lpm_delay = 1,
        WRPTR_D.lpm_width = lpm_widthu;

    lpm_fifo_dc_dffpipe WS_NBRP ( .d (w_rdptrrg), .q (w_ws_nbrp),
                             .clock (wrclock), .aclr (i_aclr) );
    lpm_fifo_dc_dffpipe RS_NBWP ( .d (w_wrdelaycycle), .q (w_rs_nbwp),
                             .clock (rdclock), .aclr (i_aclr) );
    lpm_fifo_dc_dffpipe WS_DBRP ( .d (w_ws_nbrp), .q (w_ws_dbrp),
                             .clock (wrclock), .aclr (i_aclr) );
    lpm_fifo_dc_dffpipe RS_DBWP ( .d (w_rs_nbwp), .q (w_rs_dbwp),
                             .clock (rdclock), .aclr (i_aclr) );   
    defparam
        WS_NBRP.lpm_delay = wrsync_delaypipe,
        WS_NBRP.lpm_width = lpm_widthu,
        RS_NBWP.lpm_delay = rdsync_delaypipe,
        RS_NBWP.lpm_width = lpm_widthu,
        WS_DBRP.lpm_delay = 1,              // gray_delaypipe
        WS_DBRP.lpm_width = lpm_widthu,
        RS_DBWP.lpm_delay = 1,              // gray_delaypipe
        RS_DBWP.lpm_width = lpm_widthu;

    always @(i_wrptr or w_ws_dbrp)
        i_wr_udwn = i_wrptr - w_ws_dbrp;

    always @(i_rdptr or w_rs_dbwp)
        i_rd_udwn = w_rs_dbwp - i_rdptr;

    lpm_fifo_dc_dffpipe WRUSEDW ( .d (i_wr_udwn), .q (w_wrusedw),
                             .clock (wrclock), .aclr (i_aclr) );
    lpm_fifo_dc_dffpipe RDUSEDW ( .d (i_rd_udwn), .q (w_rdusedw),
                             .clock (rdclock), .aclr (i_aclr) );
    lpm_fifo_dc_dffpipe WR_DBUW ( .d (i_wr_udwn), .q (w_wr_dbuw),
                             .clock (wrclock), .aclr (i_aclr) );
    lpm_fifo_dc_dffpipe RD_DBUW ( .d (i_rd_udwn), .q (w_rd_dbuw),
                             .clock (rdclock), .aclr (i_aclr) );
    defparam
        WRUSEDW.lpm_delay = delay_wrusedw,
        WRUSEDW.lpm_width = lpm_widthu,
        RDUSEDW.lpm_delay = delay_rdusedw,
        RDUSEDW.lpm_width = lpm_widthu,
        WR_DBUW.lpm_delay = 1,              // wrusedw_delaypipe
        WR_DBUW.lpm_width = lpm_widthu,
        RD_DBUW.lpm_delay = 1,              // rdusedw_delaypipe
        RD_DBUW.lpm_width = lpm_widthu;


    //-----------
    // Full/Empty
    //-----------

    lpm_fifo_dc_fefifo WR_FE ( .usedw_in (w_wr_dbuw), .wreq (wrreq), .rreq (rdreq),
                          .clock (wrclock), .aclr (i_aclr),
                          .empty (w_wrempty), .full (w_wrfull) );
    lpm_fifo_dc_fefifo RD_FE ( .usedw_in (w_rd_dbuw), .rreq (rdreq), .wreq(wrreq),
                          .clock (rdclock), .aclr (i_aclr),
                          .empty (w_rdempty), .full (w_rdfull) );

    defparam
        WR_FE.lpm_widthad = lpm_widthu,
        WR_FE.lpm_numwords = lpm_numwords,
        WR_FE.underflow_checking = underflow_checking,
        WR_FE.overflow_checking = overflow_checking,
        WR_FE.lpm_mode = "WRITE",
        RD_FE.lpm_widthad = lpm_widthu,
        RD_FE.lpm_numwords = lpm_numwords,
        RD_FE.underflow_checking = underflow_checking,
        RD_FE.overflow_checking = overflow_checking,
        RD_FE.lpm_mode = "READ";

    always @(w_wrfull)  i_wrfull = w_wrfull;
    always @(w_rdfull)  i_rdfull = w_rdfull;
    always @(w_wrempty)  i_wrempty = w_wrempty;
    always @(w_rdempty)  i_rdempty = w_rdempty;


    //--------
    // Outputs
    //--------

    assign q = i_q;
    assign wrfull = i_wrfull;
    assign rdfull = i_rdfull;
    assign wrempty = i_wrempty;
    assign rdempty = i_rdempty;
    assign wrusedw = w_wrusedw;
    assign rdusedw = w_rdusedw;

endmodule
// lpm_fifo_dc


