`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 12:44:44 AM
// Design Name: 
// Module Name: twofourcounter_tb
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


module twofourCounter_tb;
    reg clk;
    reg rst;
    reg [23:0] given_value;
    wire [23:0] count;
    
    twofourCounter dut ( .clk(clk), .rst(rst), .given_value(given_value), .count(count));
    
    always begin
    #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        rst = 0;
        given_value = 4'b1010;
        rst = 1;
        #1;
        rst = 0;
        #105;
        $finish;
    end
endmodule
