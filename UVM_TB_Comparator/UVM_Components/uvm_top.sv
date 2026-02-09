module tb_top;
  comp_if _if();
  comparator dut(
    .a(_if.a),
    .b(_if.b),
    .agreaterb(_if.agreaterb),
    .aequalb(_if.aequalb),
    .alesserb(_if.alesserb)
  );
  
  initial begin
    uvm_config_db#(virtual comp_if)::set(null, "*", "comp_vif", _if);
    run_test("test");
  end
endmodule