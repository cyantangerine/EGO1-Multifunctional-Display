`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/22 21:09:32
// Design Name: 
// Module Name: viewer
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


module viewer(
    input            clk_pin,      // Clock input (from pin)
    input      [15:0]x,
    input      [4:0] btn,
    output     [6:0] seg7_0_7bit,
    output     [6:0] seg7_1_7bit,
    output     [3:0] seg7_0_an,
    output     [3:0] seg7_1_an,
    output           seg7_0_dp,
    output           seg7_1_dp,
    output  reg   [15:0]  led//,
    );
    wire [4:0]btnb;
    /*IBUF IBUF_btn0      (.I (btn[0]),      .O (btnb[0]));
    IBUF IBUF_btn1      (.I (btn[1]),      .O (btnb[1]));
    IBUF IBUF_btn2      (.I (btn[2]),      .O (btnb[2]));
    IBUF IBUF_btn3      (.I (btn[3]),      .O (btnb[3]));
    IBUF IBUF_btn4      (.I (btn[4]),      .O (btnb[4]));
    */
    reg [7:0]dpstar;
    reg [47:0]numstar;
    initial begin
        dpstar = 8'b00000000;
        numstar = 48'b111111111111111111111111111111111111111111111111;
    end
    reg [47:0]num;
    reg [7:0]dp;
    reg [7:0]pos;
    reg [5:0]n;
    wire [7:0]staring;
    //reg [7:0]star;
    initial dp = 8'b0;
    initial pos = 8'b00000001;
    assign btnb[4:0] = btn[4:0];
    
    //clk500ms
    reg [26:0]clkdiv2;
    reg clk100ms;
    reg [26:0]t100ms = 27'd5000000;
    initial clkdiv2 = 27'b0;
    initial clk100ms = 0;
    always @(posedge clk_pin) begin
        if(clkdiv2 < t100ms)
            clkdiv2 <= clkdiv2+1;
        else begin
            clkdiv2 <= 27'b0;
            clk100ms <= ~clk100ms;
        end 
    end
    
    
    //clk10ms
    reg [26:0]clkdiv;
    reg clk10ms;
    reg [26:0]t10ms = 27'd1000000;
    initial clkdiv = 27'b0;
    initial clk10ms = 0;
    always @(posedge clk_pin) begin
        if(clkdiv < t10ms)
            clkdiv <= clkdiv+1;
        else begin
            clkdiv <= 27'b0;
            clk10ms <= ~clk10ms;
        end 
    end
    
    reg onTouch;
    initial onTouch = 0;
    initial n = 6'b100110;
    always @(posedge clk100ms) begin    
        if(btnb[1]==1)begin
            if(n<6'b111111) n=n+1;
        end
        if(btnb[3]==1)begin
            if(n>6'b0) n=n-1;
        end 
    end
    always @(posedge clk10ms) begin
        if(~onTouch)begin
            onTouch=1;
            if(btnb[0]==1)begin 
                pos=pos<<1;
                if(pos==8'b0) pos = 8'b10000000;
                
                
            end
            else if(btnb[2]==1)begin
                pos=pos>>1;
                if(pos==8'b0) pos = 8'b00000001;
            end
        end 
        if(onTouch & btnb[0]==0 & btnb[2] ==0 & ~btnb[1] & ~btnb[3]) onTouch = 0;
    end
    always @* begin
        /*pos[0] = ~x[0] & ~x[1] & ~x[2];
        pos[1] = ~x[0] & ~x[1] & x[2];
        pos[2] = ~x[0] & x[1] & ~x[2];
        pos[3] = ~x[0] & x[1] & x[2];
        pos[4] = x[0] & ~x[1] & ~x[2];
        pos[5] = x[0] & ~x[1] & x[2];
        pos[6] = x[0] & x[1] & ~x[2];
        pos[7] = x[0] & x[1] & x[2];*/
        
        dp[7:0] = pos[7:0];
    end
    reg [7:0]star;
    initial star = 8'b00000000;
    initial num[47:0] = 48'b011100011110001100001100001110011100011100100110; //SUCCESS!
    always @* begin
        /*n[0]=x[7];
        n[1]=x[6];
        n[2]=x[5];
        n[3]=x[4];
        n[4]=x[3];
        n[5]=x[2]; 
        */
        star[0] = x[15];
        star[1] = x[14];
        star[2] = x[13];
        star[3] = x[12];
        star[4] = x[11];
        star[5] = x[10];
        star[6] = x[9];
        star[7] = x[8];
        
        led[7:0] = x[7:0];
            
        led[15] = staring[0];
        led[14] = staring[1];
        led[13] = staring[2];
        led[12] = staring[3];
        led[11] = staring[4];
        led[10] = staring[5];
        led[9] = staring[6];
        led[8] = staring[7];
        
    end
    always @* begin
        /*num[5:0] = 6'd0;
        if(pos[0]) num[5:0] = 6'd0;
        if(pos[1]) num[5:0] = 6'd0;
        if(pos[2]) num[5:0] = 6'd0;
        if(pos[3]) num[5:0] = 6'd0;
        if(pos[4]) num[5:0] = 6'd0;
        if(pos[5]) num[5:0] = 6'd0;
        if(pos[6]) num[5:0] = 6'd0;
        if(pos[7]) num[5:0] = 6'd0;
        */
        if(pos[0]) num[5:0] = n[5:0];
        if(pos[1]) num[11:6] = n[5:0];
        if(pos[2]) num[17:12] = n[5:0];
        if(pos[3]) num[23:18] = n[5:0];
        if(pos[4]) num[29:24] = n[5:0];
        if(pos[5]) num[35:30] =n[5:0];
        if(pos[6]) num[41:36] =n[5:0];
        if(pos[7]) num[47:42] =n[5:0];
        //star[7:0] = x[15:8];
    end
      
    seg7_starcontrol seg7_0(
        .x          (num),
        .dp         (dp),
        .xstar      (numstar),
        .dpstar     (dpstar),
        .star       (star),
        .clk        (clk_pin),
        //.clr        (rst_pin),
        .a_to_g1     (seg7_0_7bit),
        .an1         (seg7_0_an),
        .dp1         (seg7_0_dp),
        .a_to_g2     (seg7_1_7bit),
        .an2         (seg7_1_an),
        .dp2         (seg7_1_dp),
        .staring    (staring)
        //test
        //,.clkdiv (clkdiv)
    );
endmodule
