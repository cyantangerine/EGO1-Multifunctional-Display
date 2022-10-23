`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/30 12:20:25
// Design Name: 
// Module Name: MUX8to1
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


module MUX8to1_1bit(
    input i0,
    input i1,
    input i2,
    input i3,
    input i4,
    input i5,
    input i6,
    input i7,
    input [2:0]select,
    output reg o
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