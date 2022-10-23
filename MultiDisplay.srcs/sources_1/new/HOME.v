`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/30 12:26:34
// Design Name: 
// Module Name: HOME
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


module HOME(
    input            IN_CLK,      // Clock input (from pin)
    input      [15:0]IN_SWITCH,
    input      [4:0] IN_BTN,
    output     [6:0] OUT_SEG0DATA,
    output     [6:0] OUT_SEG1DATA,
    output     [3:0] OUT_SEG0SELE,
    output     [3:0] OUT_SEG1SELE,
    output           OUT_SEG0DP,
    output           OUT_SEG1DP,
    output     [15:0]OUT_LED//,
    );
    wire IN_CLK_100ms;
    ClkDiv_100ms UT0(
        .origin_clk (IN_CLK),
        .new_clk(IN_CLK_100ms)
    );
    wire IN_CLK_500ms;
    ClkDiv_500ms UT1(
        .origin_clk (IN_CLK),
        .new_clk(IN_CLK_500ms)
    );
    
    reg[2:0] DATA_MODE = 0;//0表示首页，1~7表示对应模块
    reg[7:0] ENABLE_MODE = 0;
    always @DATA_MODE begin
        ENABLE_MODE = 0;
        ENABLE_MODE[ DATA_MODE ] = 1;
    end
    
    wire[15:0]M_IN_SWITCH[7:0],M_IN_BTN[7:0];
    
    wire[6:0] M_OUT_SEG0DATA[7:0],M_OUT_SEG1DATA[7:0];
    wire[3:0] M_OUT_SEG0SELE[7:0],M_OUT_SEG1SELE[7:0];
    wire M_OUT_SEG0DP[7:0],M_OUT_SEG1DP[7:0];
    wire[15:0] M_OUT_LED[7:0];
    
    
    //输入地址选择器
    /* CLK 暂不分配，直接输出
    DIRECT1to8_1bit(
        .select (DATA_MODE),
        .i      (IN_CLK),
         
    );*/
    
    DIRECT1to8_16bit UI1(
        .select (DATA_MODE),
        .i      (IN_SWITCH),
        .o0     (M_IN_SWITCH[0]),
        .o1     (M_IN_SWITCH[1]),
        .o2     (M_IN_SWITCH[2]),
        .o3     (M_IN_SWITCH[3]),
        .o4     (M_IN_SWITCH[4]),
        .o5     (M_IN_SWITCH[5]),
        .o6     (M_IN_SWITCH[6]),
        .o7     (M_IN_SWITCH[7])
    );
    DIRECT1to8_16bit UI2(
        .select (DATA_MODE),
        .i      (IN_BTN),
        .o0     (M_IN_BTN[0]),
        .o1     (M_IN_BTN[1]),
        .o2     (M_IN_BTN[2]),
        .o3     (M_IN_BTN[3]),
        .o4     (M_IN_BTN[4]),
        .o5     (M_IN_BTN[5]),
        .o6     (M_IN_BTN[6]),
        .o7     (M_IN_BTN[7])
    );
    //模块连接
    //M0 模块选择器
    reg [2:0] M0_DATA_MODE_TMP = 0;
    //reg [1:0] onTouchCount = 0;
    reg onTouch;
    always @(posedge IN_CLK_100ms)begin
        if(~onTouch)begin
            onTouch = 1;
            if(ENABLE_MODE[0])begin
                if(IN_BTN[1]) M0_DATA_MODE_TMP = M0_DATA_MODE_TMP + 1;
                else if(IN_BTN[3]) M0_DATA_MODE_TMP = M0_DATA_MODE_TMP - 1;
                else if(IN_BTN[4]) DATA_MODE = M0_DATA_MODE_TMP;
            end else if(IN_BTN[4]) DATA_MODE = 0;
        end else begin
            onTouch = 0;
        end
    end       
       M0_ModeSelecter M0 (
        .ENABLE         (ENABLE_MODE[0]),
        .IN_CLK         (IN_CLK),
        .IN_SWITCH      (M_IN_SWITCH[0]),
        .IN_BTN         (M_IN_BTN[0]),
        .OUT_SEG0DATA   (M_OUT_SEG0DATA[0]),
        .OUT_SEG1DATA   (M_OUT_SEG1DATA[0]),
        .OUT_SEG0SELE   (M_OUT_SEG0SELE[0]),
        .OUT_SEG1SELE   (M_OUT_SEG1SELE[0]),
        .OUT_SEG0DP     (M_OUT_SEG0DP[0]),
        .OUT_SEG1DP     (M_OUT_SEG1DP[0]),
        .OUT_LED        (M_OUT_LED[0]),
        .data           (M0_DATA_MODE_TMP)
       );
    
    //M1
    M1_TextViewer M1 (
        .ENABLE         (ENABLE_MODE[1]),
        .IN_CLK         (IN_CLK),
        .IN_SWITCH      (M_IN_SWITCH[1]),
        .IN_BTN         (M_IN_BTN[1]),
        .OUT_SEG0DATA   (M_OUT_SEG0DATA[1]),
        .OUT_SEG1DATA   (M_OUT_SEG1DATA[1]),
        .OUT_SEG0SELE   (M_OUT_SEG0SELE[1]),
        .OUT_SEG1SELE   (M_OUT_SEG1SELE[1]),
        .OUT_SEG0DP     (M_OUT_SEG0DP[1]),
        .OUT_SEG1DP     (M_OUT_SEG1DP[1]),
        .OUT_LED        (M_OUT_LED[1])
    );
    //M2
    M2_Counter M2 (
        .ENABLE         (ENABLE_MODE[2]),
        .IN_CLK         (IN_CLK),
        .IN_SWITCH      (M_IN_SWITCH[2]),
        .IN_BTN         (M_IN_BTN[2]),
        .OUT_SEG0DATA   (M_OUT_SEG0DATA[2]),
        .OUT_SEG1DATA   (M_OUT_SEG1DATA[2]),
        .OUT_SEG0SELE   (M_OUT_SEG0SELE[2]),
        .OUT_SEG1SELE   (M_OUT_SEG1SELE[2]),
        .OUT_SEG0DP     (M_OUT_SEG0DP[2]),
        .OUT_SEG1DP     (M_OUT_SEG1DP[2]),
        .OUT_LED        (M_OUT_LED[2])
    );
    M3_timer M3 (
        .ENABLE         (ENABLE_MODE[3]),
        .IN_CLK         (IN_CLK),
        //.IN_CLK_500ms   (IN_CLK_500ms),
        .IN_SWITCH      (M_IN_SWITCH[3]),
        .IN_BTN         (M_IN_BTN[3]),
        .OUT_SEG0DATA   (M_OUT_SEG0DATA[3]),
        .OUT_SEG1DATA   (M_OUT_SEG1DATA[3]),
        .OUT_SEG0SELE   (M_OUT_SEG0SELE[3]),
        .OUT_SEG1SELE   (M_OUT_SEG1SELE[3]),
        .OUT_SEG0DP     (M_OUT_SEG0DP[3]),
        .OUT_SEG1DP     (M_OUT_SEG1DP[3]),
        .OUT_LED        (M_OUT_LED[3])
    );
    M4_Rtimer M4 (
        .ENABLE         (ENABLE_MODE[4]),
        .IN_CLK         (IN_CLK),
        //.IN_CLK_500ms   (IN_CLK_500ms),
        .IN_SWITCH      (M_IN_SWITCH[4]),
        .IN_BTN         (M_IN_BTN[4]),
        .OUT_SEG0DATA   (M_OUT_SEG0DATA[4]),
        .OUT_SEG1DATA   (M_OUT_SEG1DATA[4]),
        .OUT_SEG0SELE   (M_OUT_SEG0SELE[4]),
        .OUT_SEG1SELE   (M_OUT_SEG1SELE[4]),
        .OUT_SEG0DP     (M_OUT_SEG0DP[4]),
        .OUT_SEG1DP     (M_OUT_SEG1DP[4]),
        .OUT_LED        (M_OUT_LED[4])
    );
    
    //输出选择器
    MUX8to1_16bit UO1(
        .select (DATA_MODE),
        .o      (OUT_LED),
        .i0     (M_OUT_LED[0]),
        .i1     (M_OUT_LED[1]),
        .i2     (M_OUT_LED[2]),
        .i3     (M_OUT_LED[3]),
        .i4     (M_OUT_LED[4]),
        .i5     (M_OUT_LED[5]),
        .i6     (M_OUT_LED[6]),
        .i7     (M_OUT_LED[7])
    );
    MUX8to1_7bit UO2(
        .select (DATA_MODE),
        .o      (OUT_SEG0DATA),
        .i0     (M_OUT_SEG0DATA[0]),
        .i1     (M_OUT_SEG0DATA[1]),
        .i2     (M_OUT_SEG0DATA[2]),
        .i3     (M_OUT_SEG0DATA[3]),
        .i4     (M_OUT_SEG0DATA[4]),
        .i5     (M_OUT_SEG0DATA[5]),
        .i6     (M_OUT_SEG0DATA[6]),
        .i7     (M_OUT_SEG0DATA[7])
    );
    MUX8to1_4bit UO3(
        .select (DATA_MODE),
        .o      (OUT_SEG0SELE),
        .i0     (M_OUT_SEG0SELE[0]),
        .i1     (M_OUT_SEG0SELE[1]),
        .i2     (M_OUT_SEG0SELE[2]),
        .i3     (M_OUT_SEG0SELE[3]),
        .i4     (M_OUT_SEG0SELE[4]),
        .i5     (M_OUT_SEG0SELE[5]),
        .i6     (M_OUT_SEG0SELE[6]),
        .i7     (M_OUT_SEG0SELE[7])
    );
    MUX8to1_1bit UO4(
        .select (DATA_MODE),
        .o      (OUT_SEG0DP),
        .i0     (M_OUT_SEG0DP[0]),
        .i1     (M_OUT_SEG0DP[1]),
        .i2     (M_OUT_SEG0DP[2]),
        .i3     (M_OUT_SEG0DP[3]),
        .i4     (M_OUT_SEG0DP[4]),
        .i5     (M_OUT_SEG0DP[5]),
        .i6     (M_OUT_SEG0DP[6]),
        .i7     (M_OUT_SEG0DP[7])
    );
    MUX8to1_7bit UO5(
        .select (DATA_MODE),
        .o      (OUT_SEG1DATA),
        .i0     (M_OUT_SEG1DATA[0]),
        .i1     (M_OUT_SEG1DATA[1]),
        .i2     (M_OUT_SEG1DATA[2]),
        .i3     (M_OUT_SEG1DATA[3]),
        .i4     (M_OUT_SEG1DATA[4]),
        .i5     (M_OUT_SEG1DATA[5]),
        .i6     (M_OUT_SEG1DATA[6]),
        .i7     (M_OUT_SEG1DATA[7])
    );
    MUX8to1_4bit UO6(
        .select (DATA_MODE),
        .o      (OUT_SEG1SELE),
        .i0     (M_OUT_SEG1SELE[0]),
        .i1     (M_OUT_SEG1SELE[1]),
        .i2     (M_OUT_SEG1SELE[2]),
        .i3     (M_OUT_SEG1SELE[3]),
        .i4     (M_OUT_SEG1SELE[4]),
        .i5     (M_OUT_SEG1SELE[5]),
        .i6     (M_OUT_SEG1SELE[6]),
        .i7     (M_OUT_SEG1SELE[7])
    );
    MUX8to1_1bit UO7(
        .select (DATA_MODE),
        .o      (OUT_SEG1DP),
        .i0     (M_OUT_SEG1DP[0]),
        .i1     (M_OUT_SEG1DP[1]),
        .i2     (M_OUT_SEG1DP[2]),
        .i3     (M_OUT_SEG1DP[3]),
        .i4     (M_OUT_SEG1DP[4]),
        .i5     (M_OUT_SEG1DP[5]),
        .i6     (M_OUT_SEG1DP[6]),
        .i7     (M_OUT_SEG1DP[7])
    );
endmodule