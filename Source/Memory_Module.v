module memory(
    input [23:0] instruction_code, // Used for reading or writing to data memory address
    input [23:0] data_in_mem, // Data to be written to data memory address
	input[14:0] mem_PC, // Program counter (used for instruction memory address)
	input mem_clk,
	input mem_rst,
    input we_store_mem, // Storing occurs when flag is up (1) at posedge clk cycle
	input we_load_mem,	// Loading occurs when flag is up (1) at posedge clk cycle
    output [23:0] data_out_Instr, // Output of opcode stored in Instruction Memory
    output[23:0] data_out_Data // Output of data stored in Data Memory
);

parameter INSTR_MEM_DEPTH = 32_768; // 32K instructions (represented by 2^15 address lines)
parameter DATA_MEM_DEPTH = 16_384; // 16K 24-bit words (represented by 2^14 address lines)
parameter DATA_WIDTH = 24;

// Instruction memory instantiation using Block RAM
reg [DATA_WIDTH-1:0] instruction_mem [0:INSTR_MEM_DEPTH-1];





    
always @(posedge mem_rst) begin
    // Opcodes of program to be executed
    // LD R1 <- DATA_MEM[1]:
    instruction_mem[0] = 24'b1010_0000_0000_0000_0001_0001;
    // LD R2 <- DATA_MEM[2]:
    instruction_mem[1] = 24'b1010_0000_0000_0000_0001_0010;
    // AddRR R3 <- R1 + R2:
    instruction_mem[2] = 24'b0000_0011_0000_0001_0000_0010;
    // ST R3 -> MEM[10]:
    instruction_mem[3] = 24'b1011_0000_0000_0000_1010_0011;
    // LD R10 <- MEM[10]: 
    instruction_mem[4] = 24'b1010_0000_0000_0000_1010_1010;
    // MULRA R11 <- R10 * 3: 
    instruction_mem[5] = 24'b1101_1011_0000_1010_0000_0011;
    // XOR R3 <- R11 ^ R10:
    instruction_mem[6] = 24'b0011_0011_0000_1011_0000_1010;
    // NOP:
    instruction_mem[7] = 24'b1000_0000_0000_0000_0000_0000;
    // JMP R1 (R1 = line 3):
    instruction_mem[8] = 24'b0111_0000_0000_0001_0000_0000; 
                
end

// Data memory instantiation using Block RAM
reg [DATA_WIDTH-1:0] data_mem [0:DATA_MEM_DEPTH-1];




always @(posedge mem_rst) begin
    // Hardcoded values in memory
    data_mem[1] = 24'b0000_0000_0000_0000_0000_0011; // Dummy value initialized as "3" for R1
    data_mem[2] = 24'b0000_0000_0000_0000_0000_0111; // Dummy value initialized as "7" for R2        
end

// Instruction memory read
assign data_out_Instr = instruction_mem[mem_PC]; // Reading from 16-bit memory address in opcode

// Data load from Memory to Register
always @ (posedge mem_clk) begin
	if (we_load_mem) begin
        data_out_Data <= data_mem[instruction_code[19:4]]; 
		//data_out_Data should go to register
	end
end
//Data store from Register to Memory
always @ (posedge mem_clk) begin
	if (we_store_mem) begin
        data_mem[instruction_code[19:4]] <= data_in_mem; 
		//data_in_mem should be the register data
	end
end

endmodule