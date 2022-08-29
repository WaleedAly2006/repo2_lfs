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
 
module lpm_ram_dq(
q,
data,
inclock,
outclock,
we,
address
);
// synopsys template
parameter lpm_type = "lpm_ram_dq";
  parameter lpm_width = 1;
  parameter lpm_widthad = 1;
  parameter lpm_numwords = 1 << lpm_widthad;
  parameter lpm_indata = "REGISTERED";
  parameter lpm_address_control = "REGISTERED";
  parameter lpm_outdata = "REGISTERED";
  parameter lpm_file = "UNUSED";
  parameter lpm_hint = "UNUSED";
  parameter use_eab = "OFF";
  parameter intended_device_family = "UNUSED";

  input  [lpm_width-1:0] data;
  input  [lpm_widthad-1:0] address;
  input  inclock, outclock, we;
  output [lpm_width-1:0] q;


  // internal reg 
  reg  [lpm_width-1:0] mem_data [lpm_numwords-1:0];
  reg  [lpm_width-1:0] tmp_q;
  reg  [lpm_width-1:0] pdata;
  reg  [lpm_width-1:0] in_data;
  reg  [lpm_widthad-1:0] paddress;
  reg  pwe;
  reg  [lpm_width-1:0]  ZEROS, ONES, UNKNOWN;
  reg  [8*256:1] ram_initf;
  integer i;

  tri0 inclock;
  tri0 outclock;

  buf (i_inclock, inclock);
  buf (i_outclock, outclock);

//---------------------------------------------------------------//
	function ValidAddress;
		input [lpm_widthad-1:0] paddress;

		begin
			ValidAddress = 1'b0;
			if (^paddress ==='bx)
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

		// Initialize the internal data register.
		pdata = 0;
		paddress = 0;
		pwe = 0;

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
                if ((lpm_indata != "REGISTERED") && (lpm_indata != "UNREGISTERED"))
                    $display("Error!  LPM_INDATA must be \"REGISTERED\" or \"UNREGISTERED\".");
                if ((lpm_outdata != "REGISTERED") && (lpm_outdata != "UNREGISTERED"))
                    $display("Error!  LPM_OUTDATA must be \"REGISTERED\" or \"UNREGISTERED\".");


		for (i=0; i < lpm_width; i=i+1)
		begin
			ZEROS[i] = 1'b0;
			ONES[i] = 1'b1;
			UNKNOWN[i] = 1'bX;
		end 
		
		for (i = 0; i < lpm_numwords; i=i+1)
			mem_data[i] = ZEROS;

		// load data to the RAM
		if (lpm_file != "UNUSED")
		begin
			$convert_hex2ver(lpm_file, lpm_width, ram_initf);
			$readmemh(ram_initf, mem_data);
		end 

                tmp_q = ZEROS;
	end

		
	always @(posedge i_inclock)
	begin
        if (lpm_address_control == "REGISTERED")
        begin
            if ((we) && (use_eab == "OFF")) 
            begin
                if (lpm_indata == "REGISTERED")
                    mem_data[address] <= data;
                else
                    mem_data[address] <= pdata;
            end
            paddress <= address;
            pwe <= we;
        end
        if (lpm_indata == "REGISTERED")
            pdata <= data;
	end

	always @(data)
	begin
        if (lpm_indata == "UNREGISTERED")
            pdata <= data;
	end
	
	always @(address)
	begin
        if (lpm_address_control == "UNREGISTERED")
            paddress <= address;
	end
	
	always @(we)
	begin
        if (lpm_address_control == "UNREGISTERED")
            pwe <= we;
	end
	
	always @(pdata or paddress or pwe)
	begin :unregistered_inclock
		if (ValidAddress(paddress))
		begin
                    if ((lpm_address_control == "UNREGISTERED") && (pwe))
                        mem_data[paddress] <= pdata;
		end
		else
		begin
                    if (lpm_outdata == "UNREGISTERED")
                        tmp_q <= UNKNOWN;
		end
	end

	always @(posedge i_outclock)
	begin
        if (lpm_outdata == "REGISTERED")
		begin
			if (ValidAddress(paddress))
                            tmp_q <= mem_data[paddress];
			else
                            tmp_q <= UNKNOWN;
		end
	end
 
        always @(negedge i_inclock or pdata)
	begin
        if ((lpm_address_control == "REGISTERED") && (pwe))
            if ((use_eab == "ON") || (lpm_hint == "USE_EAB=ON")) 
            begin
                if (i_inclock == 0) mem_data[paddress] = pdata;
            end
	end

    assign q = (lpm_outdata == "UNREGISTERED") ? mem_data[paddress] : tmp_q;

endmodule
// lpm_ram_dq


