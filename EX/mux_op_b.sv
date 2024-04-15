module mux_op_b(
  input logic [31:0] rs2_data,
  input logic [31:0] imm,
  input logic [1:0] op_b_sel,
  output logic [31:0] operand_b
  );

  assign operand_b = (op_b_sel== 2'b00)? rs2_data :
							(op_b_sel==2'b01)? imm: 
							(op_b_sel==2'b10)? 32'h4 : 32'b0;
	 
endmodule