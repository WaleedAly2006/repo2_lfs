// Tester design unit

module fibgen_tester( 
   monitor, 
   clock, 
   reset
);

// Internal Declarations

input  [7:0] monitor;
output       clock;
output       reset;


reg clock;
wire [7:0] monitor;
reg reset;

// Flowchart
always @ (monitor)
begin : Checker
   if (monitor > 128) begin
      reset = 1 ;
   end
   else begin
      reset = 0 ;
   end
end

// Clock Generator
initial
  begin : ClkGen
  parameter clk_prd = 100 ;
  clock = 0 ;
  reset = 1 ;
  forever #(clk_prd/2)clock = ~clock ;
end

endmodule
