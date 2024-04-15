  //  `timescale 1ns/10ps 
  module alu_tb;

     logic [31:0]     operand_a;
     logic [31:0]     operand_b;
   logic [31:0]     a_shift_left_b;
   logic [31:0]     a_shift_right_b;
   logic [31:0]     a_sr_arith_b;
     logic [3:0]      ALUControl;
     logic [6:0]      funct7;
     logic [2:0]      funct3;
     logic [2:0]      alu_op;
   logic [31:0]     Result;
   logic            Z;
   logic 			  N;
   logic 			  V;
   logic 			  C;

   alu dut(
       .operand_a(operand_a),
       .operand_b(operand_b),
       .ALUControl(ALUControl),
       .Result(Result),
       .Z(Z),
     .N(N),
     .V(V),
     .C(C)
     );
  shift_left shift_left( 
      .rs1(operand_a),
      .imm(operand_b),
      .rd_left(a_shift_left_b)
      );
  shift_right shift_right(
      .rs1(operand_a),
      .imm(operand_b),
      .rd_right(a_shift_right_b)
      );
  shift_right_arith shift_right_arith(
      .rs1(operand_a),
      .imm(operand_b),
      .rd_right_arith(a_sr_arith_b)
      );



    task tk_expect(
         input logic [31:0] Result_x 
     );
      $display("[%3d] Result = %8h, Result_x = %8h", $time,Result[31:0],Result_x[31:0]);
      assert(Result==Result_x) else begin
        $display("TEST FAILED"); 
        $stop;
      end
    endtask

      initial begin

    operand_a = 32'h23456789;
      operand_b = 32'h98765432;
     // test case 1 : a_and_b
    ALUControl= 4'b1001; #49 tk_expect(32'h00444400);
      $display("testcase a_and_b: a = %8h, b = %8h, Result = %8h", operand_a[31:0],operand_b[31:0],Result[31:0]); 
     // test case 2: a_add_b    
      ALUControl= 4'b0000; #49 tk_expect(32'hbbbbbbbb);
      $display("testcase a_add_b: a = %8h, b = %8h, Result = %8h", operand_a[31:0],operand_b[31:0],Result[31:0]);
     // test case 3: a_sub_b
      operand_a = 32'h99456789;
      operand_b = 32'h98765432;
      ALUControl= 4'b0001; #49 tk_expect(32'h00cf1357);
      $display("testcase a_sub_b: a = %8h, b = %8h, Result = %8h", operand_a[31:0],operand_b[31:0],Result[31:0]);
     // test case 4: a_or_b
      operand_a = 32'h23456789;
      operand_b = 32'h98765432;
      ALUControl= 4'b1000; #49 tk_expect(32'hbb7777bb);
      $display("testcase a_or_b:  a = %8h, b = %8h, Result = %8h", operand_a[31:0],operand_b[31:0],Result[31:0]);
     // test case 5: a_xor_b
      ALUControl= 4'b0101; #49 tk_expect(32'hbb3333bb);
      $display("testcase a_xor_b: a = %8h, b = %8h, Result = %8h", operand_a[31:0],operand_b[31:0],Result[31:0]);
     // test case 6: a_sll_b
      operand_a = 32'h23456789;
      operand_b = 32'd16; 
      ALUControl= 4'b0010; #49 tk_expect(32'h67890000);
      $display("testcase a_sll_b: a = %8h, b = %8h, Result = %8h", operand_a[31:0],operand_b[31:0],Result[31:0]);
      // test case 7: a_srl_b
      operand_a = 32'h23456789;
      operand_b = 32'd16; 
      ALUControl= 4'b0110; #49 tk_expect(32'h00002345);
      $display("testcase a_srl_b: a = %8h, b = %8h, Result = %8h", operand_a[31:0],operand_b[31:0],Result[31:0]);
       // test case 8: a_sra_b
      operand_a = 32'h83456789;
      operand_b = 32'd16; 
      ALUControl= 4'b0100; #49 tk_expect(32'hffff8345);
      $display("testcase a_sra_b: a = %8h, b = %8h, Result = %8h", operand_a[31:0],operand_b[31:0],Result[31:0]);
      // test case 9: a_slt_b
    operand_a = 32'h03456789;
      operand_b = 32'h09000000; 
      ALUControl= 4'b0011; #49 tk_expect(32'h00000001);
      $display("testcase a_slt_b: a = %8h, b = %8h, Result = %8h", operand_a[31:0],operand_b[31:0],Result[31:0]);
      operand_a = 32'h73456789;
      operand_b = 32'hfffffffd;
      ALUControl= 4'b0011; #49 tk_expect(32'h00000000);
      $display("testcase a_slt_b: a = %8h, b = %8h, Result = %8h", operand_a[31:0],operand_b[31:0],Result[31:0]);
     //testcase 10: a_sltu_b
      operand_a = 32'h73456789;
      operand_b = 32'hfffffffd;
      ALUControl= 4'b0111; #49 tk_expect(32'h00000001);
      $display("testcase a_sltu_b: a = %8h, b = %8h, Result = %8h", operand_a[31:0],operand_b[31:0],Result[31:0]);
      #49 $display("TEST PASSED"); $finish;

end
endmodule

