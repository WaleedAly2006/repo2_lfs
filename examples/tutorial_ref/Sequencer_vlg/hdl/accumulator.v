//
// Module Sequencer_vlg.accumulator.spec
//
// Created:
//          by - user.group (host.domain)
//          at - 13:01:10 16/09/99
//
// External Declarations

`resetall
`timescale 1ns/10ps
module accumulator( 
   clock, 
   clr, 
   inc, 
   ip, 
   ld, 
   op
);

// Internal Declarations

input        clock;
input        clr;
input        inc;
input  [7:0] ip;
input        ld;
output [7:0] op;


wire [7:0] ip;
wire ld;
wire clr;
wire inc;
wire clock;
reg [7:0] op;

// Local declarations
 

///////////////////////////////////////////////////////////////////////////
always @ (posedge clock) begin
   // Asynchronous Reset
   if(clr) begin
      // Reset Actions
      op = 0;
      end
   else begin

      // Block 1
      if ((ld == 1))
         op = ip;
      else if ((inc == 1))
         op = op+1;
      else
         op = op;
   end
end

endmodule // accumulator
