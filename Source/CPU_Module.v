module CPU_24b(
    input clk,
    input rst,
    input [23:0] instr,
    input [15:0] data_in,
    output reg [15:0] iaddr,
    output reg [15:0] daddr,
    output [15:0] data_out,	
    output data_wr // bit for if data was written
    );
    
    // instr opcode structure: 
    // RR type: [ instr[23:20] instr[19:16] instr[15:8] instr[7:0] ]
    //               CMD            DST          Ra          Rb
    
    // RA type: [ instr[23:20] instr[19:16] instr[15:8] instr[7:0] ]
    //                  CMD         DST         Ra          Abs
    
    // Mem type: [ instr[23:20] instr[19:4] instr[3:0] ]
    //                  CMD         Mem         Rb
    
    /*Instruction opcodes
    parameter OP_ADDRR = 4'b0000;
    parameter OP_SUBRR = 4'b0001;
    parameter OP_MULRR = 4'b0010;
    parameter OP_XOR   = 4'b0011;
    parameter OP_INV   = 4'b0100;
    parameter OP_AND   = 4'b0101;
    parameter OP_OR    = 4'b0110;
    parameter OP_JMP   = 4'b0111;
    parameter OP_NOP   = 4'b1000;
    parameter OP_LD    = 4'b1010;
    parameter OP_ST    = 4'b1011;
    parameter OP_ADDRA = 4'b1100;
    parameter OP_MULRA = 4'b1101;
    */
    // Reserved opcodes
    //parameter OP_RESERVED = 4'b1001;
    //parameter OP_RESERVED = 4'b1110;
    //parameter OP_RESERVED = 4'b1111;
      
    // Datapath Module
 /////////////////////////////////////////////////////////////////////
	always @(negedge clk or posedge rst)
		begin
			if(~rst) begin
			//Reset signals by setting all flags down (<=)
			we <= 0;
			PC_update_flag <= 0;
			we_load_Mem <= 0;
			we_store_Mem <= 0;
			end
			
			
			else if (alu_control_temp == 4'd10) begin
			//Load  Memory to Register flag enabled
			we_load_Mem <= 1;
			
			end
			
			else if (alu_control_temp == 4'd11) begin
			///Store  Register to Memory flag enabled
			we_store_Mem <= 1;
			end
			
			else if (alu_control_temp == 4'd7) begin
			//JMP instruction by enabling the JMP flag
			PC_update_flag <= 1;
			end
			
			else if (alu_control_temp < 4'd7 ||
 alu_control_temp == 4'd12 || alu_control_temp == 4'd13) begin
			//Register based arithmetic instructions enabled
			we <= 1; 
			end
			
			else /*if (alu_control_temp == 4'd8 || alu_control_temp == 4'd9
			|| alu_control_temp == 4'd14 || alu_control_temp == 4'd15) */ begin
			//Execute a NOP instruction by skiping a negedge cycle or 2 posedge cycles
			//Disable all writing
			we <=0;
			PC_update_flag <= 0;
			we_load_Mem <= 0;
			we_store_Mem <= 0;
			
			end			
		end
	
    // Register File with integrated Write Back (WB) Instantiation
////////////////////////////////////////////////////////////////////
    reg we; // Write enable
	
    REG_FILE reg_file_0(
		   .reg_import_to_address(goes_to_reg_address), //Data to be stored in the register 
           .reg_read_addr1(instr[15-4:8]), // Address of Ra
           .reg_read_addr2(instr[7-4:0]), // Address of Rb 
           .reg_write_addr(instr[19:16]), // Address of Ry
           .reg_data_in(alu_result_temp), // 24 bit data for writing to Ry          
           .reg_clk(clk), //Global clk
           .reg_rst(rst), //Global rst
           .reg_we(we), //Write flag for ALU arithmetic
		   .mem_to_reg_we(we_load_Mem), // LD flag
		   .reg_to_mem_we(we_store_Mem) // ST flag
           .reg_data_out1(data_out1), // Read data of Ra (instantly)
           .reg_data_out2(data_out2), // Read data of Rb (instantly)
		   .reg_data_out3(data_out3) //Read data of select Reg for Store
    );
    
    
// Memory
/////////////////////////////////////////////////////////////////////
		
		reg we_store_Mem; //Initiating the ST flag
		reg we_load_Mem;  //Initiating the LD flag
		
    memory mem0(
		.instruction_code(instr[19:4]),//Memory index from op code
		.data_in_mem(data_out3), //
		.mem_PC(PC), //Connect PC from IF to Memory
		.mem_clk(clk),//Global clk connect
		.mem_rst(rst),//Global rst connect
		.we_store_mem(we_store_Mem), //Flag for ST instruction
		.we_load_mem(we_load_Mem), //Flag for LD instruction
		.data_out_Instr(instr), //Load op code
		.data_out_Data(goes_to_reg_address) // Mem data to LD Reg
	);
    

    // Instruction Fetch Unit
    /////////////////////////////////////////////////////////////////////
 
		// Program Counter
		reg [23:0] PC;
    
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            PC <= 0;
        end
		else if (PC_update_flag) begin
		PC <= data_out1; // Replace PC with Ra for JMP
		end
        else begin
            PC <= PC + 1; //Proceed to the next word
        end
    end
    

    
    // Instruction Decoder / Control Unit (Generates control signals for ALU) Initialization
    /////////////////////////////////////////////////////////////////////
    reg [3:0] alu_control_temp; //ALU control connector variable
    
    Instruction_Decode ID(
        .cmMS(instr[23:22]), //Two most significant bits of CMD
        .cmLS(instr[21:20]), //Two least significant bits of CMD
        .alu_control(alu_control_temp), //ALU control signal
    );
    
    
    // ALU Instantiation
    /////////////////////////////////////////////////////////////////////

    ALU alu0(
        .in1(data_out1), // Data of Ra
        .in2(data_out2), // Data of Rb
        .absVal(instr[7:0]), //Address from #abs case opp code
        .alu_control(instr[23:20]), //Control signal from CMD
        .alu_result(data_out) //Calculated ALU result
    );
    
endmodule