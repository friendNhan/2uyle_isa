module single_cycle_tb();

  reg clk_i = 1'b1;
  reg rst_ni;
  wire logic [31:0] pc_debug;
  wire logic [31:0] io_sw;
  wire logic [31:0] io_lcd;
  wire logic [31:0] io_ledg;
  wire logic [31:0] io_ledr;  
  wire logic [31:0] io_hex7;
  wire logic [31:0] io_hex6;  
  wire logic [31:0] io_hex5;  
  wire logic [31:0] io_hex4;  
  wire logic [31:0] io_hex3;
  wire logic [31:0] io_hex2;  
  wire logic [31:0] io_hex1;
  wire logic [31:0] io_hex0;
     
  single_cycle DUT(
      .clk_i(clk_i),
      .rst_ni(rst_ni),	
      .pc_debug_o(pc_debug),
      .io_sw_i(io_sw),	
      .io_hex0_o(io_hex0),
      .io_hex1_o(io_hex1),
      .io_hex2_o(io_hex2),
      .io_hex3_o(io_hex3),
      .io_hex4_o(io_hex4),
      .io_hex5_o(io_hex5),
      .io_hex6_o(io_hex6),
      .io_hex7_o(io_hex7),
      .io_ledr_o(io_ledr),
      .io_ledg_o(io_ledg),
      .io_lcd_o(io_lcd)
  );

  initial begin
		clk_i = 1'b0;
  end
  
  always #50 clk_i=~clk_i;
  
  initial begin
    rst_ni = 1'b0;
    #49
  rst_ni = 1'b1;
  #5000;
   end
endmodule	