//
// Module UART_V.status_registers.interface
//
// Created:
//          by - user.group (host.domain)
//          at - 13:03:34 4 Feb 2002
//
// Mentor Graphics' HDL Designer(TM)
//

module status_registers( 
   input   wire           clear_flags, 
   input   wire           clk, 
   input   wire           done_rcving, 
   input   wire           done_xmitting, 
   output  wire           int, 
   input   wire           rcving, 
   input   wire           rst, 
   output  wire    [7:0]  status, 
   input   wire           xmitting
);


// Internal Declarations
reg xmitting_reg, done_xmitting_reg, rcving_reg, done_rcving_reg;
localparam zeros = 4'b0000;          //V2k Localparam

always @(posedge clk, negedge rst)   //V2k comma-separated sensitivity list
   begin : status_registers_proc
      if( ~rst ) begin
         xmitting_reg <= 0;
         done_xmitting_reg <= 0;
         rcving_reg <= 0;
         done_rcving_reg <= 0;
      end
      else if( clear_flags ) begin
         xmitting_reg <= 0;
         done_xmitting_reg <= 0;
         rcving_reg <= 0;
         done_rcving_reg <= 0;
      end
      else begin
         xmitting_reg <= xmitting;
         rcving_reg <= rcving;
         if( done_xmitting==1 ) begin
            done_xmitting_reg <= done_xmitting;
         end
         if( done_rcving==1 ) begin
            done_rcving_reg <= done_rcving;
         end
      end
   end

   //Assert interrupt if transmitting or rcving complete
   assign int = (done_xmitting_reg || done_rcving_reg) ? 1 : 0;
   //Compose status registers
   assign status[7:4] = zeros;
   assign status[3] = done_rcving_reg;
   assign status[2] = done_xmitting_reg;
   assign status[1] = rcving_reg;
   assign status[0] = xmitting_reg;

endmodule





