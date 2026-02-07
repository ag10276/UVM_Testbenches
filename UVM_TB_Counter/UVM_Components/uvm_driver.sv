class driver extends uvm_driver#(item);
  `uvm_component_utils(driver)
  
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual counter_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual counter_if)::get(this, "", "counter_vif", vif)) `uvm_fatal("DRV", "VIF not found");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item m_item;
      seq_item_port.get_next_item(m_item);
      @(vif.cb_drv);
      vif.rst <= m_item.rst;
      vif.up <= m_item.up;
      seq_item_port.item_done();
    end
  endtask
endclass
