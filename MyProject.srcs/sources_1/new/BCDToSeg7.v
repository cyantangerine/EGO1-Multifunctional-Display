`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 09:51:14
// Design Name: 
// Module Name: BCDToSeg7
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


module BCDToSeg7_32bit(
    input [31:0]bcd,
    output reg [47:0]x
    );
    always @* begin
        x[47:0] = 48'b0;
        x[3:0] = bcd[3:0];
        x[9:6] = bcd[7:4];
        x[15:12] = bcd[11:8];
        x[21:18] = bcd[15:12];
        x[27:24] = bcd[19:16];
        x[33:30] = bcd[23:20];
        x[39:36] = bcd[27:24];
        x[45:42] = bcd[31:28];
    end
endmodule
