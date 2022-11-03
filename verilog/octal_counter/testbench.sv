`timescale 1ns/1ns  // time-unit = 1 ns, precision = 10 ps

module octal_counter_tb;
  reg clk;
  reg rst;
  reg en;
  wire [2:0] cntr;
  wire cy;

  octal_counter UUT (.clk(clk), .rst(rst), .en(en), .cntr(cntr), .cy(cy));
  
  always #1 clk <= ~clk;
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1);
      
      clk = 0;
      rst = 1;
      en = 0;
      
      #1 rst <= 0;
      #1 en <= 1;
      #12 en <= 0;
      $finish;
    end
endmodule
