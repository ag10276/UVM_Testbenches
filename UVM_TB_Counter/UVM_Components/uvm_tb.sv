module tb_top;
  logic clk;
  always #5 clk = ~clk;
  
  counter_if _if(clk);
  counter dut(
    .clk(clk), 
    .rst(_if.rst),
    .up(_if.up),
    .dout(_if.dout)
  );
  
  initial begin
    clk <=0;
    uvm_config_db#(virtual counter_if)::set(null, "*", "counter_vif", _if);
    run_test("up_test");  
  end
endmodule
