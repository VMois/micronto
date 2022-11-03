`timescale 1ns/1ns

module shiftreg(clk, rst, en, load, shr);
  input clk; 
  input rst; 
  input en;
  input [3:0] load;
  
  output [3:0] shr;
  reg [3:0] shr;
  
  always @(posedge clk)
    begin
      if (rst) shr <= load;
      else if (en) begin
        shr[3] <= 0;
        shr[2] <= shr[3];
        shr[1] <= shr[2];
        shr[0] <= shr[1];
      end
    end
 
endmodule
