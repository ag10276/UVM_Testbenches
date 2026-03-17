module tb_top;
  adder_if _if();
  adder dut(
    .a(_if.a),
    .b(_if.b),
    .cin(_if.cin),
    .sum(_if.sum),
    .cout(_if.cout)
  );
  
  initial begin
    uvm_config_db#(virtual adder_if)::set(null, "*", "adder_vif", _if);
    run_test("test");
  end
endmodule
