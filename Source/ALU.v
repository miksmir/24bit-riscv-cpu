/* ALU Control lines | Function
        0000    ADDRR Ry <- Ra + Rb
        0001    SUBRR Ry <- Ra - Rb
        0010	MULRR Ry <- Ra X Rb
        0011	XORRR Ry <- Ra ^ Rb
        0100	INV Ra Ry <- ~Ra
        0101    ANDRR Ry <- Ra & Rb
        0110    ORRR Ry <- Ra | Rb
        0111    XORRR PC <- Ra
        1000    NOP
        1001    RESERVED
        1010    LD Rb <- [Mem]
        1011    ST [Mem] <- Rb
        1100    ADDRA Ry <- Ra + #Imm
        1101    MULRA Ry <- Ra X #Imm
        1110    RESERVED
        1111    RESERVED
*/
module ALU (
    input [23:0] in1,in2,
    input [7:0] absVal
    input[3:0] alu_control,
    output reg [31:0] alu_result,
);
    always @(*)
    begin
      // Operating based on control input
        case(alu_control)

	//Register Operation
        4'b0000: alu_result = in1+in2;      //Ry <- Ra + Rb
        4'b0001: alu_result = in1-in2;      //Ry <- Ra - Rb
        4'b0010: alu_result = in1*in2;      //Ry <- Ra X Rb
        4'b0011: alu_result = in1^in2;      //Ry <- Ra ^ Rb
        4'b0100: alu_result = ~in1;         //Ry <- ~Ra
        4'b0101: alu_result = in1&in2;      //Ry <- Ra & Rb
        4'b0110: alu_result = in1|in2; 	//Ry <- Ra | Rb
	
	//Absolute
        4'b1100: alu_result = in1 + absVal; //Ry <- Ra + #Imm
        4'b1101: alu_result = in1 * absVal; //Ry <- Ra X #Imm

	//Jump
	//Delegated to Instruction Fetch inside CPU (4'b0111)

	//Memory
     //Delegated to a direct flag-based line between the two
     //LD Rb <- [Mem] (4'b1010)
     //ST [Mem] <- Rb (4'b1011)

	//Reserved or NOP
        //NOP (4'b1000)
        //RESERVED (4'b1001),(4'b1110),(4'b1111)

        endcase
    end
endmodule
