module Instruction_Decode(
    input [1:0] cmMS, // 2 MSBs of instruction portion of Opcode
    input [1:0] cmLS, // 2 LSBs of instruction portion of Opcode
    output reg [3:0] alu_control,
    output reg regwrite_control
);
    always @(cmMS or cmLS)
    begin
        regwrite_control = 1;
        case (cmMS)
            0: begin
                if(cmLS == 0)
                    alu_control = 4'd0; // ADDRR Ry <- Ra + Rb
                else if(cmLS == 1)
                    alu_control = 4'd1; // SUBRR Ry <- Ra - Rb
		        else if(cmLS == 2)
                    alu_control = 4'd2; // MULRR Ry <- Ra X Rb
		        else if(cmLS == 3)
                    alu_control = 4'd3; // XORRR Ry <- Ra ^ Rb
                end
		   1: begin
                if(cmLS == 0)
                    alu_control = 4'd4; // INV Ra Ry <- ~Ra
                else if(cmLS == 1)
                    alu_control = 4'd5; // ANDRR Ry <- Ra & Rb
		        else if(cmLS == 2)
                    alu_control = 4'd6; // ORRR Ry <- Ra | Rb
		        else if(cmLS == 3)
                    alu_control = 4'd7; // JMP PC <- Ra
               end
		2: begin
                if(cmLS == 0)
                    alu_control = 4'd8; // NOP
                else if(cmLS == 1)
                    alu_control = 4'd9; // RESERVED
		        else if(cmLS == 2)
                    alu_control = 4'd10; // LD Rb <- [Mem]
		        else if(cmLS == 3)
                    alu_control = 4'd11; // ST [Mem] <- Rb
                end
		3: begin
                if(cmLS == 0)
                    alu_control = 4'd12; // ADDRA Ry <- Ra + #Imm
                else if(cmLS == 1)
                    alu_control = 4'd13; // MULRA Ry <- Ra X #Imm
		        else if(cmLS == 2)
                    alu_control = 4'd14; // RESERVED
		        else if(cmLS == 3)
                    alu_control = 4'd15; // RESERVED
                end
            endcase
    end
endmodule