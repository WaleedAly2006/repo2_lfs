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
module lpm_clshift(
result,
overflow,
underflow,
data,
direction,
distance
);
// synopsys template
parameter lpm_type = "lpm_clshift";
	parameter lpm_width = 1;
	parameter lpm_widthdist = 1;
	parameter lpm_shifttype = "LOGICAL";
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	input  [lpm_widthdist-1:0] distance;
	input  direction;
	output [lpm_width-1:0] result;
	output overflow;
	output underflow;


	reg    [lpm_width-1:0] ONES;
	reg    [lpm_width-1:0] result;
	reg    overflow, underflow;
	integer i;

	tri0  direction;

	buf (i_direction, direction);

//---------------------------------------------------------------//
	function [lpm_width+1:0] LogicShift;
		input [lpm_width-1:0] data;
		input [lpm_widthdist-1:0] dist;
		input direction;
		reg   [lpm_width-1:0] tmp_buf;
		reg   overflow, underflow;
				
		begin
			tmp_buf = data;
			overflow = 1'b0;
			underflow = 1'b0;
			if ((direction) && (dist > 0)) // shift right
			begin
				tmp_buf = data >> dist;
				if ((data != 0) && ((dist >= lpm_width) || (tmp_buf == 0)))
					underflow = 1'b1;
			end
			else if (dist > 0) // shift left
			begin
				tmp_buf = data << dist;
				if ((data != 0) && ((dist >= lpm_width)
					|| ((data >> (lpm_width-dist)) != 0)))
					overflow = 1'b1;
			end
			LogicShift = {overflow,underflow,tmp_buf[lpm_width-1:0]};
		end
	endfunction

//---------------------------------------------------------------//
	function [lpm_width+1:0] ArithShift;
		input [lpm_width-1:0] data;
		input [lpm_widthdist-1:0] dist;
		input direction;
		reg   [lpm_width-1:0] tmp_buf;
		reg   overflow, underflow;
		
		begin
			tmp_buf = data;
			overflow = 1'b0;
			underflow = 1'b0;

			if (direction && (dist > 0))   // shift right
			begin
				if (data[lpm_width-1] == 0) // positive number
				begin
					tmp_buf = data >> dist;
					if ((data != 0) && ((dist >= lpm_width) || (tmp_buf == 0)))
						underflow = 1'b1;
				end
				else // negative number
				begin
					tmp_buf = (data >> dist) | (ONES << (lpm_width - dist));
					if ((data != ONES) && ((dist >= lpm_width-1) || (tmp_buf == ONES)))
						underflow = 1'b1;
				end
			end
			else if (dist > 0) // shift left
			begin
				tmp_buf = data << dist;
				if (data[lpm_width-1] == 0) // positive number
				begin
					if ((data != 0) && ((dist >= lpm_width-1) 
					|| ((data >> (lpm_width-dist-1)) != 0)))
						overflow = 1'b1;
				end
				else // negative number
				begin
					if ((data != ONES) && ((dist >= lpm_width) 
					|| (((data >> (lpm_width-dist-1))|(ONES << (dist+1))) != ONES)))
						overflow = 1'b1;
				end
			end
			ArithShift = {overflow,underflow,tmp_buf[lpm_width-1:0]};
		end
	endfunction

//---------------------------------------------------------------//
    function [lpm_width+1:0] RotateShift;
        input [lpm_width-1:0] data;
		input [lpm_widthdist-1:0] dist;
		input direction;
		reg   [lpm_width-1:0] tmp_buf;
		
		begin
			tmp_buf = data;
			if ((direction) && (dist > 0)) // shift right
				tmp_buf = (data >> dist) | (data << (lpm_width - dist));
			else if (dist > 0) // shift left
				tmp_buf = (data << dist) | (data >> (lpm_width - dist));
            RotateShift = {2'bx, tmp_buf[lpm_width-1:0]};
		end
	endfunction
//---------------------------------------------------------------//

	initial
	begin
        if (lpm_shifttype != "LOGICAL" &&
            lpm_shifttype != "ARITHMETIC" &&
            lpm_shifttype != "ROTATE" &&
            lpm_shifttype != "UNUSED")          // non-LPM 220 standard
            $display("Error!  LPM_SHIFTTYPE value must be \"LOGICAL\", \"ARITHMETIC\", or \"ROTATE\".");

		for (i=0; i < lpm_width; i=i+1)
			ONES[i] = 1'b1;
	end

	always @(data or i_direction or distance)
	begin
        if ((lpm_shifttype == "LOGICAL") || (lpm_shifttype == "UNUSED"))
            {overflow, underflow, result} = LogicShift(data, distance, i_direction);
		else if (lpm_shifttype == "ARITHMETIC")
            {overflow, underflow, result} = ArithShift(data, distance, i_direction);
		else if (lpm_shifttype == "ROTATE")
            {overflow, underflow, result} = RotateShift(data, distance, i_direction);
	end

endmodule
// lpm_clshift


