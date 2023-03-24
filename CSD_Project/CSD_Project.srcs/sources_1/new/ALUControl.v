module ALUControl(input [1:0] ALUOp, 
			input [5:0] Function,  // opcode
			output reg [4:0] ALU_Control
			);
  
    always @({ALUOp, Function}) 
        case ({ALUOp, Function})  
            8'b10xxxxxx: ALU_Control=5'b00000;  //Add lw,sw
            8'b01xxxxxx: ALU_Control=5'b00001;  //sub beq, bne
            8'b11xxxxxx: ALU_Control=5'b00110;  // SLTI (shift left immediate - I type)
            8'b00100000: ALU_Control=5'b00000;  // Add
            8'b00100010: ALU_Control=5'b00001;  // Sub
            8'b00100011: ALU_Control=5'b00010;  // And
            8'b00100100: ALU_Control=5'b00011;  // Or
            8'b00100101: ALU_Control=5'b00100;  // Xor
            8'b00100110: ALU_Control=5'b00101;  // Not 
            8'b00100111: ALU_Control=5'b00110;  // SLT
            8'b00101000: ALU_Control=5'b00111;  // LSL
            8'b00101001: ALU_Control=5'b01000;  // LSR
            
            default: ALU_Control=5'b00000;  
        endcase 
    
endmodule
