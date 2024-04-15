module mux_lsu(
  input logic [1:0] 	  addr_sel_i,
  input logic [31:0]   input_periph_i,
  input logic [31:0]   output_periph_i,
  input logic [31:0]   data_memory_i,

  output logic [31:0]  ld_data_o
  );

  assign ld_data_o = (addr_sel_i == 2'b11) ? input_periph_i:
							(addr_sel_i == 2'b10) ? output_periph_i :
							((addr_sel_i == 2'b00)|(addr_sel_i == 2'b01)) ? data_memory_i : data_memory_i ;

endmodule: mux_lsu