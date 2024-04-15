//`timescale 1ns/10ps
module decoder_tb;
  logic  [31:0] instr;
   logic [4:0] rs1_addr;
   logic [4:0] rs2_addr;
   logic [4:0] rd_addr;
   logic rd_wr;
   logic is_pc;
   logic [1:0] op_b_sel;
   logic [2:0] alu_op;
   logic mem_wr;
   logic [3:0] mask;
   logic unsign;
   logic is_load;
   logic [1:0] is_control;
   logic [2:0] bru_op;
   logic br_unsigned;
   logic [2:0] imm_sel;
decoder dut(
  .instr(instr),
  .rs1_addr(rs1_addr),
  .rs2_addr(rs2_addr),
  .rd_addr(rd_addr),
  .rd_wr(rd_wr),
  .is_pc(is_pc),
  .op_b_sel(op_b_sel),
  .alu_op(alu_op),
  .mem_wr(mem_wr),
  .mask(mask),
  .unsign(unsign),
  .is_control(is_control),
  .bru_op(bru_op),
  .br_unsigned(br_unsigned),
  .is_load(is_load),
  .imm_sel(imm_sel)
);
  task imm_sel_expect(
    input logic [2:0] imm_sel_x
  );

    $display("[%3d] imm_sel = %3b, imm_sel_x= %3b", $time,imm_sel[2:0],imm_sel_x[2:0]);
    assert(imm_sel==imm_sel_x) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask
task rs1_addr_expect(
    input logic [4:0] rs1_addr_x 
  );
    $display("[%3d] rs1_addr = %5b, rs1_addr_x= %5b", $time,rs1_addr[4:0],rs1_addr_x[4:0]);
    assert(rs1_addr==rs1_addr_x) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

task rs2_addr_expect(
    input logic [4:0] rs2_addr_x 
  );
    $display("[%3d] rs2_addr = %5b, rs2_addr_x= %5b", $time,rs2_addr[4:0],rs2_addr_x[4:0]);
    assert(rs2_addr==rs2_addr_x) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

 task rd_addr_expect(
    input logic [4:0] rd_addr_x 
  );
    $display("[%3d] rd_addr = %5b, rd_addr_x= %5b", $time,rd_addr[4:0],rd_addr_x[4:0]);
    assert(rd_addr==rd_addr_x) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

task rd_wr_expect(
    input logic rd_wr_x 
  );
    $display("[%3d] rd_wr = %1b, rd_wr_x= %1b", $time,rd_wr,rd_wr_x);
    assert(rd_wr==rd_wr_x) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

  task is_pc_expect(
    input logic is_pc_x 
  );
    $display("[%3d] is_pc = %1b, is_pc_x= %1b", $time,is_pc,is_pc_x);
    assert(is_pc==is_pc_x) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

task op_b_sel_expect(
    input logic [1:0] op_b_sel_x 
  );
    $display("[%3d] op_b_sel = %2b, op_b_sel_x= %2b", $time,op_b_sel[1:0],op_b_sel_x[1:0]);
    assert(op_b_sel==op_b_sel_x) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask
  task alu_op_expect(
    input logic [2:0] alu_op_x 
  );
    $display("[%3d] alu_op = %3b, alu_op_x= %3b", $time,alu_op[2:0],alu_op_x[2:0]);
    assert(alu_op==alu_op_x) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask
  task mem_wr_expect(
    input logic mem_wr_x 
  );
    $display("[%3d] mem_wr = %1b, mem_wr_x= %1b", $time,mem_wr,mem_wr_x);
    assert(mem_wr==mem_wr_x) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

  task unsign_mask_expect(
    input logic [4:0] unsign_mask_x 
  );
    $display("[%3d] unsign_mask = %5b, unsign_mask_x= %5b", $time,{unsign,mask}[4:0],unsign_mask_x[4:0]);
    assert({unsign,mask}==(unsign_mask_x)) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

  task is_control_expect(
    input logic [1:0] is_control_x 
  );
    $display("[%3d] is_control = %2b, is_control_x= %2b", $time,is_control[1:0],is_control_x[1:0]);
    assert(is_control==is_control_x) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

  task bru_op_expect(
    input logic [2:0] bru_op_x 
  );
    $display("[%3d] bru_op = %3b, bru_op_x= %3b", $time,bru_op[2:0],bru_op_x[2:0]);
    assert(bru_op==bru_op_x) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

  task br_unsigned_expect(
    input logic br_unsigned_x 
  );
    $display("[%3d] br_unsigned = %1b, br_unsigned_x= %1b", $time,br_unsigned,br_unsigned_x);
    assert(br_unsigned==br_unsigned_x) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask

   task is_load_expect(
    input logic is_load_x 
  );
    $display("[%3d] is_load = %1b, is_load_x= %1b", $time,is_load,is_load_x);
    assert(is_load==is_load_x) else begin
      $display("TEST FAILED");
      $stop;
    end
  endtask
  initial begin

  #0 instr = 32'h06410093; $display("testcase1: ADDI X1,X2,100 ,instr = %8h ", instr[31:0]);
  #1 imm_sel_expect(3'b001); #1 rs1_addr_expect(5'd2);#1 rs2_addr_expect(5'd0); #1 rd_addr_expect(5'd1);#1 rd_wr_expect(1'b1); #1 op_b_sel_expect(2'b01);#1 alu_op_expect(3'b011);
  #49 
  #0 instr = 32'h413887B3; $display("testcase2: SUB X15,X17,X19 ,instr = %8h ", instr[31:0]);
  #1 imm_sel_expect(3'b000); #1 rs1_addr_expect(5'd17);#1 rs2_addr_expect(5'd19); #1 rd_addr_expect(5'd15);#1 rd_wr_expect(1'b1); #1 op_b_sel_expect(2'b00); #1 alu_op_expect(3'b000);
  #49 
  #0 instr = 32'h0137F933; $display("testcase3: AND X15,X17,X19 ,instr = %8h ", instr[31:0]);
  #1 imm_sel_expect(3'b000); #1 rs1_addr_expect(5'd15);#1 rs2_addr_expect(5'd19); #1 rd_addr_expect(5'd18);#1 rd_wr_expect(1'b1); #1 op_b_sel_expect(2'b00); #1 alu_op_expect(3'b000);
  #49 
  #0 instr = 32'h00011083; $display("testcase4: LH X1,0(X2),instr = %8h ", instr[31:0]);
  #1 imm_sel_expect(3'b001); #1 rs1_addr_expect(5'd2);#1 rs2_addr_expect(5'd0); #1 rd_addr_expect(5'd1);#1 rd_wr_expect(1'b1); #1 op_b_sel_expect(2'b01); #1 alu_op_expect(3'b100);#1 unsign_mask_expect(5'b00011); #1 is_load_expect(1'b1);
  #49
  instr = 32'hFE015CE3; // bge x2 x0 -8
  #49 
  instr=  32'h0109A823; // sw x16 0(x19)
  #49
  instr= 32'h008001EF; // jal x3 8
  #49 
  instr =32'h01C60567;//	jalr x10 x12 28
    
  #49 $display("TEST PASSED"); $finish;

  end

endmodule 
