`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 10:02:39
// Design Name: 
// Module Name: M3_timer
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


module M3_timer(
    input            ENABLE,
    input            IN_CLK,      // Clock input (from pin)
    //input            IN_CLK_500ms,
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
    reg [7:0]min,hour,sec;
    //reg cnt=0;
    reg [7:0]ms;
    reg reset = 1;
    reg pause = 1;
    //wire clk10ms;
    
    reg [27:0]clkdiv1;
    reg [27:0]t5ms = 28'd500000;
    reg clk5ms = 1'b0;
    initial clkdiv0 = 28'b0;
    always @(posedge IN_CLK) begin
        //if(reset) clkdiv1 = 0;
        if(clkdiv1 < t5ms)
            clkdiv1 <= clkdiv1+1;
        else begin
            clkdiv1 <= 28'b0;
            clk5ms <= ~clk5ms;
        end 
    end
    //
    reg [27:0]clkdiv0;
    reg [27:0]t500ms = 28'd100000000;
    reg clk1s = 1'b0;
    initial clkdiv0 = 28'b0;
    always @(posedge IN_CLK) begin
        if(reset) begin
            clkdiv0 = 0;
            min = 0; hour = 0; sec = 0;
        end
        if(clkdiv0 < t500ms)
            clkdiv0 <= clkdiv0+1;
        else begin
            clkdiv0 <= 28'b0;
            clk1s <= ~clk1s;
            if(~pause)begin
                sec = sec+1;
                resetms = ~resetms;
                if(sec == 60) begin
                    sec = 0; min=min+1;
                end
                if(min == 60) begin
                    min = 0;hour = hour +1;
                end
            end
        end 
    end
    
    
    
    
    initial begin
        min = 0; hour = 0; sec = 0; ms = 0;
    end
    reg onTouch=0,resetms = 0,lastreset = 0;
    always @(posedge clk5ms) begin
        if(IN_BTN[1]  & ~onTouch)begin
            pause = 1;
            reset = 1;
            ms = 0;
            onTouch = 1;
        end
        if(IN_BTN[0] & ~onTouch)begin
            pause = ~pause;
            reset = 0;
            onTouch = 1;
        end
        if(IN_BTN == 0) onTouch = 0;
        if(~pause) begin
            ms = ms + 1;
            if(ms == 100) ms = 0;
            if(resetms != lastreset)begin
                lastreset = resetms;
                ms = 0;
            end
        end
    end
    /*wire IN_CLK_1s;
    ClkDivR_1s t1s(
        .reset      (reset),
        .origin_clk (IN_CLK),
        .new_clk    (IN_CLK_1s)
    );*/
    always @(pause) begin
        if(pause & ~reset)begin
            xstar = 48'b110010110010110010011001001010011110011100001110;
        end else begin
            xstar = x;
        end
    end
    
    always @* OUT_LED[0] = pause;
    always @* begin
        if(sec > 55) OUT_LED[15:1] = 15'b111111111111111;
        else if(sec > 50) OUT_LED[15:1] = 15'b11111111111111;
        else if(sec > 45) OUT_LED[15:1] = 15'b1111111111111;
        else if(sec > 40) OUT_LED[15:1] = 15'b111111111111;
        else if(sec > 35) OUT_LED[15:1] = 15'b11111111111;
        else if(sec > 30) OUT_LED[15:1] = 15'b1111111111;
        else if(sec > 25) OUT_LED[15:1] = 15'b111111111;
        else if(sec > 20) OUT_LED[15:1] = 15'b11111111;
        else if(sec > 15) OUT_LED[15:1] = 15'b1111111;
        else if(sec > 10) OUT_LED[15:1] = 15'b111111;
        else if(sec > 5) OUT_LED[15:1] = 15'b11111;
        else if(sec > 4) OUT_LED[15:1] = 15'b1111;
        else if(sec > 3) OUT_LED[15:1] = 15'b111;
        else if(sec > 2) OUT_LED[15:1] = 15'b11;
        else if(sec > 1) OUT_LED[15:1] = 15'b1;
        else if(sec > 0) OUT_LED[15:1] = 15'b0;
    end
    wire [31:0]bcd;
    wire [47:0]x;
    reg [47:0]xstar;
    BinToBCD_8bit tran1 (
        .bin      (ms),
        .bcd      (bcd[7:0])
    );
    BCDToSeg7_8bit tran2 (
        .bcd      (bcd[7:0]),
        .x        (x[11:0])
    );
    BinToBCD_8bit tran3 (
        .bin      (sec),
        .bcd      (bcd[15:8])
    );
    BCDToSeg7_8bit tran4 (
        .bcd      (bcd[15:8]),
        .x        (x[23:12])
    );BinToBCD_8bit tran5 (
        .bin      (min),
        .bcd      (bcd[23:16])
    );
    BCDToSeg7_8bit tran6 (
        .bcd      (bcd[23:16]),
        .x        (x[35:24])
    );BinToBCD_8bit tran7 (
        .bin      (hour),
        .bcd      (bcd[31:24])
    );
    BCDToSeg7_8bit tran8 (
        .bcd      (bcd[31:24]),
        .x        (x[47:36])
    );
    seg7_starcontrol seg7_0(
        .x          (x),
        .dp         (8'b01010100),
        .xstar      (xstar),
        .dpstar     (8'b0),
        .star       (8'b11111111),
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