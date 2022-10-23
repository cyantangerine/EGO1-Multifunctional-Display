`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 10:58:31
// Design Name: 
// Module Name: ClkDiv_1s
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


module ClkDivR_1s(
        input reset,
        input origin_clk,
        output new_clk
    );
    reg [27:0]clkdiv;
    reg [27:0]t1s = 28'd100000000;
    reg new_clk = 1'b0;
    initial clkdiv = 28'b0;
    always @(posedge origin_clk) begin
        if(reset) clkdiv = 0;
        if(clkdiv < t1s)
            clkdiv <= clkdiv+1;
        else begin
            clkdiv <= 28'b0;
            new_clk <= ~new_clk;
        end 
    end
endmodule
