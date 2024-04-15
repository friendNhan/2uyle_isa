module input_peripheral(
	input logic clk_i,
	input logic rst_ni,
	input logic [31:0] io_sw,
	
	output logic [31:0] ld_data_o
	);
	
	logic [31:0] reg_sw;
	
	
	always@(posedge clk_i) begin
			reg_sw <= io_sw[31:0];
	end
	
	assign ld_data_o = reg_sw;	
	
endmodule