import uvm_pkg::*;
`include "uvm_macros.svh"

class test extends uvm_test;
  `uvm_component_utils(test)
  function new(string name="env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  env e0;
  virtual mux_if vif;
  item_seq seq;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e0 = env::type_id::create("e0", this);
    if(!uvm_config_db#(virtual mux_if)::get(this, "", "mux_vif", vif))
      `uvm_fatal("TEST", "Could not get VIF");
    uvm_config_db#(virtual mux_if)::set(this, "e0.a0.*", "mux_vif", vif);
    seq = item_seq::type_id::create("seq");
  	//seq.randomize();
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.randomize();
    seq.start(e0.a0.s0);
    #1;
    phase.drop_objection(this);
  endtask  
endclass

module tb_top;
  mux_if _if();
  mux4to1 dut(.in0(_if.in0),
              .in1(_if.in1),
              .in2(_if.in2),
              .in3(_if.in3),
              .sel(_if.sel),
              .out(_if.out)
             );
  initial begin
  	uvm_config_db#(virtual mux_if)::set(null, "uvm_test_top","mux_vif", _if);
  	run_test("test");
  end
endmodule
  