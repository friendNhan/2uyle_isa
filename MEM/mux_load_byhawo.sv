module mux_load_byhawo(	
	input logic 		unsign,
	input logic [3:0] mask_i,
	input logic [31:0] ld_data_i,
		
	output logic [31:0] ld_data_o
	);
	
	wire logic [31:0] ld_data_byte;
	wire logic [31:0] ld_data_half;
	wire logic [31:0] ld_data_word;
	wire logic [31:0] ld_data_byte_u;
	wire logic [31:0] ld_data_half_u;
	
	assign ld_data_byte = {{24{ld_data_i[7]}},ld_data_i[7:0]};
	    
	assign ld_data_half = {{16{ld_data_i[15]}},ld_data_i[15:0]};
	
	assign ld_data_word = ld_data_i;
	
	assign ld_data_byte_u = {24'd0,ld_data_i[7:0]};
	
	assign ld_data_half_u = {16'd0,ld_data_i[15:0]};
	
	assign ld_data_o = ({unsign,mask_i}==5'b00001)? ld_data_byte 	:
							 ({unsign,mask_i}==5'b10001)? ld_data_byte_u :
							 ({unsign,mask_i}==5'b00011)? ld_data_half 	:
							 ({unsign,mask_i}==5'b10011)? ld_data_half_u	:
							 ({unsign,mask_i}==5'b01111)? ld_data_word 	: 32'd0;
					
		
endmodule