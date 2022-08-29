// Test Bench and Tester for Verilog Calculator Design

// Tester

`resetall
`timescale 1ns/10ps

module Calc_tester( 
   DataReady, 
   Z, 
   A, 
   B, 
   Clk, 
   OpCode, 
   Rst, 
   OpCodeValid, 
   Initializing
);


// Internal Declarations

input        DataReady;
input  [4:0] Z;
output [4:0] A;
output [4:0] B;
output       Clk;
output [1:0] OpCode;
output       Rst;
output       OpCodeValid;
input        Initializing;


wire DataReady;
wire [4:0] Z;
reg [4:0] A;
reg [4:0] B;
reg Clk;
reg [1:0] OpCode;
reg Rst;
reg OpCodeValid;
wire Initializing;

initial
begin
	A[4:0] = 5'b00100;
  #2000	A[4:0] = 5'b00101;
end

initial
begin
	B[4:0] = 5'b00011;
  #2000	B[4:0] = 5'b00010;
end

initial
begin
// Binary Counter Stimulus Generator
	OpCode[1:0] = 2'b00; // Rotate
  #400	OpCode[1:0] = 2'b01; // A+B
  #400	OpCode[1:0] = 2'b10; // A-B
  #400	OpCode[1:0] = 2'b11; // A*B
  #400	OpCode[1:0] = 2'b00; // X
  #400	OpCode[1:0] = 2'b01; // X
  #400	OpCode[1:0] = 2'b10; // X
  #400	OpCode[1:0] = 2'b11; // X
end

// Clock Stimulus Generator
always
begin
	Clk = 0;
  #25	Clk = 1;
  #50	Clk = 0;
  #25	Clk = 0;
end

initial
begin
// Pulse Stimulus Generator
	Rst = 0;
  #40	Rst = 1;
  #20	Rst = 0;
end

// time-ordered stimulus vector section
initial
begin
	OpCodeValid = 0;
  #110	OpCodeValid = 1;
  #200	OpCodeValid = 0;
  #180	OpCodeValid = 1;
  #110	OpCodeValid = 0;
  #300	OpCodeValid = 1;
  #60	OpCodeValid = 0;
  #300	OpCodeValid = 1;
  #90	OpCodeValid = 0;
  #800	OpCodeValid = 1;
  #200	OpCodeValid = 0;
  #180	OpCodeValid = 1;
  #110	OpCodeValid = 0;
  #300	OpCodeValid = 1;
  #60	OpCodeValid = 0;
  #300	OpCodeValid = 1;
  #90	OpCodeValid = 0;
end
endmodule


// Test Bench
`resetall
`timescale 1ns/10ps

module Calc_tb;

// Local declarations

// Internal signal declarations
wire [4:0] A;
wire [4:0] B;
wire       Clk;
wire       DataReady;
wire       Initializing;
wire [1:0] OpCode;
wire       OpCodeValid;
wire       Rst;
wire [4:0] Z;


// Instances 
Calc_tester I1( 
   .DataReady    (DataReady), 
   .Z            (Z), 
   .A            (A), 
   .B            (B), 
   .Clk          (Clk), 
   .OpCode       (OpCode), 
   .Rst          (Rst), 
   .OpCodeValid  (OpCodeValid), 
   .Initializing (Initializing)
); 

Calc_Top I0( 
   .A            (A), 
   .B            (B), 
   .Z            (Z), 
   .DataReady    (DataReady), 
   .OpCode       (OpCode), 
   .OpCodeValid  (OpCodeValid), 
   .Initializing (Initializing), 
   .Clk          (Clk), 
   .Rst          (Rst)
); 

endmodule // Calc_tb

