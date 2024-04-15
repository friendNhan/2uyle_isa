module sign_extend(
  input logic [31:0] instr,
  input logic [2:0] imm_sel,

  output logic [31:0] imm
  );

  //--- imm = 3'b000 : R-Format -- 3'b001 : I-Format and JALR
  //--- imm = 3'b010 : S-Format -- 3'b011 : B-Format 
  //--- imm = 3'b100 : U-Format -- 3'b101 : JAL
  assign imm = (imm_sel == 3'b000)? 32'd0 :
    (imm_sel == 3'b001)? {{20{instr[31]}},instr[31:20]} :
    (imm_sel == 3'b010)? {{20{instr[31]}},instr[31:25],instr[11:7]} :
    (imm_sel == 3'b011)? {{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0}:
    (imm_sel == 3'b100)? {instr[31:12],{12{1'b0}}} :
    (imm_sel == 3'b101)? {{11{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:25],instr[24:21],{1'b0}}: 32'd0;
endmodule
    