module single_cycle(
	input logic clk_i,
	input logic rst_ni,
	
	input  logic [31:0] io_sw_i,	
	output logic [31:0] pc_debug_o,
	output logic [31:0] io_hex0_o,
	output logic [31:0] io_hex1_o,
	output logic [31:0] io_hex2_o,
	output logic [31:0] io_hex3_o,
	output logic [31:0] io_hex4_o,
	output logic [31:0] io_hex5_o,
	output logic [31:0] io_hex6_o,
	output logic [31:0] io_hex7_o,
	output logic [31:0] io_ledr_o,
	output logic [31:0] io_ledg_o,
	output logic [31:0] io_lcd_o
);

	// mux_pc
	wire logic [31:0] pc_cur;
	wire logic [31:0] nxt_pc;
	wire logic [31:0] pc_plus4;
	wire logic [31:0] pc_bru;
	wire logic is_taken;
	
	wire logic [31:0] instr;
	
	// decoder -- regfile
	wire logic [4:0] rs1_addr;
	wire logic [4:0] rs2_addr;
	wire logic [4:0] rd_addr;
	wire logic [31:0] ld_data;
	wire logic wr_en;
	wire logic [2:0] bru_op;

	
	wire logic [31:0] rs1_data;
	wire logic [31:0] rs2_data;
	wire logic [2:0] imm_sel; // extend immgen
	wire logic [1:0] op_b_sel; // select mux operand b
	
	//alu
	wire logic [31:0] operand_a;
	wire logic [31:0] operand_b;
  wire logic [31:0] alu_data;
	wire logic [31:0] rd_data;
	
	wire logic [3:0] ALUControl;
	wire logic [2:0] alu_op;
	
	//bru
	wire logic [1:0]is_control;
	wire logic br_equal;
	wire logic br_less;
	wire logic br_less_u;
	wire logic br_unsigned;
	wire logic is_pc;
	
	//data memory
	wire logic st_en; 
	wire logic [3:0] mask;
	wire logic unsign;
	
	//imm
	wire logic [31:0] imm_gen;
	wire logic is_load;
	
			// test wave
	assign pc_debug_o = pc_cur;	
	
	mux_pc mux_pc(
		.pc_bru(pc_bru),
		.pc_four(pc_plus4),
		.is_taken(is_taken),
		.nxt_pc(nxt_pc)
	);
	
	pc_count pc_count(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.nxt_pc(nxt_pc),
		.pc(pc_cur)
	);
	
	pc_adder pc_adder(
		.pc(pc_cur),
		.pc_four(pc_plus4)
	);
	
	inst_memory inst_memory(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.addr_i(pc_cur[12:0]),
		.instr_o(instr)
	);
	
	decoder decoder(
		.instr(instr),
		.rs1_addr(rs1_addr),
		.rs2_addr(rs2_addr),
		.rd_addr(rd_addr),
		.rd_wr(wr_en),
		.mem_wr(st_en),
		.mask(mask),
		.unsign(unsign),
		.op_b_sel(op_b_sel),
		.alu_op(alu_op),
		.bru_op(bru_op),
		.is_pc(is_pc),
		.is_control(is_control),
		.br_unsigned(br_unsigned),
		.imm_sel(imm_sel),
		.is_load(is_load)
	);
	
	reg_file reg_file(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.rd_wren_i(wr_en),   
		.rs1_addr_i(rs1_addr),
		.rs2_addr_i(rs2_addr),
		.rd_addr_i(rd_addr),       
		.rd_data_i(rd_data),             
		.rs1_data_o(rs1_data),
		.rs2_data_o(rs2_data)  
	);
	
	mux_op_a mux_op_a(
		.pc(pc_cur),
		.rs1_data(rs1_data),
		.is_pc(is_pc),
		.operand_a(operand_a)
		);
		
	sign_extend sign_extend(
		.instr(instr),
		.imm_sel(imm_sel),
		.imm(imm_gen)
  );
  
	mux_op_b mux_op_b(
		.rs2_data(rs2_data),
		.imm(imm_gen),
		.op_b_sel(op_b_sel),
		.operand_b(operand_b)
		);
		
	alu_decoder alu_decoder(
		  .funct7(instr[31:25]),
		  .funct3(instr[14:12]),
		  .alu_op(alu_op),
		  .ALUControl(ALUControl)
	);
	
	alu alu(
		.operand_a(operand_a),
		.operand_b(operand_b),
		.ALUControl(ALUControl),
		.Result(alu_data),
		.Z(br_equal),
		.N(br_less),
		.V(),
		.C(br_less_u)
	);	
	
	bru bru(
		.rs1_data(rs1_data),
		.is_control(is_control), 
		.imm(imm_gen),
		.pc(pc_cur),
		.bru_op(bru_op),
		.br_unsigned(br_unsigned),
		.br_less(br_less),
		.br_less_u(br_less_u),
		.br_equal(br_equal),
		.is_taken(is_taken),
		.pc_bru(pc_bru)
  );
  
  lsu lsu(
  		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.addr_lsu_i(alu_data[11:0]),
		.st_en_i(st_en),
		.st_data_i(rs2_data),
		.mask_i(mask),
		.unsign(unsign),
		.ld_data_o(ld_data),
		.io_sw(io_sw_i),
		.io_lcd(io_lcd_o),
		.io_ledg(io_ledg_o),
		.io_ledr(io_ledr_o),
		.io_hex0(io_hex0_o),
		.io_hex1(io_hex1_o),
		.io_hex2(io_hex2_o),
		.io_hex3(io_hex3_o),
		.io_hex4(io_hex4_o),
		.io_hex5(io_hex5_o),
		.io_hex6(io_hex6_o),
		.io_hex7(io_hex7_o)
	);
	
	mux_wb mux_wb(
		.alu_data(alu_data),
		.ld_data(ld_data),
		.is_load(is_load),
		.rd_data(rd_data)
	);
	
endmodule