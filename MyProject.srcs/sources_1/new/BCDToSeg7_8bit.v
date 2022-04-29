`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 10:09:15
// Design Name: 
// Module Name: BCDToSeg7_8bit
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


module BCDToSeg7_8bit(
    input [7:0]bcd,
    output reg [11:0]x
    );
    always @* begin
        x[11:0] = 12'b0;
        x[3:0] = bcd[3:0];
        x[9:6] = bcd[7:4];
    end
endmodule
