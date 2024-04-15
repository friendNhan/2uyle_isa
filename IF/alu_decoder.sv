module alu_decoder(
  input logic [6:0] funct7,
  input logic [2:0] funct3,
  input logic [2:0] alu_op,
  output logic [3:0] ALUControl
  );

  assign ALUControl =((alu_op == 3'b000) & (funct3 == 3'b000)&(funct7[5] == 0)) ? 4'b0000 : // add
							((alu_op == 3'b011) & (funct3 == 3'b000))? 4'b0000 :
							((alu_op == 3'b000) & (funct3 == 3'b000)&(funct7[5] == 1)) ? 4'b0001 : // sub
							(((alu_op == 3'b000) | (alu_op == 3'b011)) & (funct3 == 3'b010)) ? 4'b0011 : // slt, slti
							(((alu_op == 3'b000) | (alu_op == 3'b011)) & (funct3 == 3'b011)) ? 4'b0111 : // sltu, sltui
							(((alu_op == 3'b000) | (alu_op == 3'b011)) & (funct3 == 3'b100)) ? 4'b0101 : // xor, xori
							(((alu_op == 3'b000) | (alu_op == 3'b011)) & (funct3 == 3'b001)) ? 4'b0010 : // sll, slli
							(((alu_op == 3'b000) | (alu_op == 3'b011)) & (funct3 == 3'b101)&(funct7[5] == 0)) ? 4'b0110 : // srl, srli
							(((alu_op == 3'b000) | (alu_op == 3'b011)) & (funct3 == 3'b101)&(funct7[5] == 1)) ? 4'b0100 : // sra, srai
							(((alu_op == 3'b000) | (alu_op == 3'b011)) & (funct3 == 3'b110)) ? 4'b1000 : // or, ori
							(((alu_op == 3'b000) | (alu_op == 3'b011)) & (funct3 == 3'b111)) ? 4'b1001 : // and, andi
							(alu_op == 3'b001)? 4'b0001 : // B type
							(alu_op == 3'b100)? 4'b0000 : // Load 
							(alu_op == 3'b010)? 4'b0000 : // S type
							(alu_op == 3'b101)? 4'b0000 : // J type
							(alu_op == 3'b110)? 4'b0000 : // U type
							(alu_op == 3'b011)? 4'b0000 : 4'b1111;

endmodule 