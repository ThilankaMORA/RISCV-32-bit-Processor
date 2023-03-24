`timescale 1ns / 1ps

`define simulation_time #160

module testbench;

reg clk;
Riscv_32_bit uut(clk, rst);

initial begin
clk <= 0;
`simulation_time;
$finish;
end

always begin 
#5 clk = ~clk;
end

endmodule
