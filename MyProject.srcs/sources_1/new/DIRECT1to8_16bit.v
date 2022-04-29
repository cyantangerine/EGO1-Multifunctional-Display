`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/30 13:07:58
// Design Name: 
// Module Name: DIRECT1to8_16bit
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


module DIRECT1to8_16bit(
    input [15:0] i,
    input [2:0] select,
    output reg [15:0] o0,
    output reg [15:0] o1,
    output reg [15:0] o2,
    output reg [15:0] o3,
    output reg [15:0] o4,
    output reg [15:0] o5,
    output reg [15:0] o6,
    output reg [15:0] o7
    );
    reg [15:0] zero = 15'b0;
    reg [2:0] sel; 
    always @* begin
        sel = select;
        o0=zero;o1=zero;o2=zero;o3=zero;o4=zero;o5=zero;o6=zero;o7=zero;
        case(sel)
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
