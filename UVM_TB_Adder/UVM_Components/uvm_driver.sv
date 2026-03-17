class driver extends uvm_driver#(item);
  `uvm_component_utils(driver)
  
  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual adder_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", vif))
      `uvm_fatal("DRV", "Could not get vif");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item d_item;
      seq_item_port.get_next_item(d_item);
      vif.a = d_item.a;
      vif.b = d_item.b;
      vif.cin = d_item.cin;
      #0;
      seq_item_port.item_done();
      #1;
    end
  endtask
endclass
