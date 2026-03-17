module tb_top;
  alu_if _if();
  alu dut(
    .a(_if.a),
    .b(_if.b),
    .y(_if.y),
    .opcode(_if.opcode),
    .flags(_if.flags)
  );
  
  initial begin
    uvm_config_db#(virtual alu_if)::set(null, "*", "alu_vif", _if);
    run_test("test");
  end
endmodule
