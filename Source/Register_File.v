module REG_FILE #(
    parameter SIZE = 24, // 24-bit sized registers
    parameter DEPTH = 16 // 16 registers (4 bit address)
    )
    (
	input [4-1:0] reg_import_to_address, //Address for Memory to Register Operation
    input [4-1:0] reg_read_addr1, // Address of register Ra that will be read
    input [4-1:0] reg_read_addr2, // Address of register Rb that will be read
    input [4-1:0] reg_write_addr, // Address of register Ry that will be written to
    input [SIZE-1:0] reg_data_in, // Input data to be written  
    input reg_clk, //Global clk
    input reg_rst, //Global rst
    input reg_we, // Write to Register enable
	input mem_to_reg_we, //Write from Memory to Register
	input reg_to_mem_we, //Write to Register from Memory
    output [SIZE-1:0] reg_data_out1, // Output data read from register Ra
    output [SIZE-1:0] reg_data_out2 // Output data read from register Rb  
	output [SIZE-1:0] reg_data_out3 //Output data read from select register
    );
    
    reg [SIZE-1:0] reg_data [DEPTH-1:0]; // Register memory locations (16 registers of 24 bits each)
    
    // Dummy values for registers on reset
    always @(posedge reg_rst) begin
        reg_data[0]  = {24{1'b0}};
        reg_data[1]  = {24{1'b0}};
        reg_data[2]  = {24{1'b0}};
        reg_data[3]  = {24{1'b0}};
        reg_data[4]  = {24{1'b0}};
        reg_data[5]  = {24{1'b0}};
        reg_data[6]  = {24{1'b0}};
        reg_data[7]  = {24{1'b0}};
        reg_data[8]  = {24{1'b0}};
        reg_data[9]  = {24{1'b0}};
        reg_data[10] = {24{1'b0}};
        reg_data[11] = {24{1'b0}};
        reg_data[12] = {24{1'b0}};
        reg_data[13] = {24{1'b0}};
        reg_data[14] = {24{1'b0}};
        reg_data[15] = {24{1'b0}};
    end
   
    
    // Read data stored in Ra and Rb
    // (reg_read_addr is the register index)
    assign reg_data_out1 = reg_data[reg_read_addr1];
    assign reg_data_out2 = reg_data[reg_read_addr2];
    
    // Write Logic
    // At each clock pulse, write data to reg
    always @(posedge reg_clk) begin
        if(reg_we) begin
            //reg_write_addr is the register index
            reg_data[reg_write_addr] <= reg_data_in;
        end
    end
	always @(posedge reg_clk) begin
        if(mem_to_reg_we) begin
            //mem_to_reg_write_addr is the register index
            reg_data[reg_read_addr2] <= reg_import_to_address;
        end
    end
		always @(posedge reg_clk) begin
        if(reg_to_mem_we) begin
            //reg_to_mem_write_addr is the register index
            reg_data_out3 <= reg_data[reg_read_addr2];
        end
    end   
endmodule