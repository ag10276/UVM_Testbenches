class test extends uvm_test;
  `uvm_component_utils(test)
  
  env e0;
  item_seq seq;
  
  virtual comp_if vif;
  
  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e0 = env::type_id::create("e0", this);
    if(!uvm_config_db#(virtual comp_if)::get(this, "", "comp_vif", vif))
      `uvm_fatal("TEST", "Could not get virtual interface");
    uvm_config_db#(virtual comp_if)::set(this, "e0.a0.*", "comp_vif", vif);
    seq = item_seq::type_id::create("seq");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.randomize();
    seq.start(e0.a0.s0);
    phase.drop_objection(this);
  endtask
endclass