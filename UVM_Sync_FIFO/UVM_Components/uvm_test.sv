class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  
  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  env e0;
  virtual sync_fifo_if vif;
  item_seq seq;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual sync_fifo_if)::get(this, "", "sync_fifo_vif", vif))
      `uvm_fatal("ENV", "Virtual Interface not found!");
    uvm_config_db#(virtual sync_fifo_if)::set(this, "e0.a0.*", "sync_fifo_vif", vif);
    e0 = env::type_id::create("e0", this);
    seq = item_seq::type_id::create("seq");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq.randomize();
    seq.start(e0.a0.s0);
    phase.drop_objection(this);
  endtask
  
endclass
        
class write_test extends base_test;
  `uvm_component_utils(write_test)

  function new(string name="write_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    item_seq::type_id::set_type_override(write_fifo::get_type());
    super.build_phase(phase);
  endfunction
endclass

class read_test extends base_test;
  `uvm_component_utils(read_test)

  function new(string name="read_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    item_seq::type_id::set_type_override(read_fifo::get_type());
    super.build_phase(phase);
  endfunction
endclass
        
