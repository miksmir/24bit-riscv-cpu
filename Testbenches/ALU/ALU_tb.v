`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 12:16:52 PM
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb();

    // Driver inputs
    reg [23:0] tb_in1; 
    reg [23:0] tb_in2;
    reg [7:0] tb_absVal;
    reg [3:0] tb_alu_control;
    // Outputs
    wire [23:0] tb_alu_result;
   
   // Instantiating of CPU module
   ALU dut(
       .in1(tb_in1),
       .in2(tb_in2),
       .absVal(tb_absVal),
       .alu_control(tb_alu_control),
       .alu_result(tb_alu_result)
   );
   
    initial begin
        $dumpfile("ALU_dump.vcd");
        $dumpvars;
        $display("<<ALU Simulation Started>>");
        
        tb_alu_control = 4'b0000; // Addition operation
        tb_in1 = 24'b0000_0000_0000_0000_0000_1000; // Ra = 8
        tb_in2 = 24'b0000_0000_0000_0000_0000_0100; // Rb = 4
        #20;
        tb_alu_control = 4'b0001; // Subtraction operation
        tb_in1 = 24'b0000_0000_0000_0000_0001_0000; // Ra = 16
        tb_in2 = 24'b0000_0000_0000_0000_0000_0010; // Rb = 2
        #20;
        tb_alu_control = 4'b0010; // Multiplication operation
        tb_in1 = 24'b0000_0000_0000_0000_0000_0101; // Ra = 5
        tb_in2 = 24'b0000_0000_0000_0000_0000_0011; // Rb = 3
        #20;
        tb_alu_control = 4'b1100; // Absolute value addition operation
        tb_in1 = 24'b0000_1001; // 9
        tb_absVal = 8'b0000_0100; // 4
        #20;
        tb_alu_control = 4'b1101; // Absolute value multiplication operation
        tb_in1 = 24'b0000_0101; // 5
        tb_absVal = 8'b0000_0011; // 3
        #20;                           
        tb_alu_control = 4'b0011; // XOR operation
        tb_in1 = 24'b0000_0000_0000_0000_1111_1111; // Ra = 255
        tb_in2 = 24'b0000_0000_0000_0000_0000_0001; // Rb = 1
        #20;
        tb_alu_control = 4'b0100; // NOT operation
        tb_in1 = 24'b0000_0000_0000_0000_0000_0000; // 0
        #20;
        tb_alu_control = 4'b0101; // AND operation
        tb_in1 = 24'b0000_0000_0000_0000_0000_1111; // 15
        tb_in2 = 8'b0000_0100; // 4
        #20;
        tb_alu_control = 4'b0110; // OR operation
        tb_in1 = 24'b0000_0000_0000_0000_0000_0100; // 4
        tb_in2 = 8'b0000_1111; // 15      
          
        $finish;
    end

endmodule
