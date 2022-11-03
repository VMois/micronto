`timescale 1ns/1ns  // time-unit = 1 ns, precision = 10 ps

module adder_tb;
  reg [3:0] a, b;
  wire [3:0] y;
  
  reg clk;
  reg rst;
  reg en;
  reg [3:0] load;
  
  wire [3:0] shr;


  // duration for each bit = 20 * timescale = 20 * 1 ns  = 20ns
  localparam period = 1;  

  shiftreg UUT (.clk(clk), .rst(rst), .en(en), .load(load), .shr(shr));
  
  always #2 clk <= ~clk;
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1);
      
      clk = 0;
      rst = 1;
      en = 0;
      load = 4'b0111;
      
      #4 rst <= 0;
      #1 en <= 1;
      #4;
      #2 en <= 0;
      $finish;
    end
endmodule
