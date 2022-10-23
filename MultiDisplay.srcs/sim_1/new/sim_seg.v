`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/22 21:32:51
// Design Name: 
// Module Name: sim_seg
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


module sim_seg(    
    );
    reg clk,clr;
    initial begin
        clr = 0;
        clk = 0;
        x = 16'b0;
        //num = 48'b0;
    end
    always #1 clk=clk+1;
    
    reg      [15:0]x;
    wire     [6:0] seg7_0_7bit;
    wire     [6:0] seg7_1_7bit;
    wire    [3:0] seg7_0_an;
    wire    [3:0] seg7_1_an;
    wire          seg7_0_dp;
    wire          seg7_1_dp;
    wire  [15:0]      led;
    wire [27:0]clkdiv;
    wire [47:0]num;
    wire [5:0] digit1;
    wire [5:0] digit2;
    wire [3:0] aen;
    reg [4:0] btn;
    initial btn = 5'b00001;
    always #5 begin
        btn = btn<<1;
        if(btn==5'b00000) btn = 5'b00001;
    end
    always #5 x=x+1;
    //always #5 num=num+1;
    //seg7 t1(num,clk,clr,seg7_0_7bit,seg7_0_an,seg7_1_7bit,seg7_1_an,seg7_0_dp,seg7_1_dp,clkdiv,digit1,digit2,aen);
    viewer t(clk,x,btn,seg7_0_7bit,seg7_1_7bit,seg7_0_an,seg7_1_an,seg7_0_dp,seg7_1_dp,led);
endmodule
