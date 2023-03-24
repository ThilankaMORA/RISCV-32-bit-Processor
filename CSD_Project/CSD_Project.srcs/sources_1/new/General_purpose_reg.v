`timescale 1ns / 1ps

module General_purpose_reg(
 input    clk,
 input    rst,  
 // write port
 input    reg_write_en,
 input  [4:0] reg_write_dest,
 input  [31:0] reg_write_data,
 //read port 1
 input  [4:0] reg_read_addr_1,
 output [31:0] reg_read_data_1,
 //read port 2
 input  [4:0] reg_read_addr_2,
 output [31:0] reg_read_data_2
);
 
 reg [31:0] reg_array [31:0];

 integer i;
 always @ (*)
   if (rst) begin
     // reset registers
     for(i=0;i<32;i=i+1) begin
       reg_array[i] <= 32'b0;
     end
   end
 
 // write port
 always @ (posedge clk) begin
    if(reg_write_en && rst == 1'b0) begin
      reg_array[reg_write_dest] <= reg_write_data;
   end
 end
 
 // read ports
 assign reg_read_data_1 = ( reg_read_addr_1 == 0)? 32'b0 : reg_array[reg_read_addr_1];
 assign reg_read_data_2 = ( reg_read_addr_2 == 0)? 32'b0 : reg_array[reg_read_addr_2];
 
endmodule
