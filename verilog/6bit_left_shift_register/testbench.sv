`timescale 1ns/1ns  // time-unit = 1 ns, precision = 10 ps

module adder_tb;
  reg clk;
  reg rst;
  reg en;
  reg [5:0] load;
  
  wire [5:0] shr;

  shiftreg UUT (.clk(clk), .rst(rst), .en(en), .load(load), .shr(shr));
  
  always #1 clk <= ~clk;
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1);
      
      clk = 0;
      rst = 1;
      en = 0;
      load = 6'b000111;
      
      #2 rst <= 0;
      #1 en <= 1;
      #10;
      #1 en <= 0;

      load = 6'b101100;
      rst <= 1;
      #2 rst <= 0;
      #1 en <= 1;
      #3 en <= 0;
      #1;
      $finish;
    end
endmodule
