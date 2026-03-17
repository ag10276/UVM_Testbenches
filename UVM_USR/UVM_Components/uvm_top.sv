module tb_top;
  logic clk;
  always #10 clk = ~clk;
  usr_if _if(clk);
  universal_shift_register dut (
    .clk(clk),
    .clr(_if.clr),
    .control(_if.control),
    .parallel_in(_if.parallel_in),
    .serial_in_right(_if.serial_in_right),
    .serial_in_left(_if.serial_in_left),
    .serial_out_right(_if.serial_out_right),
    .serial_out_left(_if.serial_out_left),
    .parallel_out(_if.parallel_out)
  );
  
  initial begin
    clk <=0;
    uvm_config_db#(virtual usr_if)::set(null, "*", "usr_vif", _if);
    run_test("s_right_test"); 
  end
  
endmodule
