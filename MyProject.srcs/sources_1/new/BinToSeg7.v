`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/30 21:22:58
// Design Name: 
// Module Name: BinToSeg7
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


module BinToBCD(
    input wire clk, nrst,
    input wire start,
    output reg valid,
    input [27:0]bin,
    output reg [47:0]bcd,
    output reg [47:0]x
    );   
    reg [27:0] bin_in;
    reg op;
    reg [3:0] cnt;

    always @(posedge clk or negedge nrst) begin
    if(nrst == 0)
            bin_in <= 0;
    else if(start)
        bin_in <= bin;
    end
    
    always @(posedge clk or negedge nrst) begin
        if(nrst == 0)
            op <= 0;
        else if(start)
            op <= 1;
        else if(cnt == 9 - 1)
            op <= 0;
    end

    always @(posedge clk or negedge nrst) begin
        if(nrst == 0)
            cnt <= 0;
        else if(op)
            cnt <= cnt + 1'b1;
        else
            cnt <= 0;
    end

    function [3:0] fout(input reg [3:0] fin);
        fout = (fin > 4) ? fin + 4'd3 : fin;
    endfunction

    always @(posedge clk or negedge nrst) begin
        if(nrst == 0)
            bcd <= 0;
        else if(op) begin
            bcd[0] <= bin_in[8-cnt];
            bcd[4:1] <= fout(bcd[3:0]);
            bcd[8:5] <= fout(bcd[7:4]);
            bcd[12:9] <= fout(bcd[11:8]);
            bcd[16:13] <= fout(bcd[15:12]);
            bcd[20:17] <= fout(bcd[19:16]);
            bcd[24:21] <= fout(bcd[23:20]);
            bcd[28:25] <= fout(bcd[27:24]);
            bcd[32:29] <= fout(bcd[31:28]);
            //bcd[36:33] <= fout(bcd[35:32]);
            //bcd[40:37] <= fout(bcd[39:36]);
            //bcd[44:41] <= fout(bcd[43:40]);
            //bcd[47:45] <= fout(bcd[47:44]);
          end
        else
            bcd <= 0;
    end

    always @(posedge clk or negedge nrst) begin
    if(nrst == 0)
        valid <= 0;
    else if(cnt == 9 - 1) begin
        x[47:0] = 48'b0;
        x[5:0] = bcd[3:0];
        x[11:6] = bcd[7:4];
        x[17:12] = bcd[11:8];
        x[23:18] = bcd[15:12];
        x[29:24] = bcd[19:16];
        x[35:30] = bcd[23:20];
        x[41:36] = bcd[27:24];
        x[47:42] = bcd[31:28];
        
        valid <= 1;end
    else
        valid <= 0;    
    end
endmodule
