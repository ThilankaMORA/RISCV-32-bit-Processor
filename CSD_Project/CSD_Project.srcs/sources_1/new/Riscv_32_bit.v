`timescale 1ns / 1ps 

module Riscv_32_bit(
 input clk,rst
 );
 wire jump,bne,beq,mem_read,mem_write,alu_src,reg_write,sign_or_zero;
 wire[1:0] alu_op,reg_dst,mem_to_reg;
 wire [5:0] opcode;
 // Datapath
 Data_Path DU
 (
  .clk(clk),
  .rst(rst),
  .jump(jump),
  .beq(beq),
  .mem_read(mem_read),
  .mem_write(mem_write),
  .alu_src(alu_src),
  .reg_dst(reg_dst),
  .mem_to_reg(mem_to_reg),
  .reg_write(reg_write),
  .bne(bne),
  .alu_op(alu_op),
  .opcode(opcode)
 );

 // control unit
 Control_Unit control
 (
  .opcode(opcode),
  .reset(rst),
  .reg_dst(reg_dst),
  .mem_to_reg(mem_to_reg),
  .alu_op(alu_op),
  .jump(jump),
  .bne(bne),
  .beq(beq),
  .mem_read(mem_read),
  .mem_write(mem_write),
  .alu_src(alu_src),
  .reg_write(reg_write),
  .sign_or_zero(sign_or_zero)
 );

endmodule
