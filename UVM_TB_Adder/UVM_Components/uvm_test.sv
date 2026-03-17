class test extends uvm_test;
  `uvm_component_utils(test);
  
  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual adder_if vif;
  env e0;
  item_seq seq;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e0 = env::type_id::create("env", this);
    if(!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", vif))
      `uvm_fatal("ENV","Virtual iterface not found");
    uvm_config_db#(virtual adder_if)::set(this, "e0.a0.*", "adder_vif", vif);
    seq = item_seq::type_id::create("seq");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.randomize();
    seq.start(e0.a0.s0);
    phase.drop_objection(this);
  endtask
endclass
