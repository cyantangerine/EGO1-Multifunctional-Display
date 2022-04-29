`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2015 06:29:31 PM
// Design Name: 
// Module Name: seg7decimal
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


module seg7(
    input [47:0] x,
    input [7:0] dp,
    input clk,
    //input clr,
    //input [7:0]star,
    output reg [6:0] a_to_g1,
    output reg [3:0] an1,
    output reg [6:0] a_to_g2,
    output reg [3:0] an2,
    output reg dp1,
    output reg dp2//,
    //test
    /*output [19:0] clkdiv,
    output [5:0] digit1,
    output [5:0] digit2,
    output [3:0] aen*/
);


    wire [1:0] s;
    reg [5:0] digit1;
    reg [5:0] digit2;
    wire [3:0] aen;
    reg [19:0] clkdiv;
    //reg [7:0] onstar;

    initial begin
         dp1 = 0;
         dp2 = 0;
         //onstar = star;
    end
    assign s = clkdiv[19:18];
    assign aen = 4'b1111; // all turned off initially

    // quad 4to1 MUX.
    initial clkdiv = 20'b0;
    initial begin
        a_to_g1 = 7'b0000000;
        a_to_g2 = 7'b0000000;
    end
    always @(posedge clk) // or posedge clr)
    case(s)
        0:begin
            digit2 = x[23:18];
            digit1 = x[47:42];
            dp1 = dp[7];
            dp2 = dp[3];
        end // s is 00 -->0 ;  digit gets assigned 4 bit value assigned to x[3:0]
        1:begin
            digit2 = x[17:12];
            digit1 = x[41:36];
            dp1 = dp[6];
            dp2 = dp[2];
        end // s is 01 -->1 ;  digit gets assigned 4 bit value assigned to x[7:4]
        2:begin
            digit2 = x[11:6];
            digit1 = x[35:30]; // s is 10 -->2 ;  digit gets assigned 4 bit value assigned to x[11:8
            dp1 = dp[5];
            dp2 = dp[1];
        end
        3:begin
            digit2 = x[5:0];
            digit1 = x[29:24]; // s is 11 -->3 ;  digit gets assigned 4 bit value assigned to x[15:12]
            dp1 = dp[4];
            dp2 = dp[0];
        end
        default:begin
            digit2 = x[5:0];
            digit1 = x[29:24];
            dp1 = 0;
            dp2 = 0;
        end
    endcase

    //decoder or truth-table for 7a_to_g display values
    always @(*) begin
        case(digit1)
            //////////<---MSB-LSB<---
            //////////////gfedcba////////////////////////////////////////////              a
            0:a_to_g1 = 7'b0111111; ////0000                                                   __                    
            1:a_to_g1 = 7'b0000110; ////0001                                                f/      /b
            2:a_to_g1 = 7'b1011011; ////0010                                                                         __    
            3:a_to_g1 = 7'b1001111; ////0011                                              e /   /c
            4:a_to_g1 = 7'b1100110; ////0100                                                 __
            5:a_to_g1 = 7'b1101101; ////0101                                               d  
            6:a_to_g1 = 7'b1111101; ////0110
            7:a_to_g1 = 7'b0000111; ////0111
            8:a_to_g1 = 7'b1111111; ////1000
            9:a_to_g1 = 7'b1101111; ////1001
            'hA:a_to_g1 = 7'b1110111; // dash-(g)
            'hB:a_to_g1 = 7'b1111100; // all turned off
            'hC:a_to_g1 = 7'b0111001;
            'hD:a_to_g1 = 7'b1011110; // dash-(g)
            'hE:a_to_g1 = 7'b1111001; // all turned off
            'hF:a_to_g1 = 7'b1110001; //gfedcba
            16:a_to_g1 = 7'b0111101; //G
            17:a_to_g1 = 7'b1110110; //H
            18:a_to_g1 = 7'b0110000; //I
            19:a_to_g1 = 7'b0011110; //J
            20:a_to_g1 = 7'b1110100; //K
            21:a_to_g1 = 7'b0111000; //L
            22:a_to_g1 = 7'b0110111; //M
            23:a_to_g1 = 7'b1010100; //N
            24:a_to_g1 = 7'b1011100; //o
            25:a_to_g1 = 7'b1110011; //p
            26:a_to_g1 = 7'b1100111; //q
            27:a_to_g1 = 7'b1110000; //r
            28:a_to_g1 = 7'b1101101; //s
            29:a_to_g1 = 7'b1111000; //t
            30:a_to_g1 = 7'b0111110; //u
            31:a_to_g1 = 7'b0011100; //v
            32:a_to_g1 = 7'b0111110; //w
            33:a_to_g1 = 7'b1110110; //x
            34:a_to_g1 = 7'b1101110; //y
            35:a_to_g1 = 7'b1011011; //z
            36:a_to_g1 = 7'b0000001; //
            37:a_to_g1 = 7'b0000010; //
            38:a_to_g1 = 7'b0000100; //
            39:a_to_g1 = 7'b0001000; //
            40:a_to_g1 = 7'b0010000; //
            41:a_to_g1 = 7'b0100000; //
            42:a_to_g1 = 7'b0000111; //MµÄÓÒ°ë±ß
            63:a_to_g1 = 7'b0000000;
            default: a_to_g1 = 7'b1000000; // -
        endcase
    end
    always @(*) begin
        case(digit2)
            //////////<---MSB-LSB<---
            //////////////gfedcba////////////////////////////////////////////              a
            0:a_to_g2 = 7'b0111111; ////0000                                                   __                    
            1:a_to_g2 = 7'b0000110; ////0001                                                f/      /b
            2:a_to_g2 = 7'b1011011; ////0010                                                                         __    
            3:a_to_g2 = 7'b1001111; ////0011                                              e /   /c
            4:a_to_g2 = 7'b1100110; ////0100                                                 __
            5:a_to_g2 = 7'b1101101; ////0101                                               d  
            6:a_to_g2 = 7'b1111101; ////0110
            7:a_to_g2 = 7'b0000111; ////0111
            8:a_to_g2 = 7'b1111111; ////1000
            9:a_to_g2 = 7'b1101111; ////1001
            'hA:a_to_g2 = 7'b1110111; // dash-(g)
            'hB:a_to_g2 = 7'b1111100; // all turned off
            'hC:a_to_g2 = 7'b0111001;
            'hD:a_to_g2 = 7'b1011110; // dash-(g)
            'hE:a_to_g2 = 7'b1111001; // all turned off
            'hF:a_to_g2 = 7'b1110001; //gfedcba
            16:a_to_g2 = 7'b0111101; //G
            17:a_to_g2 = 7'b1110110; //H
            18:a_to_g2 = 7'b0110000; //I
            19:a_to_g2 = 7'b0011110; //J
            20:a_to_g2 = 7'b1110100; //K
            21:a_to_g2 = 7'b0111000; //L
            22:a_to_g2 = 7'b0110111; //M
            23:a_to_g2 = 7'b1010100; //N
            24:a_to_g2 = 7'b1011100; //o
            25:a_to_g2 = 7'b1110011; //p
            26:a_to_g2 = 7'b1100111; //q
            27:a_to_g2 = 7'b1110000; //r
            28:a_to_g2 = 7'b1101101; //s
            29:a_to_g2 = 7'b1111000; //t
            30:a_to_g2 = 7'b0111110; //u
            31:a_to_g2 = 7'b0011100; //v
            32:a_to_g2 = 7'b0111110; //w
            33:a_to_g2 = 7'b1110110; //x
            34:a_to_g2 = 7'b1101110; //y
            35:a_to_g2 = 7'b1011011; //z
            36:a_to_g2 = 7'b0000001; //
            37:a_to_g2 = 7'b0000010; //
            38:a_to_g2 = 7'b0000100; //
            39:a_to_g2 = 7'b0001000; //
            40:a_to_g2 = 7'b0010000; //
            41:a_to_g2 = 7'b0100000; //
            42:a_to_g2 = 7'b0000111; //MµÄÓÒ°ë±ß
            63:a_to_g2 = 7'b0000000;
            default: a_to_g2 = 7'b1000000; // -
        endcase
    end
    always @(*)begin
        an1=4'b0000;
        an2=4'b0000;
        if(aen[s] == 1)begin
            an1[s] = 1;
            an2[s] = 1;
        end
    end

    //clkdiv

    always @(posedge clk) begin
        //if ( clr == 1)
        //    clkdiv <= 0;
        //else
        clkdiv <= clkdiv+1;
    end

endmodule
