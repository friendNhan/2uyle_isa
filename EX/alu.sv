module alu(
  input logic [31:0] operand_a,
  input logic [31:0] operand_b,
  input logic [3:0] ALUControl,
  
  output logic [31:0] Result,
  output logic Z,
  output logic N,
  output logic V,
  output logic C
);
 
  wire logic [31:0] a_and_b;
  wire logic [31:0] a_or_b;
  wire logic [31:0] a_xor_b;
  wire logic [31:0] not_b;

  wire logic [31:0] mux_1;

  wire logic [31:0] sum;

  wire logic [31:0] mux_2;

  wire logic [31:0] slt;
  
  wire logic [31:0] sltu;
  
  wire logic [31:0] a_shift_left_b;
  
  wire logic [31:0] a_shift_right_b;
  
  wire logic [31:0] a_sr_arith_b;

  wire logic cout;

  // logic design

  // AND
  assign a_and_b = operand_a & operand_b;

  // OR
  assign a_or_b = operand_a | operand_b;
  
  // XOR
  assign a_xor_b = operand_a ^ operand_b;

  // NOT on b
  assign not_b = ~operand_b;

  // Ternary
  assign mux_1 = (ALUControl[0] == 1'b0)? operand_b : not_b; 

  // Addition / Substraction
  assign {cout,sum} = operand_a + mux_1 + ALUControl[0];

  // Set less than
  //assign slt = 
  
  assign slt = {31'b0000000000000000000000000000000,sum[31]};
  
  assign sltu = {31'b0000000000000000000000000000000,~cout};
  
  // Shift (Left, Right, Right Arithmetic)
  // --- shift_sel = funct3[2] = 0? left : right;
  shift_left shift_left( // dich trai thanh ghi rs1 di imm bit
			.rs1(operand_a),
			.imm(operand_b[4:0]),
			.rd_left(a_shift_left_b)
			);
  shift_right shift_right(
			.rs1(operand_a),
			.imm(operand_b[4:0]),
			.rd_right(a_shift_right_b)
			);
  shift_right_arith shift_right_arith(
			.rs1(operand_a),
			.imm(operand_b[4:0]),
			.rd_right_arith(a_sr_arith_b)
			);
  
  // Design 4by1 Mux
  assign mux_2 = (ALUControl[3:0] == 4'b0000)? sum : // add 
					  (ALUControl[3:0] == 4'b0001)? sum :  // sub
					  (ALUControl[3:0] == 4'b0010)? a_shift_left_b : // sll and srl
					  (ALUControl[3:0] == 4'b0111)? sltu :
					  (ALUControl[3:0] == 4'b0011)? slt :	// slt
					  (ALUControl[3:0] == 4'b0101)? a_xor_b : 
					  (ALUControl[3:0] == 4'b0110)? a_shift_right_b : //srl
					  (ALUControl[3:0] == 4'b0100)? a_sr_arith_b : //sra
					  (ALUControl[3:0] == 4'b1000)? a_or_b : 
					  (ALUControl[3:0] == 4'b1001)? a_and_b : 32'h00000000;
	


  assign Result = mux_2;

  // Flags
  assign Z = &(~Result); 					// Zero Flag

  assign N = Result[31]; 					// Negative Flag

  assign C = cout & (~ALUControl[1]); // Carry Flag

  assign V = (~ALUControl[1]) & (operand_a[31] ^ sum[31]) & (~(operand_a[31] ^ operand_b[31] ^ ALUControl[0])); // Overflow Flag
  
  
endmodule