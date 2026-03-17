class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  
  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  env e0;
  virtual fsm_if vif;
  item_seq seq;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fsm_if)::get(this, "", "fsm_vif", vif))
      `uvm_fatal("ENV", "Virtual Interface not found!");
    uvm_config_db#(virtual fsm_if)::set(this, "e0.a0.*", "fsm_vif", vif);
    e0 = env::type_id::create("e0", this);
    seq = item_seq::type_id::create("seq", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq.randomize();
    seq.start(e0.a0.s0);
    phase.drop_objection(this);
  endtask
  
endclass
