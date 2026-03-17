class driver extends uvm_driver#(item);
  `uvm_component_utils(driver)
  
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual fsm_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fsm_if)::get(this, "", "fsm_vif", vif))
      `uvm_fatal("DRV", "Virtual Interface not found!");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item d_item;
      seq_item_port.get_next_item(d_item);
      @(vif.cb);
      vif.reset <= d_item.reset;
      seq_item_port.item_done();
    end
  endtask
endclass
