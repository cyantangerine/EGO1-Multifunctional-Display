`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/30 21:07:45
// Design Name: 
// Module Name: M2_Counter
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


module M2_Counter(
    input            ENABLE,
    input            IN_CLK,      // Clock input (from pin)
    input      [15:0]IN_SWITCH,
    input      [4:0] IN_BTN,
    output     [6:0] OUT_SEG0DATA,
    output     [6:0] OUT_SEG1DATA,
    output     [3:0] OUT_SEG0SELE,
    output     [3:0] OUT_SEG1SELE,
    output           OUT_SEG0DP,
    output           OUT_SEG1DP,
    output     reg [15:0]OUT_LED//,
    );
    wire clk10ms;
    ClkDiv_10ms t(
        .origin_clk(IN_CLK),
        .new_clk (clk10ms)
    );
    reg onTouch = 0;
    reg [31:0] num;
    always @(posedge clk10ms) begin
        if(IN_BTN[2]==1)begin 
            if(num<27'd99999999) num=num+1;
        end
        else if(IN_BTN[0]==1)begin
            if(num>27'd0) num=num-1;
        end else if(~onTouch)begin
            onTouch=1;
            if(IN_BTN[1]==1)begin 
                if(num<27'd99999999) num=num+1;
            end
            else if(IN_BTN[3]==1)begin
                if(num>27'd0) num=num-1;
            end
        end 
        if(onTouch & IN_BTN==0) onTouch = 0;
    end
    always @num begin
        OUT_LED[15] = num[0];
        OUT_LED[14] = num[1];
        OUT_LED[13] = num[2];
        OUT_LED[12] = num[3];
        OUT_LED[11] = num[4];
        OUT_LED[10] = num[5];
        OUT_LED[9] = num[6];
        OUT_LED[8] = num[7];
        OUT_LED[7] = num[8];
        OUT_LED[6] = num[9];
        OUT_LED[5] = num[10];
        OUT_LED[4] = num[11];
        OUT_LED[3] = num[12];
        OUT_LED[2] = num[13];
        OUT_LED[1] = num[14];
        OUT_LED[0] = num[15];
    end
    wire [31:0] bcd;
    wire [47:0]x;
    BinToBCD_32bit tran1 (
        .bin      (num),
        .bcd      (bcd)
    );
    BCDToSeg7_32bit tran2 (
        .bcd      (bcd),
        .x        (x)
    );
    /*
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
    end*/
    seg7_starcontrol seg7_0(
        .x          (x),
        .dp         (8'b0),
        .xstar      (48'b0),
        .dpstar     (8'b0),
        .star       (8'b0),
        .clk        (IN_CLK),
        //.clr        (rst_pin),
        .a_to_g1     (OUT_SEG0DATA),
        .an1         (OUT_SEG0SELE),
        .dp1         (OUT_SEG0DP),
        .a_to_g2     (OUT_SEG1DATA),
        .an2         (OUT_SEG1SELE),
        .dp2         (OUT_SEG1DP)
//        .staring    (staring)
        //test
        //,.clkdiv (clkdiv)
    );
endmodule
