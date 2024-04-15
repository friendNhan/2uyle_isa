  module lsu_tb;

     logic            clk_i;
     logic            rst_ni;
     logic            st_en_i ;
     logic [10:0]     addr_i;
     logic [31:0]     st_data_i;
     logic [3:0]      mask_i;
     logic [11:0]     addr_demux_i;
     logic [1:0]      addr_sel_i;
     logic [31:0]     io_sw;
     logic            unsign;
     logic [31:0]     ld_data_i;

     logic [31:0]     ld_data_o;
     logic [11:0]     addr_periph_o;
     logic [31:0]     input_peripheral_o;
     logic [31:0]     output_peripheral_o;
     logic [31:0]     io_lcd;
     logic [31:0]     io_ledg;
     logic [31:0]     io_ledr;
     logic [31:0]     io_hex0;
     logic [31:0]     io_hex1;
     logic [31:0]     io_hex2;
     logic [31:0]     io_hex3;
     logic [31:0]     io_hex4;
     logic [31:0]     io_hex5;
     logic [31:0]     io_hex6;
     logic [31:0]     io_hex7;
     logic [31:0]     result;
    demux_lsu demux_lsu(
       .addr_i(addr_demux_i),
       .addr_sel_i(addr_sel_i),
       .addr_periph_o(addr_periph_o),
       .addr_memory_o(addr_i)
    );
    
    data_memory dut(
       .clk_i(clk_i),                                                                                                                                                                                        
       .rst_ni(rst_ni),
       .st_en_i(st_en_i),
       .addr_i(addr_i),
       .st_data_i(st_data_i),
       .mask_i(mask_i),
       .ld_data_o(ld_data_o)
    );


    input_peripheral input_peripheral(
       .clk_i(clk_i),
       .rst_ni(rst_ni),
       .io_sw(io_sw),
       .ld_data_o(input_peripheral_o)
    );  

    output_peripheral output_peripheral(
       .clk_i(clk_i),
       .rst_ni(rst_ni),
       .st_en_i(st_en_i),
       .ld_data_o(output_peripheral_o),
       .addr_i(addr_periph_o),
       .st_data_i(st_data_i),
       .io_lcd(io_lcd),
       .io_ledg(io_ledg),
       .io_ledr(io_ledr),
       .io_hex0(io_hex0),
       .io_hex1(io_hex1),
       .io_hex2(io_hex2),
       .io_hex3(io_hex3),
       .io_hex4(io_hex4),
       .io_hex5(io_hex5),
       .io_hex6(io_hex6),
       .io_hex7(io_hex7)
      );
      mux_lsu mux_lsu(
       .addr_sel_i(addr_sel_i),
       .input_periph_i(input_peripheral_o),
       .output_periph_i(output_peripheral_o),
       .data_memory_i(ld_data_o),
       .ld_data_o(ld_data_i)
      );
      mux_load_byhawo mux_load_byhawo(
      .unsign(unsign),
      .mask_i(mask_i),
      .ld_data_i(ld_data_i),
      .ld_data_o(result)
      );

    always #5 clk_i=~clk_i;
    task tk_expect(
     input logic [31:0]     result_x

     );

      $display("[%3d] clk_i=%1b,rst_ni=%1b,ld_data_o=%8h,ld_data_i=%8h,io_hex0=%8h,addr_demux_i=%3h,mask_i=%4b,result = %8h,result_x=%8h", $time,clk_i,rst_ni,ld_data_o[31:0],ld_data_i[31:0],io_hex0[31:0],addr_demux_i[11:0],mask_i[3:0],result[31:0],result_x[31:0]);

      assert((result==result_x)) else begin
        $display("TEST FAILED"); 
        $stop;
      end
    endtask
    assign addr_sel_i = {addr_demux_i[11],addr_demux_i[8]};
      initial begin
    clk_i=1'b0;
    st_data_i = 32'h12348678;
    st_en_i= 1'b1;
    rst_ni=1'b1;  
      unsign=0;
      io_sw = 32'h98765432;
        #0  addr_demux_i = 12'b000000000001; mask_i = 4'b0001; #49 tk_expect(32'h00000078);
      #49 addr_demux_i = 12'b000000011111; mask_i = 4'b0001; #49 tk_expect(32'h00000078); 
        #49 addr_demux_i = 12'b010110101010; mask_i = 4'b0011; #49 tk_expect(32'hffff8678);  
        #49 addr_demux_i = 12'h800; mask_i = 4'b1111; #49 tk_expect(32'h12348678); 
        #49 addr_demux_i = 12'b000000000100; mask_i = 4'b1111; #49 tk_expect(32'h12348678);  
        #49 addr_demux_i = 12'h834; mask_i = 4'b1111; #49 tk_expect(32'h00000000);
        #49 addr_demux_i = 12'h900; mask_i = 4'b0011; #49 tk_expect(32'h00005432);




        #49 $display("TEST PASSED"); $finish;



end

endmodule


