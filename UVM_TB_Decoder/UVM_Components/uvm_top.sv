module tb_top;
	decoder_if _if();
	decoder dut(.a(_if.a), .d(_if.d));

	initial begin
		uvm_config_db#(virtual decoder_if)::set(null, "*", "decoder_vif", _if);
		run_test("test");
	end
endmodule