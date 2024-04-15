module mux_pc (
  input logic [31:0] pc_bru,
  input logic [31:0] pc_four,
  input logic is_taken,
  output logic [31:0] nxt_pc
  );

  assign nxt_pc = (is_taken)? pc_bru : pc_four;
  
endmodule