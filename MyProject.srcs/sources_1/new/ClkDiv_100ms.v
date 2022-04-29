`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/30 13:44:55
// Design Name: 
// Module Name: ClkDiv_100ms
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ClkDiv_100ms(
        input origin_clk,
        output new_clk
    );
    reg [26:0]clkdiv;
    reg [26:0]t1s = 26'd10000000;
    reg new_clk = 0;
    initial clkdiv = 26'b0;
    always @(posedge origin_clk) begin
        if(clkdiv < t1s)
            clkdiv <= clkdiv+1;
        else begin
            clkdiv <= 26'b0;
            new_clk <= ~new_clk;
        end 
    end
endmodule
