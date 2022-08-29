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
 
module lpm_ram_io(
dio,
inclock,
outclock,
we,
memenab,
outenab,
address
);
// synopsys template
parameter lpm_type = "lpm_ram_io";
	parameter lpm_width = 1;
	parameter lpm_widthad = 1;
	parameter lpm_numwords = 1<< lpm_widthad;
	parameter lpm_indata = "REGISTERED";
	parameter lpm_address_control = "REGISTERED";
	parameter lpm_outdata = "REGISTERED";
	parameter lpm_file = "UNUSED";
	parameter lpm_hint = "UNUSED";
	parameter use_eab = "OFF";
	parameter intended_device_family = "UNUSED";

	input  [lpm_widthad-1:0] address;
	input  inclock, outclock, we;
	input  memenab;
	input  outenab;
	inout  [lpm_width-1:0] dio;


	// inernal reg 
	reg  [lpm_width-1:0] mem_data [lpm_numwords-1:0];
	reg  [lpm_width-1:0] tmp_io;
	reg  [lpm_width-1:0] tmp_q;
	reg  [lpm_width-1:0] pdio;
	reg  [lpm_widthad-1:0] paddress;
	reg  pwe;
	reg  [lpm_width-1:0] ZEROS, ONES, UNKNOWN, HiZ;
	reg  [8*256:1] ram_initf;
	integer i;

	tri0 inclock;
	tri0 outclock;
        tri1 memenab;
        tri1 outenab;
			   
	  
	buf (i_inclock, inclock);
	buf (i_outclock, outclock);
	buf (i_memenab, memenab);
	buf (i_outenab, outenab);


//---------------------------------------------------------------//
	function ValidAddress;
		input [lpm_widthad-1:0] paddress;
		
		begin
			ValidAddress = 1'b0;
			if (^paddress ==='bx)
                             $display("%t:Error:  Invalid address.", $time);
                         else if (paddress >= lpm_numwords)
                             $display("%t:Error:  Address out of bound on RAM.", $time);
			else
				ValidAddress = 1'b1;
		end
	endfunction
//---------------------------------------------------------------//
		
	initial
	begin

		if (lpm_width <= 0)
                    $display("Error!  LPM_WIDTH parameter must be greater than 0.");

		if (lpm_widthad <= 0)
                    $display("Error!  LPM_WIDTHAD parameter must be greater than 0.");

		// check for number of words out of bound
		if ((lpm_numwords > (1 << lpm_widthad))
			||(lpm_numwords <= (1 << (lpm_widthad-1))))
		begin
                    $display("Error!  The ceiling of log2(LPM_NUMWORDS) must equal to LPM_WIDTHAD.");
		end

                if ((lpm_indata != "REGISTERED") && (lpm_indata != "UNREGISTERED")) 
                    $display("Error!  LPM_INDATA must be \"REGISTERED\" or \"UNREGISTERED\".");
			
                if ((lpm_address_control != "REGISTERED") && (lpm_address_control != "UNREGISTERED")) 
                    $display("Error!  LPM_ADDRESS_CONTROL must be \"REGISTERED\" or \"UNREGISTERED\".");
			
                if ((lpm_outdata != "REGISTERED") && (lpm_outdata != "UNREGISTERED")) 
                    $display("Error!  LPM_OUTDATA must be \"REGISTERED\" or \"UNREGISTERED\".");


		for (i=0; i < lpm_width; i=i+1)
		begin
			ZEROS[i] = 1'b0;
			ONES[i] = 1'b1;
			UNKNOWN[i] = 1'bX;
			HiZ[i] = 1'bZ;
		end 
			
		for (i = 0; i < lpm_numwords; i=i+1)
			mem_data[i] = ZEROS;

		// Initialize input/output 
		pwe <= 0;
		pdio <= 0;
		paddress <= 0;
		tmp_io = 0;
		tmp_q <= ZEROS;

		// load data to the RAM
		if (lpm_file != "UNUSED")
		begin
			$convert_hex2ver(lpm_file, lpm_width, ram_initf);
			$readmemh(ram_initf, mem_data);
		end
	end


	always @(dio)
	begin
        if (lpm_indata == "UNREGISTERED")
            pdio <=  dio;
	end
		
	always @(address)
	begin
        if (lpm_address_control == "UNREGISTERED")
            paddress <=  address;
	end
		
		
	always @(we)
	begin
        if (lpm_address_control == "UNREGISTERED")
            pwe <=  we;
	end
	
	always @(posedge i_inclock)
	begin
        if (lpm_indata == "REGISTERED")
            pdio <=  dio;

        if (lpm_address_control == "REGISTERED")
		begin
                    paddress <=  address;
                    pwe <=  we;
		end
	end

	always @(pdio or paddress or pwe or i_memenab)
	begin :block_a
		if (ValidAddress(paddress))
		begin
                    if (lpm_address_control == "UNREGISTERED")
		        if (pwe && i_memenab)
                            mem_data[paddress] <= pdio;

                    if (lpm_outdata == "UNREGISTERED")
                        tmp_q <= mem_data[paddress];
		end
		else
		begin
                    if (lpm_outdata == "UNREGISTERED")
                        tmp_q <= UNKNOWN;
		end
	end

        always @(negedge i_inclock or pdio)
	begin
        if (lpm_address_control == "REGISTERED")
                if ((use_eab == "ON") || (lpm_hint == "USE_EAB=ON"))
			if (pwe && i_memenab && (i_inclock == 0))
                            mem_data[paddress] = pdio;
	end

        always @(posedge i_inclock)
	begin
        if (lpm_address_control == "REGISTERED")
                if ((use_eab == "OFF") && pwe && i_memenab)
                            mem_data[paddress] <= pdio;
	end

	always @(posedge i_outclock)
	begin
        if (lpm_outdata == "REGISTERED")
            tmp_q <= mem_data[paddress];
	end

	always @(i_memenab or i_outenab or tmp_q)
	begin
		if (i_memenab && i_outenab)
                    tmp_io = tmp_q;
		else if (!i_memenab || (i_memenab && !i_outenab))
                    tmp_io = HiZ;
	end
 
	assign dio =  tmp_io;

endmodule
// lpm_ram_io


