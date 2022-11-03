`timescale 1ns/1ns

module shiftreg(clk, rst, en, load, shr);
  input clk; 
  input rst; 
  input en;
  input [5:0] load;
  
  output [5:0] shr;
  reg [5:0] shr;
  
  always @(posedge clk)
    begin
      if (rst) shr <= load;
      else if (en) begin
        // shr[5] <= shr[4];
        // shr[4] <= shr[3];
        // shr[3] <= shr[2];
        // shr[2] <= shr[1];
        // shr[1] <= shr[0];
        // shr[0] <= 0;
        shr <= {shr[4:0], 1'b0}
      end
    end
 
endmodule
