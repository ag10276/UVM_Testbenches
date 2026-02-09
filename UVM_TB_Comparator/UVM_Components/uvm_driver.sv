class driver extends uvm_driver#(item);
  `uvm_component_utils(driver)
  
  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual comp_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual comp_if)::get(this, "", "comp_vif",vif))
      `uvm_fatal("DRV", "Could not get virtual interface");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item m_item;
      seq_item_port.get_next_item(m_item);
      vif.a = m_item.a;
      vif.b = m_item.b;
      #0;
      seq_item_port.item_done();
      #1;
    end
  endtask
endclass