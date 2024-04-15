    //`timescale 1ns/10ps 
  module reg_file_tb;
   logic            clk_i;
   logic            rst_ni;
   logic            rd_wren_i;  
   logic [4:0]      rs1_addr_i;
   logic [4:0]      rs2_addr_i;
   logic [4:0]      rd_addr_i;
   logic [31:0]     rd_data_i;
   logic [31:0]     rs1_data_o;
   logic [31:0]     rs2_data_o;
  reg_file dut(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .rd_wren_i(rd_wren_i),
  .rs1_addr_i(rs1_addr_i),
  .rs2_addr_i(rs2_addr_i),
  .rd_data_i(rd_data_i),
  .rd_addr_i(rd_addr_i),
  .rs1_data_o(rs1_data_o),
  .rs2_data_o(rs2_data_o)
  ); 
   always #5 clk_i=~clk_i;
    task tk_expect(
    input logic [31:0]   rs1_data_o_x,
    input logic [31:0]   rs2_data_o_x
     );
      $display("[%3d] clk_i=%1b,rst_ni=%1b,rs1_data_o = %8h,rs2_data_o=%8h,rs1_data_o_x = %8h,rs2_data_o_x", $time,clk_i,rst_ni,rs1_data_o[31:0],rs2_data_o[31:0],rs1_data_o_x[31:0],rs2_data_o_x[31:0]);
      assert(( rs1_data_o==rs1_data_o_x)&&(rs2_data_o==rs2_data_o_x)) else begin
        $display("TEST FAILED"); 
        $stop;
      end
    endtask
      initial begin
   rst_ni=1'b1;
   clk_i=1'b0;
   rd_wren_i=1'b1;
   rd_data_i=32'h0;
   rd_addr_i=5'b0;
   #10
   //testcase1
   rd_data_i=32'h44444444;
   rd_addr_i = 5'b00010;
   #49
   rs1_addr_i = 5'b00010;
   rs2_addr_i = 5'b00010; #49 tk_expect(32'h44444444,32'h44444444);
   $display("testcase1: rd_addr_i = %5b, rd_data_i = %8h, rs1_addr_i = %5b, rs2_addr_i = %5b",rd_addr_i[4:0],rd_data_i[31:0],rs1_addr_i[4:0],rs2_addr_i[4:0]);
   #10
   //testcase2
   rd_data_i=32'h12345678;
   rd_addr_i = 5'b00001;
   #49
   rs1_addr_i = 5'b00001;
   rs2_addr_i = 5'b00010; #49 tk_expect(32'h12345678,32'h44444444);
   $display("testcase1: rd_addr_i = %5b, rd_data_i = %8h, rs1_addr_i = %5b, rs2_addr_i = %5b",rd_addr_i[4:0],rd_data_i[31:0],rs1_addr_i[4:0],rs2_addr_i[4:0]);
   #10
   //testcase3
   rd_data_i=32'hffffffff;
   rd_addr_i = 5'b00101;
   #49
   rs1_addr_i = 5'b00101;
   rs2_addr_i = 5'b00101; #49 tk_expect(32'hffffffff,32'hffffffff);
   $display("testcase1: rd_addr_i = %5b, rd_data_i = %8h, rs1_addr_i = %5b, rs2_addr_i = %5b",rd_addr_i[4:0],rd_data_i[31:0],rs1_addr_i[4:0],rs2_addr_i[4:0]);
   #49 $display("TEST PASSED"); $finish;

end
endmodule
