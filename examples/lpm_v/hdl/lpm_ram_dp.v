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
 
module lpm_ram_dp(
q,
data,
wraddress,
rdaddress,
rdclock,
wrclock,
rdclken,
wrclken,
rden,
wren
);
// synopsys template
parameter lpm_type = "lpm_ram_dp";
	parameter lpm_width = 1;
	parameter lpm_widthad = 1;
	parameter lpm_numwords = 1<< lpm_widthad;
	parameter lpm_indata = "REGISTERED";
	parameter lpm_outdata = "REGISTERED";
	parameter lpm_rdaddress_control  = "REGISTERED";
	parameter lpm_wraddress_control  = "REGISTERED";
	parameter lpm_file = "UNUSED";
	parameter lpm_hint = "UNUSED";
	parameter use_eab = "OFF";
	parameter intended_device_family = "UNUSED";
	parameter rden_used = "TRUE";

	input  [lpm_width-1:0] data;
	input  [lpm_widthad-1:0] rdaddress, wraddress;
	input  rdclock, wrclock, rdclken, wrclken, rden, wren;
	output [lpm_width-1:0] q;

    // internal reg
    reg [lpm_width-1:0] mem_data [(1<<lpm_widthad)-1:0];
    reg [lpm_width-1:0] i_data_reg, i_data_tmp, i_q_reg, i_q_tmp;
    reg [lpm_width-1:0] ZEROS, ONES, UNKNOWN;
    reg [lpm_widthad-1:0] i_wraddress_reg, i_wraddress_tmp;
    reg [lpm_widthad-1:0] i_rdaddress_reg, i_rdaddress_tmp;
    reg [lpm_widthad-1:0] ZEROS_AD;
    reg i_wren_reg, i_wren_tmp, i_rden_reg, i_rden_tmp;
    reg [8*256:1] ram_initf;
    reg mem_updated;
    integer i, i_numwords;

    tri0 wrclock;
    tri1 wrclken;
    tri0 rdclock;
    tri1 rdclken;
    tri0 wren;
    tri1 rden;
			   
    buf (i_inclock, wrclock);
    buf (i_inclocken, wrclken);
    buf (i_outclock, rdclock);
    buf (i_outclocken, rdclken);
    buf (i_wren, wren);
    buf (i_rden, rden);

//---------------------------------------------------------------//
	function ValidAddress;
		input [lpm_widthad-1:0] paddress;
	
		begin
			ValidAddress = 1'b0;
            if (^paddress === 'bx)
                $display("%t:Error!  Invalid address.\n", $time);
			else if (paddress >= lpm_numwords)
                $display("%t:Error!  Address out of bound on RAM.\n", $time);
			else
				ValidAddress = 1'b1;
		end
	endfunction
//---------------------------------------------------------------//

	initial
	begin
        // Check for invalid parameters
        if (lpm_width < 1)
            $display("Error! lpm_width parameter must be greater than 0.");
        if (lpm_widthad < 1)
            $display("Error! lpm_widthad parameter must be greater than 0.");

        if ((lpm_indata != "REGISTERED") && (lpm_indata != "UNREGISTERED"))
            $display("Error! lpm_indata must be \"REGISTERED\" or \"UNREGISTERED\".");
        if ((lpm_outdata != "REGISTERED") && (lpm_outdata != "UNREGISTERED"))
            $display("Error! lpm_outdata must be \"REGISTERED\" or \"UNREGISTERED\".");
        if ((lpm_wraddress_control != "REGISTERED") && (lpm_wraddress_control != "UNREGISTERED"))
            $display("Error! lpm_wraddress_control must be \"REGISTERED\" or \"UNREGISTERED\".");
        if ((lpm_rdaddress_control != "REGISTERED") && (lpm_rdaddress_control != "UNREGISTERED"))
            $display("Error! lpm_rdaddress_control must be \"REGISTERED\" or \"UNREGISTERED\".");
				
        // Initialize constants
        for (i=0; i<lpm_width; i=i+1)
        begin
	    ZEROS[i] = 1'b0;
            ONES[i] = 1'b1;
            UNKNOWN[i] = 1'bx;
        end
        for (i=0; i<lpm_widthad; i=i+1)
            ZEROS_AD[i] = 1'b0;
				
        // Initialize mem_data
        i_numwords = (lpm_numwords) ? lpm_numwords : 1<<lpm_widthad;
        if (lpm_file == "UNUSED")
            for (i=0; i<i_numwords; i=i+1)
                mem_data[i] = ZEROS;
        else
		begin
                    $convert_hex2ver(lpm_file, lpm_width, ram_initf);
		    $readmemh(ram_initf, mem_data);
		end

        mem_updated = 0;

        // Initialize registers
        i_data_reg <= ZEROS;
        i_wraddress_reg <= ZEROS_AD;
        i_rdaddress_reg <= ZEROS_AD;
        i_wren_reg <= 0;
        if (rden_used == "TRUE")
            i_rden_reg <= 0;
        else
            i_rden_reg <= 1;

        // Initialize output
        i_q_reg = ZEROS;
        if ((use_eab == "ON") || (lpm_hint == "USE_EAB=ON"))
        begin
            if (intended_device_family == "APEX20K")
                i_q_tmp = ZEROS;
            else
                i_q_tmp = ONES;
        end
        else i_q_tmp = ZEROS;


	end


    //=========
    // Clocks
    //=========

    always @(posedge i_inclock)
	begin
        if (lpm_indata == "REGISTERED")
            if (i_inclocken == 1 && $time > 0)
                i_data_reg <= data;

        if (lpm_wraddress_control == "REGISTERED")
            if (i_inclocken == 1 && $time > 0)
            begin
                i_wraddress_reg <= wraddress;
                i_wren_reg <= i_wren;
            end

    end

    always @(posedge i_outclock)
	begin
        if (lpm_outdata == "REGISTERED")
            if (i_outclocken == 1 && $time > 0)
            begin
                i_q_reg <= i_q_tmp;
            end

        if (lpm_rdaddress_control == "REGISTERED")
            if (i_outclocken == 1 && $time > 0)
            begin
                i_rdaddress_reg <= rdaddress;
                i_rden_reg <= i_rden;
            end
    end


    //=========
    // Memory
    //=========

    always @(i_data_tmp or i_wren_tmp or i_wraddress_tmp or negedge i_inclock)
	begin
        if (i_wren_tmp == 1)
            if (ValidAddress(i_wraddress_tmp))
            begin
                if (((use_eab == "ON") || (lpm_hint == "USE_EAB=ON")) && (lpm_wraddress_control == "REGISTERED"))
                begin
                    if (i_inclock == 0)
                    begin
                        mem_data[i_wraddress_tmp] = i_data_tmp;
                        mem_updated <= ~mem_updated;
                    end
                end
                else
                begin
                        mem_data[i_wraddress_tmp] = i_data_tmp;
                        mem_updated <= ~mem_updated;
                end
            end
	end

    always @(i_rden_tmp or i_rdaddress_tmp or mem_updated)
	begin
        if (i_rden_tmp == 1)
                    i_q_tmp = (ValidAddress(i_rdaddress_tmp))
                        ? mem_data[i_rdaddress_tmp]
                        : UNKNOWN;
        else if ((intended_device_family == "APEX20K") && (use_eab == "ON"))
            i_q_tmp = 0;

	end


    //=======
    // Sync
    //=======

    always @(wraddress or i_wraddress_reg)
            i_wraddress_tmp = (lpm_wraddress_control == "REGISTERED")
                            ? i_wraddress_reg
                            : wraddress;
    always @(rdaddress or i_rdaddress_reg)
        i_rdaddress_tmp = (lpm_rdaddress_control == "REGISTERED")
                            ? i_rdaddress_reg
                            : rdaddress;
    always @(i_wren or i_wren_reg)
        i_wren_tmp = (lpm_wraddress_control == "REGISTERED")
                       ? i_wren_reg
                       : i_wren;
    always @(i_rden or i_rden_reg)
        i_rden_tmp = (lpm_rdaddress_control == "REGISTERED")
                       ? i_rden_reg
                       : i_rden;
    always @(data or i_data_reg)
        i_data_tmp = (lpm_indata == "REGISTERED")
                       ? i_data_reg
                       : data;

    assign q = (lpm_outdata == "REGISTERED") ? i_q_reg : i_q_tmp;

endmodule
// lpm_ram_dp


