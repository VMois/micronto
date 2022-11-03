`timescale 1ns/1ns

module octal_counter(clk, rst, en, cntr, cy);
    input clk;
    input rst;
    input en;

    output cy;
    output [2:0] cntr;
    reg [2:0] cntr;

    reg [2:0] prev_cntr;
    

    always @(posedge clk)
    begin
        if (rst) 
        begin
            cntr <= 0;
            prev_cntr <= 0;
        end
        else if (en) 
        begin
            prev_cntr <= cntr;
            cntr <= cntr + 1;
        end
    end

    assign cy = (cntr == 0) & (prev_cntr == 7);
endmodule