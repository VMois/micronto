`timescale 1ns/1ns  // time-unit = 1 ns, precision = 10 ps

module clock_tb;
  reg clk;
  reg rst;
  wire en;

  every1000 UUT (.clk(clk), .rst(rst), .en(en));
  
  always #1 clk <= ~clk;
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1);
      
      clk = 0;
      rst = 1;
      
      #2 rst <= 0;
      #20
      $finish;
    end
endmodule
