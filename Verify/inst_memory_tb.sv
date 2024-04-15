module inst_memory_tb();
  reg clk_i = 1'b1;
  reg rst_ni;
  wire logic [31:0] next_pc;
  wire logic [31:0] pc_current;
  wire logic [31:0] instruction;
     
  pc_count DUT_PC_Count(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .nxt_pc(next_pc),
  .pc(pc_current)
  );
  pc_adder DUT_PC_Adder(
  .pc(pc_current),
  .pc_four(next_pc)
  );
  inst_memory DUT(
    .clk_i(clk_i), 
    .rst_ni(rst_ni),
    .addr_i(pc_current),
    .instr_o(instruction)
  );
  initial begin
		clk_i = 1'b0;
  end
  
  always #50 clk_i=~clk_i;
  
  initial begin 
  rst_ni = 1'b1;
  #85;
  rst_ni = 1'b0;
  #85;
  rst_ni = 1'b1;
  #5000;
   end
endmodule	