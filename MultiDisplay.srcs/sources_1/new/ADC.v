`timescale 1ns / 1ps
module myADC (
    input DCLK, // Clock input for DRP
    input RESET,
    input wire vauxp0,vauxn0,vauxp1,vauxn1,vauxp2,vauxn2,vauxp3,vauxn3,
    //input [3:0] VAUXP, VAUXN, // Auxiliary analog channel inputs
    input VP,VN, // Dedicated and Hardwired Analog Input Pair
    //output reg [15:0] MEASURED_TEMP, MEASURED_VCCINT,
    //output reg [15:0] MEASURED_VCCAUX, MEASURED_VCCBRAM,
    //output reg [15:0] MEASURED_AUX0, MEASURED_AUX1,
    //output reg [15:0] MEASURED_AUX2, MEASURED_AUX3,
    output wire [7:0] ALM, //
    output wire [6:0] seg1,seg2,
    output reg [7:0] seg_cs,
    output reg [1:0] DP,
    output wire user_temp_alarm_out, //通用io
    output wire vccint_alarm_out,
    output wire vccaux_alarm_out,
    output wire [4:0] CHANNEL, //2位数码管显示
    output wire OT,
    output wire XADC_EOC,
    output wire XADC_EOS
);
    //wire [15:0] temperature_tmp ;
    reg [15:0] MEASURED_TEMP, MEASURED_VCCINT;
    reg [15:0] MEASURED_VCCAUX, MEASURED_VCCBRAM;
    reg [15:0] MEASURED_AUX0, MEASURED_AUX1;
    reg [15:0] MEASURED_AUX2, MEASURED_AUX3;
    reg [15:0] MEASURED_tmp1,MEASURED_tmp2;
    reg [3:0] MEASURED_sequence;
    wire clkcsc,clk1Hz;
    //reg [7:0] seg_cs;
    //wire [11:0] data_bin;//数据缓存
    reg [3:0] dec_tmp1,dec_tmp2;
    wire [19:0] dec_data_tmp1,dec_data_tmp2; //用于存储4位十进制数，每4个二进制位表示一个十进制位

    //生成各种时钟 //频率=100M/ALM
    clk_self  #(10000)  u1(
        .clk(DCLK),
        .rst(RESET),
        .clk_self(clkcsc) //片选时钟5k,频率=sys_clk/(2*翻转次数)
    );
    clk_self  #(50_000_000)  u2( //频率=100M/2r
        .clk(DCLK),
        .rst(RESET),
        .clk_self(clk1Hz) //每4秒切换一次测量的数据
    );

    //二进制结果转换为3位十进制数（12位二进制表示）

    bin2dec u3(
        .data_bin(MEASURED_tmp1),
        .data_dec(dec_data_tmp1)
    );
    bin2dec u4(
        .data_bin(MEASURED_tmp2),
        .data_dec(dec_data_tmp2)
    );
    //数码管译码
    Digitron_Translator u5(
        .data_in(dec_tmp1),
        .seg(seg1)
    );
    Digitron_Translator u6(
        .data_in(dec_tmp2),
        .seg(seg2)
    );

    // assign temperature_tmp=MEASURED_TEMP*50398/65536-27315;

    always@(posedge clk1Hz or negedge RESET)
    begin
        if(~RESET)
            begin MEASURED_sequence<=1; end
        else
            begin

                if (MEASURED_sequence<4) MEASURED_sequence<=MEASURED_sequence+1;

                else MEASURED_sequence<=1;

                case (MEASURED_sequence)
                    // 0:begin end
                    1:begin MEASURED_tmp1<=MEASURED_TEMP*50398/65536-27315;MEASURED_tmp2<=MEASURED_AUX0*100/65535; end //
                    2:begin MEASURED_tmp1<=MEASURED_VCCINT*300/65536;MEASURED_tmp2<=MEASURED_AUX1*100/65535;end
                    3:begin MEASURED_tmp1<=MEASURED_VCCAUX*300/65536;MEASURED_tmp2<=MEASURED_AUX2*100/65535;end
                    4:begin MEASURED_tmp1<=MEASURED_VCCBRAM*300/65536;MEASURED_tmp2<=MEASURED_AUX3*100/65535;end

                    // 5:begin end //电位器
                    // 6:begin end
                    // 7:begin end
                endcase
            end
    end
    //led显示的数字 always@(posedge clkcsc or negedge sys_rst)
    always@(posedge clkcsc or negedge RESET)
    begin
        if(~RESET)
            begin seg_cs <= ~8'b11011111;
                dec_tmp2<=4'hf;
            end
        else
            begin
                seg_cs[7:0] = {seg_cs[6:0],seg_cs[7]};
                case (seg_cs)
                    ~8'b11111110:begin dec_tmp1<=dec_data_tmp1[3:0];DP<=2'b00;end

                    ~8'b11111101:begin dec_tmp1<=dec_data_tmp1[7:4]; DP<=2'b00;end
                    ~8'b11111011:begin dec_tmp1<=dec_data_tmp1[11:8];DP<=2'b01;end
                    ~8'b11110111:begin dec_tmp1<=dec_data_tmp1[15:12];DP<=2'b00;end
                    ~8'b11101111:begin dec_tmp2=(MEASURED_sequence>1)?MEASURED_sequence-1:4 ; DP<=2'b00;end
                    ~8'b11011111:begin dec_tmp2<=dec_data_tmp2[3:0];DP<=2'b00;end
                    ~8'b10111111:begin dec_tmp2<=dec_data_tmp2[7:4];DP<=2'b00;end
                    ~8'b01111111:begin dec_tmp2<= dec_data_tmp2[11:8];DP<=2'b10;end
                endcase
            end
    end

    //wire VN;
    //assign VN=0;

    wire busy,eoc,eos;
    wire [5:0] channel;
    wire drdy;
    reg [6:0] daddr;
    reg [15:0] di_drp;
    wire [15:0] do_drp;
    //wire [15:0] vauxp_active;
    //wire [15:0] vauxn_active;
    reg [1:0] den_reg;
    reg [1:0] dwe_reg;
    reg [7:0] state;

    parameter init_read = 8'h00,
    read_waitdrdy = 8'h01,
    write_waitdrdy = 8'h03,
    read_reg00 = 8'h04,
    reg00_waitdrdy = 8'h05,
    read_reg01 = 8'h06,
    reg01_waitdrdy = 8'h07,
    read_reg02 = 8'h08,
    reg02_waitdrdy = 8'h09,
    read_reg06 = 8'h0a,
    reg06_waitdrdy = 8'h0b,
    read_reg10 = 8'h0c,
    reg10_waitdrdy = 8'h0d,
    read_reg11 = 8'h0e,
    reg11_waitdrdy = 8'h0f,
    read_reg12 = 8'h10,
    reg12_waitdrdy = 8'h11,
    read_reg13 = 8'h12,
    reg13_waitdrdy = 8'h13;

    always @(posedge DCLK)
    if (~RESET) begin
        state <= init_read;
        den_reg <= 2'h0;
        dwe_reg <= 2'h0;
        di_drp <= 16'h0000;
    end
    else
        case (state)
            init_read : begin
                daddr = 7'h40; //配置寄存器
                den_reg = 2'h2; // performing read
                if (busy == 0 ) state <= read_waitdrdy;
            end
            read_waitdrdy :
            if (drdy ==1) begin
                di_drp = do_drp & 16'h03_FF; //Clearing AVG bits for Configreg0
                daddr = 7'h40;
                den_reg = 2'h2;
                dwe_reg = 2'h2; // performing write
                state = write_waitdrdy;
            end
            else begin
                den_reg = { 1'b0, den_reg[1] } ;
                dwe_reg = { 1'b0, dwe_reg[1] } ;
                state = state;
            end
            write_waitdrdy :
            if (drdy ==1) begin
                state = read_reg00;
            end
            else begin
                den_reg = { 1'b0, den_reg[1] } ;
                dwe_reg = { 1'b0, dwe_reg[1] } ;
                state = state;
            end
            read_reg00 : begin
                daddr = 7'h00;
                den_reg = 2'h2; // performing read
                if (eos== 1) state <= reg00_waitdrdy;
            end
            reg00_waitdrdy :
            if (drdy ==1) begin
                MEASURED_TEMP = do_drp;
                state <=read_reg01;
            end
            else begin
                den_reg = { 1'b0, den_reg[1] } ;
                dwe_reg = { 1'b0, dwe_reg[1] } ;
                state = state;
            end
            read_reg01 : begin
                daddr = 7'h01;
                den_reg = 2'h2; // performing read
                state <=reg01_waitdrdy;
            end
            reg01_waitdrdy :
            if (drdy ==1) begin
                MEASURED_VCCINT = do_drp;
                state <=read_reg02;
            end
            else begin
                den_reg = { 1'b0, den_reg[1] } ;
                dwe_reg = { 1'b0, dwe_reg[1] } ;
                state = state;
            end
            read_reg02 : begin
                daddr = 7'h02;
                den_reg = 2'h2; // performing read
                state <=reg02_waitdrdy;
            end
            reg02_waitdrdy :
            if (drdy ==1) begin
                MEASURED_VCCAUX = do_drp;
                state <=read_reg06;
            end
            else begin
                den_reg = { 1'b0, den_reg[1] } ;
                dwe_reg = { 1'b0, dwe_reg[1] } ;
                state = state;
            end
            read_reg06 : begin
                daddr = 7'h06;
                den_reg = 2'h2; // performing read
                state <=reg06_waitdrdy;
            end
            reg06_waitdrdy :
            if (drdy ==1) begin
                MEASURED_VCCBRAM = do_drp;
                state <= read_reg10;
            end
            else begin
                den_reg = { 1'b0, den_reg[1] } ;
                dwe_reg = { 1'b0, dwe_reg[1] } ;
                state = state;
            end
            read_reg10 : begin
                daddr = 7'h10;
                den_reg = 2'h2; // performing read
                state <= reg10_waitdrdy;
            end
            reg10_waitdrdy :
            if (drdy ==1) begin
                MEASURED_AUX0 = do_drp;
                state <= read_reg11;
            end
            else begin
                den_reg = { 1'b0, den_reg[1] } ;
                dwe_reg = { 1'b0, dwe_reg[1] } ;
                state = state;
            end
            read_reg11 : begin
                daddr = 7'h11;
                den_reg = 2'h2; // performing read
                state <= reg11_waitdrdy;
            end
            reg11_waitdrdy :
            if (drdy ==1) begin
                MEASURED_AUX1 = do_drp;
                state <= read_reg12;
            end
            else begin
                den_reg = { 1'b0, den_reg[1] } ;
                dwe_reg = { 1'b0, dwe_reg[1] } ;
                state = state;
            end
            read_reg12 : begin
                daddr = 7'h12;
                den_reg = 2'h2; // performing read
                state <= reg12_waitdrdy;
            end
            reg12_waitdrdy :
            if (drdy ==1) begin
                MEASURED_AUX2= do_drp;
                state <= read_reg13;
            end
            else begin
                den_reg = { 1'b0, den_reg[1] } ;
                dwe_reg = { 1'b0, dwe_reg[1] } ;
                state = state;
            end
            read_reg13 : begin
                daddr = 7'h13;
                den_reg = 2'h2; // performing read
                state <= reg13_waitdrdy;
            end
            reg13_waitdrdy :
            if (drdy ==1) begin
                MEASURED_AUX3= do_drp;
                state <=read_reg00;
                daddr = 7'h00;
            end
            else begin
                den_reg = { 1'b0, den_reg[1] } ;
                dwe_reg = { 1'b0, dwe_reg[1] } ;
                state = state;
            end
        endcase

    XADC0 u7 (
        .di_in(di_drp), // input wire [15 : 0] di_in
        .daddr_in(daddr), // input wire [6 : 0] daddr_in
        .den_in(den_reg[0]), // input wire den_in
        .dwe_in(dwe_reg[0]), // input wire dwe_in
        .drdy_out(drdy), // output wire drdy_out
        .do_out(do_drp), // output wire [15 : 0] do_out
        .dclk_in(DCLK), // input wire dclk_in
        .reset_in(~RESET), // input wire reset_in
        .vp_in(VP), // input wire vp_in
        .vn_in(VN), // input wire vn_in
        .vauxp0(vauxp0), // input wire vauxp0
        .vauxn0(vauxn0), // input wire vauxn0
        .vauxp1(vauxp1), // input wire vauxp1
        .vauxn1(vauxn1), // input wire vauxn1
        .vauxp2(vauxp2), // input wire vauxp2
        .vauxn2(vauxn2), // input wire vauxn2
        .vauxp3(vauxp3), // input wire vauxp3
        .vauxn3(vauxn3), // input wire vauxn3
        .user_temp_alarm_out(user_temp_alarm_out), // output wire user_temp_alarm_out
        .vccint_alarm_out(vccint_alarm_out), // output wire vccint_alarm_out
        .vccaux_alarm_out(vccaux_alarm_out), // output wire vccaux_alarm_out
        .ot_out(OT), // output wire ot_out
        .channel_out(CHANNEL), // output wire [4 : 0] channel_out
        .eoc_out(eoc), // output wire eoc_out
        .alarm_out(ALM), // output wire alarm_out
        .eos_out(eos), // output wire eos_out
        .busy_out(busy) // output wire busy_out
    );

    //assign vauxp_active = {12'h000, VAUXP[3:0]};
    //assign vauxn_active = {12'h000, VAUXN[3:0]};
    assign XADC_EOC = eoc;
    assign XADC_EOS = eos;
endmodule