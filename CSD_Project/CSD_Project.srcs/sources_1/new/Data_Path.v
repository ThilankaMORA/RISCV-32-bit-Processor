`timescale 1ns / 1ps


module Data_Path(
 input clk, rst,
 input jump,beq,mem_read,mem_write,alu_src,reg_write,bne,
 input[1:0] alu_op,reg_dst,mem_to_reg,
 output[5:0] opcode
);

 reg  [31:0] pc_current;
 wire signed[31:0] pc_next,pc2;
 wire [31:0] instr;
 wire [4:0] reg_write_dest;
 wire [31:0] reg_write_data;
 wire [4:0] reg_read_addr_1;
 wire [31:0] reg_read_data_1;
 wire [4:0] reg_read_addr_2;
 wire [31:0] reg_read_data_2;
 wire [31:0] ext_im,read_data2,sign_ext_im,zero_ext_im;
 wire [4:0] ALU_Control;
 wire [31:0] ALU_out;
 wire zero_flag;
 wire signed[31:0] PC_j,PC_beq,PC_2beq,PC_2bne,PC_bne,im_shift_2;
 wire beq_control, bne_control;
 wire [27:0] jump_shift;
 wire [31:0] mem_read_data;
 wire [31:0] no_sign_ext;  
 wire sign_or_zero;
 
 // PC 
 initial begin
  pc_current <= 32'd0;
 end

 always @(posedge clk)
 begin
   if (rst)
        pc_current <= 32'd0;
   else
        pc_current <= pc_next;
 end

 assign pc2 = pc_current + 32'd4;
 // instruction memory
 Instruction_Memory im(clk, pc_current,instr);
 // jump shift left 2
 assign jump_shift = {instr[25:0],2'b00};
 // multiplexer regdest
 assign reg_write_dest = (reg_dst==2'b10) ? {5{1'b1}}: ((reg_dst==2'b01) ? instr[15:11] :instr[20:16]); 
 // register file
 assign reg_read_addr_1 = instr[25:21];
 assign reg_read_addr_2 = instr[20:16];

 // GENERAL PURPOSE REGISTERs
 General_purpose_reg reg_file
 (clk, rst, reg_write, reg_write_dest, reg_write_data, reg_read_addr_1,
  reg_read_data_1, reg_read_addr_2, reg_read_data_2);

 assign sign_ext_im = {{16{instr[6]}},instr[15:0]};  
 assign zero_ext_im = {{16{1'b0}},instr[15:0]};  

 // immediate extend
 assign ext_im = (sign_or_zero==1'b1) ? sign_ext_im : zero_ext_im;
 // ALU control unit
 ALUControl ALU_Control_unit(alu_op,instr[5:0],ALU_Control);
 // multiplexer alu_src
 assign read_data2 = (alu_src==1'b1) ? ext_im : reg_read_data_2;
 // ALU 
 alu32 alu_unit(reg_read_data_1,read_data2,ALU_Control,ALU_out,zero_flag);
 // immediate shift 2  
 assign im_shift_2 = {ext_im[29:0],2'b00};
 //
 assign no_sign_ext = ~(im_shift_2) + 1'b1; 
 // PC beq add
 assign PC_beq = (im_shift_2[31] == 1'b1) ? (pc2 - no_sign_ext): (pc2 +im_shift_2);
 assign PC_bne = (im_shift_2[31] == 1'b1) ? (pc2 - no_sign_ext): (pc2 +im_shift_2);
 // beq control
 assign beq_control = beq & zero_flag;
 assign bne_control = bne & (~zero_flag);
 // PC_beq
 assign PC_2beq = (beq_control==1'b1) ? PC_beq : pc2;
 // PC_bne
 assign PC_2bne = (bne_control==1'b1) ? PC_bne : PC_2beq;
 // PC_j
 assign PC_j = {pc2[31:28],jump_shift};
 // PC_next
 assign pc_next = (jump == 1'b1) ? PC_j :  PC_2bne;

 /// Data memory
  Data_Memory dm
   (clk, ALU_out, reg_read_data_2, mem_write, mem_read, mem_read_data);
 
 // write back
 assign reg_write_data = (mem_to_reg == 2'b10) ? pc2:((mem_to_reg == 2'b01)? mem_read_data: ALU_out);
 // output to control unit
 assign opcode = instr[31:26];
endmodule