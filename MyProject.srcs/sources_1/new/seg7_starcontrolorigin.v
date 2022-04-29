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


module seg7_starcontrolorigin(
    input [47:0] x,
    input [47:0] xstar,
    input [7:0] dp,
    input [7:0] dpstar,
    input [7:0] star, 
    input originstar,
    input clk,
    //input clr,
    output [6:0] a_to_g1,
    output [3:0] an1,
    output [6:0] a_to_g2,
    output [3:0] an2,
    output dp1,
    output dp2,
    output reg [7:0]staring
    //,output clkdiv
    );
    reg [47:0] newx;
    reg [7:0] newdp;
    //wire onstar = star;
    reg [26:0]clkdiv;
    reg [26:0]t1s = 27'd50000000;
    reg onstar;
    initial onstar = 0;
    initial clkdiv = 27'b0;
    always @(posedge clk) begin
        if(clkdiv < t1s)
            clkdiv <= clkdiv+1;
        else begin
            clkdiv <= 27'b0;
            onstar <= ~onstar;
        end 
    end
    always @(onstar or dp or x or star or xstar or dpstar or originstar) begin
        if(onstar || originstar)begin
            newdp[7:0] = dp[7:0];
            newx[47:0] = x[47:0];
            if(star[0])begin newx[5:0] = xstar[5:0];newdp[0]=dpstar[0];end
            if(star[1])begin newx[11:6] = xstar[11:6];newdp[1]=dpstar[1];end
            if(star[2])begin newx[17:12] = xstar[17:12];newdp[2]=dpstar[2];end
            if(star[3])begin newx[23:18] = xstar[23:18];newdp[3]=dpstar[3];end
            if(star[4])begin newx[29:24] = xstar[29:24];newdp[4]=dpstar[4];end
            if(star[5])begin newx[35:30] = xstar[35:30];newdp[5]=dpstar[5];end
            if(star[6])begin newx[41:36] = xstar[41:36];newdp[6]=dpstar[6];end
            if(star[7])begin newx[47:42] = xstar[47:42];newdp[7]=dpstar[7];end
            staring[7] = onstar & star[7];
            staring[6] = onstar & star[6];
            staring[5] = onstar & star[5];
            staring[4] = onstar & star[4];
            staring[3] = onstar & star[3];
            staring[2] = onstar & star[2];
            staring[1] = onstar & star[1];
            staring[0] = onstar & star[0];
        end
        else begin
            newdp[7:0] = dp[7:0];
            newx[47:0] = x[47:0];
            staring = 8'b0;
        end
    end
    seg7 t(
        .x (newx),
        .dp (newdp),
        .clk(clk),
        //.clr(clr),
        .a_to_g1(a_to_g1),
        .an1(an1),
        .a_to_g2(a_to_g2),
        .an2(an2),
        .dp1(dp1),
        .dp2(dp2)
    );
endmodule
