// Verilog Fibonacci Sequencer Design

// fibgen design unit

module fibgen( 
   clock, 
   reset, 
   fibout
);

// Internal Declarations

input        clock;
input        reset;
output [7:0] fibout;

wire        clock;
wire [7:0]  fibout;
wire        reset;

// Internal signal declarations
wire [7:0]  A;
wire [7:0]  B;
wire        clr;
wire        gnd;
wire        inc;
wire        ld_A_B;
wire        ld_sum;
wire [7:0]  sum;

// Instances 
accumulator acc_A( 
   .ip    (fibout), 
   .ld    (ld_A_B), 
   .clr   (clr), 
   .inc   (gnd), 
   .clock (clock), 
   .op    (A)
); 

accumulator acc_B( 
   .ip    (A), 
   .ld    (ld_A_B), 
   .clr   (clr), 
   .inc   (inc), 
   .clock (clock), 
   .op    (B)
); 

accumulator acc_sum( 
   .ip    (sum), 
   .ld    (ld_sum), 
   .clr   (clr), 
   .inc   (gnd), 
   .clock (clock), 
   .op    (fibout)
); 

control FSM( 
   .clr    (clr), 
   .inc    (inc),
   .ld_A_B (ld_A_B), 
   .ld_sum (ld_sum),   
   .reset  (reset), 
   .clock  (clock)
); 

// Add signal A and B together
assign sum = A + B ;

// Tie signal gnd to ground
assign gnd = 0 ;

endmodule 


// accumulator design unit

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

 
always @ (posedge clock) begin
   // Asynchronous Reset
   if(clr) begin
      // Reset Actions
      op = 0;
      end
   else begin
      if ((ld == 1))
         op = ip;
      else if ((inc == 1))
         op = op+1;
      else
         op = op;
   end
end

endmodule

// control design unit

module control( 
   clock, 
   reset, 
   clr, 
   inc, 
   ld_A_B, 
   ld_sum
);

// Internal Declarations

input   clock;
input   reset;
output  clr;
output  inc;
output  ld_A_B;
output  ld_sum;

wire clock;
reg clr;
reg inc;
reg ld_A_B;
reg ld_sum;
wire reset;

// Module Declarations
// State encoding
parameter [1:0] // synopsys enum current_state_code
   clr_regs = 2'd0 ,
   inc_accb = 2'd1 ,
   load_acc_sum = 2'd2 ,
   load_acc_A_B = 2'd3 ;

reg [1:0] /* synopsys enum current_state_code */ current_state, next_state ;

// synopsys state_vector current_state

// Determine next state for machine machine0
always  @(
   current_state) 
begin
   next_state = clr_regs;
   case (current_state)
      clr_regs:
            next_state = inc_accb;
      inc_accb:
            next_state = load_acc_sum;
      load_acc_sum:
            next_state = load_acc_A_B;
      load_acc_A_B:
            next_state = load_acc_sum;
   endcase
end 

// Determine output for machine machine0
always  @(
   current_state) 
begin
   // Default Assignment
   clr = 0;
   inc = 0;
   ld_A_B = 0;
   ld_sum = 0;

   // State Actions
   case (current_state)
      clr_regs: begin
         clear = 1 ; // Deliberate error, signal is declared as clr
         inc = 0 ;
         ld_A_B = 0 ;
         ld_sum = 0 ;
      end
      inc_accb: begin
         clear = 0 ; // Deliberate error, signal is declared as clr
         inc = 1 ;
      end
      load_acc_sum: begin
         inc = 0 ;
         ld_A_B = 0 ;
         ld_sum = 1 ;
      end
      load_acc_A_B: begin
         ld_A_B = 1 ;
         ld_sum = 0 ;
      end
   endcase

end

// Clocked assignments for machine machine0
always @(
   posedge clock or posedge reset
) begin
   if (reset) begin
      current_state <= clr_regs;
      // Reset Values
   end
   else begin
      current_state <= next_state;
      // Default Assignment To Internals
   end

end

endmodule

