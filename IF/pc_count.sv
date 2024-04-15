module pc_count #(
  parameter             DATA_WIDTH =32
  ) (
  input                          clk_i,
  input                          rst_ni,
  input logic [DATA_WIDTH-1:0] nxt_pc,
  output logic [DATA_WIDTH-1:0]   pc
);
  always_ff@(posedge clk_i or negedge rst_ni)
  begin
    if (rst_ni == 1'b0)
    begin
      pc <= 32'h00000000;
    end
  else
    begin
      pc <= nxt_pc;
    end
  end
endmodule

