`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/30 12:54:50
// Design Name: 
// Module Name: MUX8to1_4bit
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



module MUX8to1_4bit(
    input [3:0] i0,
    input [3:0] i1,
    input [3:0] i2,
    input [3:0] i3,
    input [3:0] i4,
    input [3:0] i5,
    input [3:0] i6,
    input [3:0] i7,
    input [2:0] select,
    output reg [3:0] o
    );
    always @* begin
        case(select)
            0: o = i0;
            1: o = i1;
            2: o = i2;
            3: o = i3;
            4: o = i4;
            5: o = i5;
            6: o = i6;
            7: o = i7;
            default: o = 0;
        endcase
    end
endmodule
