// Verilog Test Bench for Fibonacci Sequencer 

module fibgen_tb;

// Internal signal declarations
wire        clock;
wire [7:0]  monitor;
wire        reset;

// Instances 
fibgen UUT( 
   .clock  (clock), 
   .fibout (monitor), 
   .reset  (reset)
); 

fibgen_tester Checker( 
   .monitor (monitor), 
   .clock  (clock), 
   .reset  (reset)
); 

endmodule

