class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  
  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  env e0;
  uvm_sequence#(item) seq;
  virtual counter_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e0 = env::type_id::create("e0", this);
    seq = item_seq::type_id::create("seq");
    if(!uvm_config_db#(virtual counter_if)::get(this, "", "counter_vif", vif))
      `uvm_fatal("TEST", "Could not get VIF");
    uvm_config_db#(virtual counter_if)::set(this, "e0.a0.*", "counter_vif", vif);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    apply_reset();
    seq.randomize();
    seq.start(e0.a0.s0);
    phase.drop_objection(this);
  endtask
  
  virtual task apply_reset();
    vif.rst <= 1;
    repeat(5) @ (posedge vif.clk);
    @ (negedge vif.clk);
    vif.rst <= 0;
  endtask
  
endclass

class up_test extends base_test;
  `uvm_component_utils(up_test)
  
  function new(string name = "up_test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = up_item_seq::type_id::create("seq");
  endfunction
endclass

class down_test extends base_test;
  `uvm_component_utils(down_test)
  
  function new(string name = "down_test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = down_item_seq::type_id::create("seq");
  endfunction
endclass
