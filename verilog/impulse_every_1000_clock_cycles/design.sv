`timescale 1ns/1ns

module every1000(clk, rst, en);

input clk;
input rst;
output en;

reg [9:0] cntr;

always @(posedge clk)
begin
    if (rst) cntr <= 0;
    else 
    begin
        if (en) cntr <= 1;
        else cntr <= cntr + 1;
    end
end

//assign en = (cntr == 1000);
assign en = (cntr == 4);
endmodule