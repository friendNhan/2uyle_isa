module bru_tb;
   logic [31:0] rs1_data;
   logic [1:0] is_control; // branch or jump
   logic [31:0] imm;
   logic [31:0] pc;
   logic [2:0] bru_op;
   logic br_unsigned;
   logic br_less;
   logic br_less_u;
   logic br_equal;
   logic Z,N,C;

   logic is_taken;
   logic [31:0] pc_bru;



   bru dut(
   .rs1_data(rs1_data),
   .is_control(is_control),
   .imm(imm),
   .pc(pc),
   .bru_op(bru_op),
   .br_unsigned(br_unsigned),
   .br_less(br_less),
   .br_less_u(br_less_u),
   .br_equal(br_equal),
   .is_taken(is_taken),
   .pc_bru(pc_bru)
   );



    task tk_expect(
     input logic [31:0] pc_bru_x,
     input logic is_taken_x
     );
      $display("[%3d] pc_bru = %8h, pc_bru_x = %8h,is_taken=%1b,is_taken_x=%1b", $time,pc_bru[31:0],pc_bru_x[31:0],is_taken,is_taken_x);
      assert((pc_bru==pc_bru_x)&&(is_taken==is_taken_x)) else begin
      $display("TEST FAILED"); 
      $stop;
      end
    endtask
   initial begin
    //testcase beq
  is_control = 2'b00;
  rs1_data = 32'h00003456;
  pc = 32'h00000008;
  imm = 32'h12345670;
  br_equal = 1'b1;
  bru_op = 3'b000;
    $display("tescase1:BEQ pc_bru = pc + imm ,pc = %8h, imm = %8h, pc_bru = %8h ",pc[31:0],imm[31:0],pc_bru[31:0]);
    #1 tk_expect( 32'h12345678,1'b1);
    #20
    //testcase jalr
  is_control = 2'b11;
  rs1_data = 32'h00003456;
  pc = 32'h00000008;
  imm = 32'h12345670;
  br_equal = 1'b1;
  bru_op = 3'b000;
    $display("tescase: JALR pc_bru = rs1_data + imm ,pc = %8h, imm = %8h, pc_bru = %8h ",pc[31:0],imm[31:0],pc_bru[31:0]);
    #1 tk_expect( 32'h12348ac6,1'b1);

    //testcase jal
  is_control = 2'b00;
  rs1_data = 32'h00003456;
  pc = 32'h00000008;
  imm = 32'h12345670;
  br_equal = 1'b1;
  bru_op = 3'b000;
    $display("tescase: JAL pc_bru = pc + imm ,pc = %8h, imm = %8h, pc_bru = %8h ",pc[31:0],imm[31:0],pc_bru[31:0]);
    #1 tk_expect( 32'h12345678,1'b1);
    //testcase no jump, no branch
  is_control = 2'b00;
  rs1_data = 32'h00003456;
  pc = 32'h00000008;
  imm = 32'h12345670;
  br_equal = 1'b0;
  bru_op = 3'b111;
    $display("tescase: NO JUMP AND NO BRANCH pc_bru = rs1_data + imm ,pc = %8h, imm = %8h, pc_bru = %8h ",pc[31:0],imm[31:0],pc_bru[31:0]);
    #1 tk_expect( 32'h12345678,1'b0);
    #49 $display("TEST PASSED"); $finish; 

     end
endmodule

