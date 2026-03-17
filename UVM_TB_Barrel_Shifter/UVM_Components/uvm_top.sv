module tb_top;
  bshifter8 _if();
  barrel_shifter_8 dut(
    .x(_if.x),
    .s(_if.s),
    .y(_if.y)
  );
  
  initial begin
    uvm_config_db#(virtual bshifter8)::set(null, "*", "bshifter8_vif", _if);
    run_test("test");
  end
endmodule
