module mux_wb(
	input logic [31:0] alu_data,
	input logic [31:0] ld_data,
	input logic is_load,
	
	output logic [31:0] rd_data
	);
	
	assign rd_data = (is_load)? ld_data : alu_data;
	
endmodule
	