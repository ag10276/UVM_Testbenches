class driver extends uvm_driver#(item);
  `uvm_component_utils(driver)
  
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual alu_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_if)::get(this, "", "alu_vif", vif))
      `uvm_fatal("DRV", "VIF not found");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item d_item;
      seq_item_port.get_next_item(d_item);
      vif.a = d_item.a;
      vif.b = d_item.b;
      vif.opcode = d_item.opcode;
      #0;
      seq_item_port.item_done();
      #1;
    end
  endtask
endclass
