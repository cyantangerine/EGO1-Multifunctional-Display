`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/23 08:22:55
// Design Name: 
// Module Name: seg7_starcontorl
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


module seg7_starcontrol(
    input [47:0] x,
    input [7:0] dp,
    input [7:0] star, 
    input clk,
    input clr,
    output reg [6:0] a_to_g1,
    output reg [3:0] an1,
    output reg [6:0] a_to_g2,
    output reg [3:0] an2,
    output reg dp1,
    output reg dp2//,
    );
    reg [47:0] newx;
    reg [7:0] newdp;
    reg [27:0]clkdiv;
    reg t1s = 9'd100000000;
    reg onstar;
    initial onstar = 1;
    always @(posedge clk or posedge clr) begin
        if ( clr == 1)
            clkdiv <= 0;
        else
            clkdiv <= clkdiv+1;
    end
    always @(posedge clk) begin
        if(clkdiv > t1s) begin
            onstar = ~onstar;
            clkdiv = 0;
        end
    end
    always @(onstar) begin
        if(onstar)begin
            newdp = star & dp;
            if(star[0])newx[5:0] = 6'b0;
            if(star[1])newx[11:6] = 6'b0;
            if(star[2])newx[17:12] = 6'b0;
            if(star[3])newx[23:18] = 6'b0;
            if(star[4])newx[29:24] = 6'b0;
            if(star[5])newx[35:30] = 6'b0;
            if(star[6])newx[41:36] = 6'b0;
            if(star[7])newx[47:42] = 6'b0;
        end
        else begin
            newdp = dp;
            newx = x;
        end
    end
    seg7 t(
        .x (newx) ,
        .dp (newdp),
        .clk(clk),
        .clr(clr),
        .a_to_g1(a_to_g1),
        .an1(an1),
        .a_to_g2(a_to_g2),
        .an2(an2),
        .dp1(dp1),
        .dp2(dp2)
    );
endmodule
