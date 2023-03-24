`timescale 1ns / 1ps

module alu32 (input [31:0] a, b,
               input [4:0] alu_opcode,
               output reg [31:0] result,
               output reg zero);

  always @(*) begin
    result = 0;
    zero = 1'b0;
    case (alu_opcode)
      5'b00000: result = a + b; // addition
      5'b00001: result = b - a; // subtraction
      5'b00010: result = a & b; // bitwise AND
      5'b00011: result = a | b; // bitwise OR
      5'b00100: result = a ^ b; // bitwise XOR
      5'b00101: result = ~a; // bitwise NOT of a
      5'b00110: begin if (a<b) result = 32'd1; // set on less than
                        else result = 32'd0;
                      end 
      5'b00111: result = a << b; // shift left
      5'b01000: result = a >> b; // shift right

      default : result = a + b; // addition
    endcase

    zero = (result==32'd0) ? 1'b1: 1'b0;

    if ((a[31] == b[31]) && (result[31] != a[31])) begin
      result = {31{1'b1}}; // default overflow output
    end

    else if (result[31] == 1) begin
      result = {31{1'b1}};   //negative output
    end

  end

endmodule
