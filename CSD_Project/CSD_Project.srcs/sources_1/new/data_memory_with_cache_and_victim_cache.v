module data_memory_with_cache_and_victim_cache(
  input clk,
  input [31:0] addr,
  input [31:0] wdata,
  input we,
  input mem_read,
  output [31:0] rdata
);
  reg [31:0] mem [7:0];
  reg [31:0] cache_data;
  reg [10:0] cache_addr;
  reg cache_valid;
  reg [31:0] victim_data;
  reg [10:0] victim_addr;
  reg victim_valid;
  reg [31:0] write_buffer_data;
  reg [2:0] write_buffer_addr;
  reg write_buffer_valid;
  reg write_buffer_we;
  reg flush;

  always@(posedge clk) begin
    // Write to write buffer
    if (we) begin
      write_buffer_data <= wdata;
      write_buffer_addr <= addr[2:0];
      write_buffer_valid <= 1'b1;
      write_buffer_we <= 1'b1;

      // Check if cache hit
      if (cache_valid && cache_addr == addr[2:0]) begin
        cache_data <= wdata;
      end

      // Check if cache miss
      else if (cache_valid && cache_addr != addr[2:0]) begin
        // Check if victim cache hit
        if (victim_valid && victim_addr == addr[2:0]) begin
          cache_data <= victim_data;
          cache_addr <= victim_addr;
          victim_valid <= 1'b0;
        end

        // Victim cache miss
        else begin
          victim_data <= cache_data;
          victim_addr <= cache_addr;
          victim_valid <= 1'b1;
          cache_data <= write_buffer_data;
          cache_addr <= write_buffer_addr;
        end
        cache_valid <= 1'b1;
      end

      // First write
      else begin
        cache_data <= write_buffer_data;
        cache_addr <= write_buffer_addr;
        cache_valid <= 1'b1;
      end
    end

    // Flush write buffer
    if (flush) begin
      write_buffer_valid <= 1'b0;
      write_buffer_we <= 1'b0;
      flush <= 1'b0;
    end

    // Write to main memory
    if (write_buffer_valid && write_buffer_we) begin
      mem[write_buffer_addr] <= write_buffer_data;
      write_buffer_valid <= 1'b0;
      write_buffer_we <= 1'b0;
    end
  end

  assign rdata = (mem_read == 1'b1) ?
  (cache_valid && cache_addr == addr[2:0]) ? cache_data :
  (victim_valid && victim_addr == addr[2:0]) ? victim_data :
  mem[addr[2:0]] : 32'b0;

endmodule
