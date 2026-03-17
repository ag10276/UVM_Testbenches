module tb_top;
  logic PCLK;
  always #5 PCLK = ~PCLK;

  apb_if _if(PCLK);

  apb_memory dut (
    .PCLK (PCLK),
    .PRESETn (_if.PRESETn),
    .PADDR (_if.PADDR),
    .PWDATA (_if.PWDATA),
    .PSEL (_if.PSEL),
    .PENABLE (_if.PENABLE),
    .PWRITE (_if.PWRITE),
    .PRDATA (_if.PRDATA),
    .PREADY (_if.PREADY),
    .PSLVERR (_if.PSLVERR)
  );

  initial begin
    PCLK = 0;
    uvm_config_db #(virtual apb_if)::set(null, "*", "apb_vif", _if);
    run_test("base_test");
  end

  initial begin
    #500_000;
    `uvm_fatal("TIMEOUT", "Simulation watchdog — check for hangs")
  end
endmodule
