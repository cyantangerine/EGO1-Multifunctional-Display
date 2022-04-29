`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/30 12:44:39
// Design Name: 
// Module Name: M1_TestViewer
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


module M1_TextViewer(
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
    output     [15:0]OUT_LED//,
    );
    viewer t(
        .clk_pin        (IN_CLK),
        .x              (IN_SWITCH),
        .btn            (IN_BTN),
        .seg7_0_7bit    (OUT_SEG0DATA),
        .seg7_1_7bit    (OUT_SEG1DATA),
        .seg7_0_an      (OUT_SEG0SELE),
        .seg7_1_an      (OUT_SEG1SELE),
        .seg7_0_dp      (OUT_SEG0DP),
        .seg7_1_dp      (OUT_SEG1DP),
        .led            (OUT_LED)
    );
endmodule
