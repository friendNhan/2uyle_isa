module mux_op_a(
  input logic [31:0] pc,
  input logic [31:0] rs1_data,
  input logic is_pc,
  output logic [31:0] operand_a
  );

  assign operand_a = (is_pc==1'b1)? pc : rs1_data;

endmodule