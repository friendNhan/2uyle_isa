module bru(
  input logic [31:0] rs1_data,
  input logic [1:0] is_control, // branch or jump
  input logic [31:0] imm,
  input logic [31:0] pc,
  input logic [2:0] bru_op,
  input logic br_unsigned,
  input logic br_less,
  input logic br_less_u,
  input logic br_equal,

  output logic is_taken,
  output logic [31:0] pc_bru
);
	logic [31:0] pc_b;
	logic [31:0] pc_jalr;
	
	// bru_op : 3'b000 : beq
	// bru_op : 3'b001 : bne
	// bru_op : 3'b010 : blt, bltu
	// bru_op : 3'b011 : bge, bgeu
	
	assign is_taken = (is_control[0]) | 
							((bru_op == 3'b000)&(br_equal))  |
							((bru_op == 3'b001)&(!br_equal)) | 
							((bru_op == 3'b010)&(br_less)&(!br_unsigned)) | 
							((bru_op == 3'b010)&(br_less_u)&(br_unsigned))|
							((bru_op == 3'b011)&(!br_less)&(!br_unsigned))|
							((bru_op == 3'b011)&(!br_less_u)&(br_unsigned));
	
	// is_control[1] : 1'b0 : branch , 1'b1 : jalr
	assign pc_b = pc + imm;
	assign pc_jalr = rs1_data + imm;
	assign pc_bru = (!is_control[1])? pc_b : pc_jalr;
endmodule
	