module demux_lsu(
  input logic [11:0] addr_i,
  input logic [1:0] addr_sel_i,

  output logic [11:0] addr_periph_o,
  output logic [10:0] addr_memory_o
  );
  
  
  // compa
  // --- addr_sel == 2'b01 --> out to addr_periph
  // --- addr_sel == 2'b10 --> out to addr_memory
    
  assign addr_periph_o = (addr_sel_i == 2'b10)? addr_i : 12'h0;
  
  assign addr_memory_o = ((addr_sel_i == 2'b00)|(addr_sel_i == 2'b01))? addr_i[10:0] : 11'h0;
  
endmodule 
  

  