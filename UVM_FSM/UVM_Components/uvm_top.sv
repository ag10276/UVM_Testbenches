module tb_top;
  logic clk;
  always #10 clk = ~clk;
  
  fsm_if _if(clk);
  traffic_light_controller dut (
    .clk(clk),
    .reset(_if.reset),
    .light_NS(_if.light_NS),
    .light_EW(_if.light_EW)
  );
  
  initial begin
    clk <=0;
     _if.reset = 1'b1;
    uvm_config_db#(virtual fsm_if)::set(null, "*", "fsm_vif", _if);
    run_test("base_test"); 
  end
  
endmodule
