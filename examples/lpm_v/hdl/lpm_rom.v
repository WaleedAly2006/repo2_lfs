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
 
module lpm_rom(
q,
inclock,
outclock,
memenab,
address
);
// synopsys template
parameter lpm_type = "lpm_rom";
	parameter lpm_width = 1;
	parameter lpm_widthad = 1;
        parameter lpm_numwords = 1 << lpm_widthad;
	parameter lpm_address_control = "REGISTERED";
	parameter lpm_outdata = "REGISTERED";
        parameter lpm_file = "";
	parameter lpm_hint = "UNUSED";
	parameter intended_device_family = "UNUSED";

	input  [lpm_widthad-1:0] address;
	input  inclock, outclock;
	input  memenab;
	output [lpm_width-1:0] q;


	// inernal reg 
	reg  [lpm_width-1:0] mem_data [lpm_numwords-1:0];
	reg  [lpm_widthad-1:0] paddress;
	reg  [lpm_width-1:0] tmp_q;
	reg  [lpm_width-1:0] tmp_q_reg;
	reg  [lpm_width-1:0] ZEROS, UNKNOWN, HiZ;
	reg  [8*256:1] rom_initf;
	integer i;

	tri0 inclock;
	tri0 outclock;
	tri1 memenab;

	buf (i_inclock, inclock);
	buf (i_outclock, outclock);
	buf (i_memenab, memenab);


//---------------------------------------------------------------//
	function ValidAddress;
		input [lpm_widthad-1:0] address;
		begin
			ValidAddress = 1'b0;
			if (^address =='bx)
                            $display("%d:Error:  Invalid address.", $time);
			else if (address >= lpm_numwords)
                            $display("%d:Error:  Address out of bound on ROM.", $time);
			else
				ValidAddress = 1'b1;
		end
	endfunction
//---------------------------------------------------------------//
		
	initial     
	begin
		// Initialize output
		tmp_q <= 0;
		tmp_q_reg <= 0;
		paddress <= 0;
 
		if (lpm_width <= 0)
                    $display("Error!  LPM_WIDTH parameter must be greater than 0.");
	 
		if (lpm_widthad <= 0)
                    $display("Error!  LPM_WIDTHAD parameter must be greater than 0.");        
		 
		// check for number of words out of bound
		if ((lpm_numwords > (1 << lpm_widthad))
			||(lpm_numwords <= (1 << (lpm_widthad-1))))
                    $display("Error!  The ceiling of log2(LPM_NUMWORDS) must equal to LPM_WIDTHAD.");

                if ((lpm_address_control != "REGISTERED") && (lpm_address_control != "UNREGISTERED"))
                    $display("Error!  LPM_ADDRESS_CONTROL must be \"REGISTERED\" or \"UNREGISTERED\".");

                if ((lpm_outdata != "REGISTERED") && (lpm_outdata != "UNREGISTERED"))
                    $display("Error!  LPM_OUTDATA must be \"REGISTERED\" or \"UNREGISTERED\".");

		 
		for (i=0; i < lpm_width; i=i+1)
		begin
			ZEROS[i] = 1'b0;
			UNKNOWN[i] = 1'bX;
			HiZ[i] = 1'bZ;
		end 
			
		for (i = 0; i < lpm_numwords; i=i+1)
			mem_data[i] = ZEROS;

		// load data to the ROM
                if (lpm_file == "" || lpm_file == "UNUSED")
                    $display("Error!  LPM_ROM must have data file for initialization.\n");
                else
		begin
			$convert_hex2ver(lpm_file, lpm_width, rom_initf);
			$readmemh(rom_initf, mem_data);
		end
	end

	always @(posedge i_inclock)
	begin
        if (lpm_address_control == "REGISTERED")
            paddress <=  address;
	end
 
	always @(address)
	begin
        if (lpm_address_control == "UNREGISTERED")
            paddress <=  address;
	end
				   
	always @(paddress)
	begin 
		if (ValidAddress(paddress))
		begin
                    if (lpm_outdata == "UNREGISTERED")
                        tmp_q_reg <=  mem_data[paddress];
		end
		else
		begin
                    if (lpm_outdata == "UNREGISTERED")
                        tmp_q_reg <= UNKNOWN;
		end
	end

	always @(posedge i_outclock)
	begin
        if (lpm_outdata == "REGISTERED")
		begin
			if (ValidAddress(paddress))
                            tmp_q_reg <=  mem_data[paddress];
			else
                            tmp_q_reg <= UNKNOWN;
		end
	end
 
	
	always @(i_memenab or tmp_q_reg)
        begin
            tmp_q <= (i_memenab) ? tmp_q_reg : HiZ;
        end
	 
	assign q = tmp_q;

endmodule
// lpm_rom


