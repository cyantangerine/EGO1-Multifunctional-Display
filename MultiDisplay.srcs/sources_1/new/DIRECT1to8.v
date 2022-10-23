`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/30 12:24:16
// Design Name: 
// Module Name: DIRECT1to8
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


module DIRECT1to8_1bit(
    input i,
    input select[2:0],
    output reg o0,
    output reg o1,
    output reg o2,
    output reg o3,
    output reg o4,
    output reg o5,
    output reg o6,
    output reg o7
    );
    reg zero = 0;
    always @* begin
        o0=zero;o1=zero;o2=zero;o3=zero;o4=zero;o5=zero;o6=zero;o7=zero;
        case(select)
            0:o0 = i;
            1:o1 = i;
            2:o2 = i;
            3:o3 = i;
            4:o4 = i;
            5:o5 = i;
            6:o6 = i;
            7:o7 = i;
        endcase
    end
endmodule