// Verilog code for Calculator Controller, Counter and Decoder design units

// Controller state machine

`timescale 1ns/1ns

module Controller( 
   Clk, 
   Rst, 
   Add, 
   Subtract, 
   Multiply, 
   CommandValid, 
   MultiplyDone, 
   Initializing, 
   DataReady, 
   SelectInput, 
   SelectB, 
   AccLoad, 
   AccAdd
);


// Internal Declarations

input   Clk;
input   Rst;
input   Add;
input   Subtract;
input   Multiply;
input   CommandValid;
input   MultiplyDone;
output  Initializing;
output  DataReady;
output  SelectInput;
output  SelectB;
output  AccLoad;
output  AccAdd;


wire Clk;
wire Rst;
wire Add;
wire Subtract;
wire Multiply;
wire CommandValid;
wire MultiplyDone;
reg Initializing;
reg DataReady;
reg SelectInput;
reg SelectB;
reg AccLoad;
reg AccAdd;

// Start body of module Controller

reg DataReady_int ;

// State encoding
parameter [2:0] // pragma enum ControllerState_code
   sINIT = 3'd0 ,
   sNOOP = 3'd1 ,
   sADD = 3'd2 ,
   sSUBTRACT = 3'd3 ,
   sMULTIPLY = 3'd4 ,
   sRES = 3'd5 ;

reg [2:0] /* pragma enum ControllerState_code */ ControllerState, NextControllerState ;
// pragma state_vector ControllerState

//----------------------------------------------------------------------------
// Next State Block for machine ControllerState
//----------------------------------------------------------------------------
always  @(
   Add or 
   CommandValid or 
   ControllerState or 
   Multiply or 
   MultiplyDone or 
   Subtract) 
begin
   // Default Assignment
   AccAdd = 0;
   AccLoad = 0;
   DataReady_int = 0;
   Initializing = 0;
   SelectB = 0;
   SelectInput = 0;

   // State Actions
   case (ControllerState)
      sINIT: begin
         Initializing = 1;
      end
      sNOOP: begin
         SelectInput = 0; 
         SelectB = 0;
         AccLoad = 1;
      end
      sADD: begin
         SelectInput = 1;
         SelectB = 1;
         AccLoad = 0;
         AccAdd = 1;
      end
      sSUBTRACT: begin
         SelectInput = 1;
         SelectB = 1;
         AccLoad = 0;
         AccAdd = 0;
      end
      sMULTIPLY: begin
         SelectInput = 1;
         SelectB = 0;
         AccLoad = 0;
      end
      sRES: begin
         Initializing = 1;
      end
   endcase

   case (ControllerState)
      sINIT:
            NextControllerState = sNOOP;
      sNOOP:
         if ((CommandValid) && (Add))
         begin
            SelectInput = 1;
            NextControllerState = sADD;
         end
         else if ((CommandValid) && (Subtract))
         begin
            SelectInput = 1;
            NextControllerState = sSUBTRACT;
         end
         else if ((CommandValid) && (Multiply))
         begin
            SelectInput = 1;
            NextControllerState = sMULTIPLY;
         end
         else if (~ CommandValid)
         begin
            SelectInput = 0;
            NextControllerState = sNOOP;
         end
         else
            NextControllerState = sNOOP;
      sADD:
         begin
            DataReady_int = 1;
            NextControllerState = sNOOP;
         end
      sSUBTRACT:
         begin
            DataReady_int = 1;
            NextControllerState = sNOOP;
         end
      sMULTIPLY:
         if (MultiplyDone)
         begin
            AccAdd = 0;
            DataReady_int = 1;
            NextControllerState = sNOOP;
         end
         else if (~ MultiplyDone)
         begin
            AccAdd = 1;
            NextControllerState = sMULTIPLY;
         end
         else
            NextControllerState = sMULTIPLY;
      sRES:
            NextControllerState = sINIT;
      default: begin
         NextControllerState = sRES;
      end
   endcase

end // Next State Block

//----------------------------------------------------------------------------
// Clocked Block for machine ControllerState
//----------------------------------------------------------------------------
always @(
   posedge Clk or posedge Rst
) begin
   if (Rst) begin
      ControllerState = sRES;
      // Reset Values
      DataReady = 0;
   end
   else begin
      ControllerState = NextControllerState;
      // Registered output assignments
      DataReady = DataReady_int;
   end
end // Clocked Block

endmodule // Controller


// Counter module

`timescale 1ns/1ns
       
module Counter( 
   Clk, 
   Initializing, 
   AccLoad, 
   B, 
   MultiplyDone
);

// Internal Declarations

input        Clk;
input        Initializing;
input        AccLoad;
input  [4:0] B;
output        MultiplyDone;

wire Clk;
wire Initializing;
wire AccLoad;
wire [4:0] B;
wire MultiplyDone;

wire	[4:0]	TmpCount;
reg	[4:0]	Count;
          
always @ (posedge Clk or posedge Initializing)
begin
  if (Initializing)
    Count = 0;
  else
    Count = TmpCount;
end

assign TmpCount = AccLoad ? B
                          : (MultiplyDone ? Count
                                       : (Count - 1));
assign MultiplyDone = (Count == 0);

endmodule


// Decoder module

`timescale 1ns/1ns

module Decoder( 
   OpCode, 
   OpCodeValid, 
   CommandValid, 
   Add, 
   Subtract, 
   Multiply, 
   Clk, 
   Rst
);


// Internal Declarations

input  [1:0] OpCode;
input        OpCodeValid;
output       CommandValid;
output       Add;
output       Subtract;
output       Multiply;
input        Clk;
input        Rst;

wire [1:0] OpCode;
wire OpCodeValid;
reg CommandValid;
reg Add;
reg Subtract;
reg Multiply;
wire Clk;
wire Rst;

// Start body of module Decoder

always @ (posedge Clk or posedge Rst) begin
   // Asynchronous Reset
   if(Rst) begin
      // Reset Actions
      CommandValid = 0;
      Add = 0;
      Subtract = 0;
      Multiply = 0;
      end
   else begin

      // Global Actions
      CommandValid = 0;
      Add = 0;
      Subtract = 0;
      Multiply = 0;


      // Block 1
      if ((OpCode == 2'b00) && (OpCodeValid == 1))
         CommandValid = 1;
      else if ((OpCode == 2'b01) && (OpCodeValid == 1))
         begin
            CommandValid = 1;
            Add = 1;
         end
      else if ((OpCode == 2'b10) && (OpCodeValid == 1))
         begin
            CommandValid = 1;
            Subtract = 1;
         end
      else if ((OpCode == 2'b11) && (OpCodeValid == 1))
         begin
            CommandValid = 1;
            Multiply = 1;
         end
   end
end

endmodule // Decoder
