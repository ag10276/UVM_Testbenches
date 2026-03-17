module tb_top;
  logic clk;
  always #10 clk = ~clk;
  
  sync_fifo_if _if(clk);
  sync_fifo dut (
    .clk(clk),
    .rst_n(_if.rst_n),
    .w_en(_if.w_en),
    .r_en(_if.r_en),
    .wr_data(_if.wr_data),
    .rd_data(_if.rd_data),
    .full(_if.full),
    .empty(_if.empty)
  );
  
  initial begin
    clk <=0;
     _if.rst_n = 1'b0;
    uvm_config_db#(virtual sync_fifo_if)::set(null, "*", "sync_fifo_vif", _if);
    run_test("base_test"); 
  end
  
endmodule
