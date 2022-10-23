`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/13 20:53:26
// Design Name: 
// Module Name: M4_Rtimer
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


module M4_Rtimer(
    input            ENABLE,
    input            IN_CLK,
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
    reg onstar = 0;
    
    reg [7:0]min,hour,sec;
    reg [7:0]ms;
    initial begin
        min = 0; hour = 0; sec = 0; ms = 0;
    end
    reg [2:0] inset = 3'b001;
    reg pause = 1;
    
    reg [27:0]clkdiv1;
    reg [27:0]t5ms = 28'd500000;
    reg clk5ms = 1'b0;
    always @(posedge IN_CLK) begin
        if(clkdiv1 < t5ms)
            clkdiv1 <= clkdiv1+1;
        else begin
            clkdiv1 <= 28'b0;
            clk5ms <= ~clk5ms;
        end 
    end
    
    
    reg STOP = 0;
    reg LASTSTOP = 0;
    
    reg [27:0]clkdiv0 = 28'b0;
    reg [27:0]t1000ms = 28'd100000000;
    reg [27:0]t100ms = 28'd10000000;
    reg [27:0]clkdiv2 = 28'b0;
    always @(posedge IN_CLK) begin
        if(IN_SWITCH[0])begin
            sec = 0;
            min = 0;
            hour = 0;
            //ONSTOP = LASTONSTOP;
        end else begin
            if(clkdiv2 < t100ms) begin
                clkdiv2 <= clkdiv2 + 1;
            end else begin
                clkdiv2 = 0;
                
                if(pause) begin
                    if(IN_BTN[1]) begin //上升
                        if(inset[0])begin
                            if(sec == 59) sec = 0;
                            else sec = sec + 1;
                        end
                        if(inset[1]) begin
                            if(min == 59) min = 0;
                            min = min + 1;
                        end
                        if(inset[2])begin
                            if(hour == 99) hour = 0;
                            hour = hour + 1;
                        end
                    end else if(IN_BTN[3]) begin
                        if(inset[0])begin
                            if(sec == 0) sec = 59;
                            else sec = sec - 1;
                        end
                        if(inset[1])begin
                            if(min == 0) min = 59;
                            else min = min - 1;
                        end
                        if(inset[2])begin
                            if(hour == 0) hour = 99;
                            else hour = hour - 1;
                        end
                    end
                end else if(sec <= 10 && min == 0 && hour == 0) ONSTOP = ~ONSTOP;
            end
            
            if(clkdiv0 > 0 && ~pause)
                clkdiv0 <= clkdiv0 - 1;
            else begin
                if(~pause)begin
                    clkdiv0 <= t1000ms;
                    if(sec == 0 && min == 0 && hour == 0)
                        begin
                            STOP = ~STOP;
                        end
                    else begin
                        if(sec == 0) begin
                            sec = 59; 
                            if(min == 0) begin
                                min = 59; hour = hour - 1;
                            end else min = min - 1;
                        end else sec = sec - 1;
                    end
                               
                    
                    resetms = ~resetms;
                    
                end else begin
                    clkdiv0 = 0;
                end
            end 
        end
        
    end
    
    reg onTouch = 0,resetms = 0,lastreset = 0;
    always @(posedge clk5ms) begin
        if(IN_SWITCH[0]) begin
            ms = 0;
            pause = 1;
            LASTSTOP = STOP;
        end else begin
            if(STOP != LASTSTOP)begin
                LASTSTOP = STOP;
                pause = 1;
                ms = 0;
            end
            if(IN_BTN[2] & ~onTouch)begin
                if(sec==0 && min==0 && hour==0 && ms == 0 && pause)begin
                    //什么也不做
                end else begin
                    pause = ~pause;
                end 
                onTouch = 1;
            end
            if(IN_BTN[0] & ~onTouch)begin
                if(inset == 3'b100) inset = 3'b001;
                else inset = inset + inset;
                onTouch = 1;
            end
            if(IN_BTN == 0) onTouch = 0;
            if(~pause) begin
                if(ms == 0) ms = 99;
                ms = ms - 1;
                if(resetms != lastreset)begin
                    lastreset = resetms;
                    ms = 0;
                end
            end
        end
        
    end
    reg [7:0]star = 8'b0;
    reg ONSTOP = 0;
    reg LASTONSTOP = 0;
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
    always @(pause or ONSTOP) begin
        if(sec ==0 && min==0 && hour == 0 && ms==0) begin
            LASTONSTOP = ONSTOP;
            onstar = 0;
        end
        else if(pause) onstar = 0;
        else onstar = 1;
        if(ONSTOP != LASTONSTOP && ~pause)begin
            //onstar = 1;
            star = 8'b11111111;
        end else if(pause && ~IN_SWITCH[0])begin
            LASTONSTOP = ONSTOP;
            //onstar = 0;
            if(inset[0]) star = 8'b00001100;
            else if(inset[1]) star = 8'b00110000;
            else if(inset[2]) star = 8'b11000000;     
        end else begin
            star = 8'b0;
        end
        xstar = 48'b111111111111111111111111111111111111111111111111;
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
    seg7_starcontrolorigin seg7_0(
        .x          (x),
        .dp         (8'b01010100),
        .xstar      (xstar),
        .dpstar     (8'b0),
        .star       (star),
        .originstar     (onstar),
        .clk        (IN_CLK),
        .a_to_g1     (OUT_SEG0DATA),
        .an1         (OUT_SEG0SELE),
        .dp1         (OUT_SEG0DP),
        .a_to_g2     (OUT_SEG1DATA),
        .an2         (OUT_SEG1SELE),
        .dp2         (OUT_SEG1DP)
    );
endmodule
