`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 09:31:31
// Design Name: 
// Module Name: BinToBCD
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


module BinToBCD_32bit(
    input [31:0]bin,output reg[31:0] bcd
    );
    reg [31:0]binin;
    always @bin begin
        binin = bin;
        bcd[3:0] = binin%10;
        binin = binin / 10;
        bcd[7:4] = binin%10;
        binin = binin / 10;
        bcd[11:8] = binin%10;
        binin = binin / 10;
        bcd[15:12] = binin%10;
        binin = binin / 10;
        bcd[19:16] = binin%10;
        binin = binin / 10;
        bcd[23:20] = binin%10;
        binin = binin / 10;
        bcd[27:24] = binin%10;
        binin = binin / 10;
        bcd[31:28] = binin%10;
    end
endmodule
