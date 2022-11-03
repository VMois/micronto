`timescale 1ns/1ns

module clock(clk, rst, en);
  input clk; 
  input rst; 
  output en;
  
  reg [13:0] Q; // enough to store 16384, we need 15999
  
  always @(posedge clk or negedge clk)
    begin
      if (rst | en) Q = 0;
      else if (clk) 
        Q = Q + 1;
    end
  
  // assign en = (Q == 16000);
  assign en = (Q == 4); // every 4th clock signal is outputed
 
endmodule