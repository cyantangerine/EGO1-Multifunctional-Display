`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 10:07:02
// Design Name: 
// Module Name: BinToBCD_8bit
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


module BinToBCD_8bit(
    input [7:0]bin,output reg[7:0] bcd
    );
    reg [7:0]binin;
    always @bin begin
        binin = bin;
        bcd[3:0] = binin%10;
        binin = binin / 10;
        bcd[7:4] = binin%10;
    end
endmodule
