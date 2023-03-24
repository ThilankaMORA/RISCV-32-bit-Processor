module Control_Unit(
      input[5:0] opcode,
      input reset,
      output reg[1:0] alu_op,reg_dst,mem_to_reg,
      output reg jump,beq,bne,mem_read,mem_write,alu_src,reg_write,sign_or_zero    
    );

  always @(*) begin
    if (reset == 1'b1) begin
        reg_dst = 2'b00;
        alu_src = 1'b0;
        mem_to_reg = 2'b00;
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        beq = 1'b0;
        bne = 1'b0;
        alu_op = 2'b00;
        jump = 1'b0;
        sign_or_zero = 1'b1;
      end
    else begin

    case(opcode)
      6'b000000:  // LW
        begin
          reg_dst = 2'b00;
          alu_src = 1'b1;
          mem_to_reg = 2'b01;
          reg_write = 1'b1;
          mem_read = 1'b1;
          mem_write = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          alu_op = 2'b10;
          jump = 1'b0;
          sign_or_zero = 1'b1;   
        end

      6'b000001:  // SW
        begin
          reg_dst = 2'bxx;
          alu_src = 1'b1;
          mem_to_reg = 2'bxx;
          reg_write = 1'b0;
          mem_read = 1'b0;
          mem_write = 1'b1;
          beq = 1'b0;
          bne = 1'b0;
          alu_op = 2'b10;
          jump = 1'b0;
          sign_or_zero = 1'b1;   
        end

       6'b000010:  // R-type
        begin
          reg_dst = 2'b01;
          alu_src = 1'b0;
          mem_to_reg = 2'b00;
          reg_write = 1'b1;
          mem_read = 1'b0;
          mem_write = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          alu_op = 2'b00;
          jump = 1'b0;
          sign_or_zero = 1'b1;   
        end
      
      6'b000011:  // BEQ
        begin
          reg_dst = 2'bxx;
          alu_src = 1'b0;
          mem_to_reg = 2'bxx;
          reg_write = 1'b0;
          mem_read = 1'b0;
          mem_write = 1'b0;
          beq = 1'b1;
          bne = 1'b0;
          alu_op = 2'b01;
          jump = 1'b0;
          sign_or_zero = 1'b1;   
        end

      6'b000100:  // BNE
        begin
          reg_dst = 2'bxx;
          alu_src = 1'b0;
          mem_to_reg = 2'bxx;
          reg_write = 1'b0;
          mem_read = 1'b0;
          mem_write = 1'b0;
          beq = 1'b0;
          bne = 1'b1;
          alu_op = 2'b01;
          jump = 1'b0;
          sign_or_zero = 1'b1;   
        end

      6'b000101:  // ADDI
        begin
          reg_dst = 2'b00;
          alu_src = 1'b1;
          mem_to_reg = 2'b00;
          reg_write = 1'b1;
          mem_read = 1'b0;
          mem_write = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          alu_op = 2'b10;
          jump = 1'b0; 
          sign_or_zero = 1'b1;  
        end

       6'b000110:  // J
        begin
          reg_dst = 2'bxx;
          alu_src = 1'b0;
          mem_to_reg = 2'bxx;
          reg_write = 1'b0;
          mem_read = 1'b0;
          mem_write = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          alu_op = 2'b00;
          jump = 1'b1;
          sign_or_zero = 1'b1; 
        end

      6'b000111:  // JAL
        begin
          reg_dst = 2'b10;
          alu_src = 1'b0;
          mem_to_reg = 2'b10;
          reg_write = 1'b1;
          mem_read = 1'b0;
          mem_write = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          alu_op = 2'b00;
          jump = 1'b1;
          sign_or_zero = 1'b1;   
        end
      
      6'b001000:  // SLTI
        begin
          reg_dst = 2'b00;
          alu_src = 1'b1;
          mem_to_reg = 2'b00;
          reg_write = 1'b1;
          mem_read = 1'b0;
          mem_write = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          alu_op = 2'b11;
          jump = 1'b0;
          sign_or_zero = 1'b0;  
        end

      default: begin
        reg_dst = 2'b01;
        alu_src = 1'b0;
        mem_to_reg = 2'b00;
        reg_write = 1'b1;
        mem_read = 1'b0;
        mem_write = 1'b0;
        beq = 1'b0;
        bne = 1'b0;
        alu_op = 2'b00;
        jump = 1'b0;
        sign_or_zero = 1'b1; 
      end
    endcase
  end
  end
endmodule
