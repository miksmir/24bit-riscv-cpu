`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 03:26:46 PM
// Design Name: 
// Module Name: memory_tb
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


module memory_tb();

    // Driver inputs
    reg [23:0] tb_instruction_code;
    reg [23:0] tb_data_in;
    reg [14:0] tb_PC;
    reg tb_clk;
    reg tb_rst;
    reg tb_we_store_mem;
    reg tb_we_load_mem;
    // Outputs
    wire [23:0] tb_data_out_Instr;
    wire[23:0] tb_data_out_Data;
   
   // Instantiating of CPU module
    memory dut(
        .instruction_code(tb_instruction_code),
        .data_in_mem(tb_data_in),
        .mem_PC(tb_PC), // Program counter
        .mem_clk(tb_clk),
        .mem_rst(tb_rst),
        .we_store_mem(tb_we_store_mem),
        .we_load_mem(tb_we_load_mem),
        .data_out_Instr(tb_data_out_Instr), // Reading from Instruction memory block
        .data_out_Data(tb_data_out_Data) // Reading from Data memory block
   );
   
   // Initializing inputs
   initial begin
       tb_clk = 1'b1; // Start on posedge
       tb_data_in = {16{1'b0}};
       tb_rst = 1'b1; #1
       tb_rst = 1'b0; 
   end
   
   
   
   // Generate clock pulse
   always #5 tb_clk = ~tb_clk; // 100 MHz Clock, Period = 10ns

    initial begin
        $dumpfile("memory_dump.vcd");
        $dumpvars;
        $display("<<Memory Simulation Started>>");
       
       tb_we_load_mem = 1'b1;
       tb_we_store_mem = 1'b1;
       
        tb_PC = 15'd0;
        tb_instruction_code = 24'b1010_0000_0000_0000_0001_0001; // LD R1 <- DATA_MEM[1]
        #10;
        tb_PC = 15'd1;
        tb_instruction_code = 24'b1010_0000_0000_0000_0001_0010; // LD R2 <- DATA_MEM[2]
        #10;
        tb_PC = 15'd2;
        tb_instruction_code = 24'b0000_0011_0000_0001_0000_0010; // AddRR R3 <- R1 + R2
        #10;
        tb_PC = 15'd3;
        tb_instruction_code = 24'b1011_0000_0000_0000_1010_0011; // ST R3 -> MEM[10]
        #10;
        tb_PC = 15'd4;
        tb_instruction_code = 24'b1010_0000_0000_0000_1010_1010; // LD R10 <- MEM[10]
        #10;
        tb_PC = 15'd5;
        tb_instruction_code = 24'b1101_1011_0000_1010_0000_0011; // MULRA R11 <- R10 * 3
        #10;        
        tb_PC = 15'd6;
        tb_instruction_code = 24'b0011_0011_0000_1011_0000_1010; // XOR R3 <- R11 ^ R10
        #10;
        tb_PC = 15'd7;
        tb_instruction_code = 24'b1000_0000_0000_0000_0000_0000; // NOP
        #10;
        tb_PC = 15'd8;
        tb_instruction_code = 24'b0111_0000_0000_0001_0000_0000; // JMP R1 (R1 = line 3)
        #10;        
       
       
              $finish;
    end


endmodule
